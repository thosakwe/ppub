import 'dart:async';
import 'dart:convert';
import 'dart:io' show gzip, BytesBuilder;
import 'package:angel_framework/angel_framework.dart';
import 'package:archive/archive.dart';
import 'package:angel_orm/angel_orm.dart';
import 'package:file/file.dart';
import 'package:private_pub/models.dart';
import 'package:private_pub/private_pub.dart';
import 'package:pubspec_parse/pubspec_parse.dart';
import 'package:yaml/yaml.dart' as yaml;
import 'common.dart';

// TODO: Root URL that lists packages
// TODO: Search endpoint
void Function(Router<RequestHandler>) packageRoutes(
    FileSystem fs, QueryExecutor executor, Uri apiRoot,
    {String packagesPath: 'packages'}) {
  return (router) {
    var p = fs.path;

    Future<bool> resolvePackage(RequestContext req, ResponseContext res) async {
      print('Request URI: ${req.uri}');

      var query = PackageQuery()
        ..where.name.equals(req.params['name'] as String);
      var package = await query.getOne(executor);

      if (package == null) {
        throw AngelHttpException.notFound();
      } else {
        req.container.registerSingleton<Package>(package);
        return true;
      }
    }

    router.get('/versions/new', (req, res) async {
      // Figure out the path
      var uploadUri =
          apiRoot.replace(path: p.join(apiRoot.path, packagesPath, 'upload'));
      return {'fields': {}, 'url': uploadUri.toString()};
    });

    router.post(
      '/upload',
      chain([
        resolveUser,
        (req, res) async {
          var userId = req.container.make<User>().idAsInt;
          await req.parseBody();

          if (req.uploadedFiles.isEmpty) {
            throw AngelHttpException.badRequest(
                message: 'No file was uploaded.');
          }

          // Ensure it's an archive.
          var file = req.uploadedFiles.first;
          if (!file.filename.endsWith('.tar.gz')) {
            throw AngelHttpException.badRequest(
                message: 'Only .tar.gz files may be uploaded.');
          }

          // Read the archive.
          var gzippedArchiveBytes = await file.data
              .fold<BytesBuilder>(BytesBuilder(), (bb, buf) => bb..add(buf))
              .then((bb) => bb.takeBytes());
          var archive =
              TarDecoder().decodeBytes(gzip.decode(gzippedArchiveBytes));

          // Find and parse the pubspec file
          var pubspecFile = archive.files.firstWhere(
              (f) => f.isFile && f.name == 'pubspec.yaml',
              orElse: () => throw AngelHttpException.badRequest(
                  message: 'Missing "pubspec.yaml" file.'));
          var pubspecYaml = utf8.decode(pubspecFile.rawContent.toUint8List());
          var pubspecMap =
              yaml.loadYaml(pubspecYaml, sourceUrl: 'pubspec.yaml') as Map;
          var pubspec = Pubspec.fromJson(pubspecMap, lenient: true);

          // Check if such a package already exists.
          var packageQuery = PackageQuery()..where.name.equals(pubspec.name);
          var package = await packageQuery.getOne(executor);

          // If the package doesn't exist, create it, and add an uploader.
          if (package == null) {
            var insertion = PackageQuery();
            insertion.values
              ..name = pubspec.name
              ..createdAt = DateTime.now();
            package = await insertion.insert(executor);

            var uploader = UploaderQuery();
            uploader.values
              ..packageId = package.idAsInt
              ..userId = userId;
            await uploader.insert(executor);
          }

          // Otherwise, make sure the user is an uploader
          else {
            var query = UploaderQuery();
            query.where
              ..packageId.equals(package.idAsInt)
              ..userId.equals(userId);
            var uploader = await query.get(executor);

            // If the user is not allowed, let them know they have been forbidden.
            if (uploader == null) {
              var uri = apiRoot.replace(
                  path: p.join(
                      apiRoot.path, packagesPath, 'upload', 'forbidden'));
              res.redirect(uri.toString());
              return;
            }
          }

          // Check if such a version already exists.
          if (package.versions.any((v) => v.version == pubspec.version)) {
            var uri = apiRoot.replace(
                path: p.join(apiRoot.path, packagesPath, 'upload', 'exists'),
                queryParameters: {
                  'package': pubspec.name,
                  'version': pubspec.version.toString()
                });
            res.redirect(uri.toString());
            return;
          }

          // Create the new version in the database.
          // /:name/versions/:versionName.tar.gz
          var archiveBasename = '${pubspec.name}-${pubspec.version}.tar.gz';
          var archiveUrl = apiRoot.replace(
              path: p.join(apiRoot.path, packagesPath, pubspec.name, 'versions',
                  pubspec.version.toString() + '.tar.gz'),
              queryParameters: {
                'package': pubspec.name,
                'version': pubspec.version.toString()
              });

          var versionQuery = PackageVersionQuery();
          versionQuery.values
            ..packageId = package.idAsInt
            ..pubspecMap = pubspecMap
            ..versionString = pubspec.version.toString()
            ..archiveUrl = archiveUrl.toString()
            ..createdAt = DateTime.now();
          await versionQuery.insert(executor);

          // Save the file.
          var archivePath =
              p.join(defaultConfigDirectory, './uploads', archiveBasename);
          var archiveFile = fs.file(archivePath);
          await archiveFile.create(recursive: true);
          await archiveFile.writeAsBytes(gzippedArchiveBytes);

          res.redirect(apiRoot.replace(
              path: p.join(apiRoot.path, packagesPath, 'upload', 'success')));
        },
      ]),
    );

    router.get('/upload/success', (req, res) {
      return {
        'success': {'message': 'Successfully uploaded package.'}
      };
    });

    router.get('/upload/exists', (req, res) {
      var package = req.queryParameters['package'];
      var version = req.queryParameters['version'];
      res.statusCode = 400;
      return {
        'error': {'message': 'Version $version of $package already exists...'}
      };
    });

    router.get('/upload/forbidden', (req, res) {
      res.statusCode = 403;
      return {
        'error': {
          'message': 'You do not have permission to upload this package.'
        }
      };
    });

    router.get(
      '/:name',
      chain([
        resolvePackage,
        (req, res) {
          var package = req.container.make<Package>();
          return package.toApiJson();
        },
      ]),
    );

    router.get(
      '/:name/versions',
      chain([
        resolvePackage,
        (req, res) {
          var package = req.container.make<Package>();
          return package.versions.map((v) => v.toApiJson()).toList();
        },
      ]),
    );
  };
}
