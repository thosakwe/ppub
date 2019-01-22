import 'dart:convert';
import 'dart:io' show gzip, BytesBuilder;
import 'package:angel_framework/angel_framework.dart';
import 'package:archive/archive.dart';
import 'package:angel_orm/angel_orm.dart';
import 'package:file/file.dart';
import 'package:private_pub/models.dart';
import 'package:private_pub/private_pub.dart';
import 'package:pubspec_parse/pubspec_parse.dart';

// TODO: Authentication
// TODO: Root URL that lists packages
// TODO: Search endpoint
void Function(Router<RequestHandler>) packageRoutes(
    FileSystem fs, QueryExecutor executor, Uri apiRoot) {
  return (router) {
    var p = fs.path;
    Future<bool> resolvePackage(RequestContext req, ResponseContext res) async {
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

    // TODO: Authentication
    router.get('/versions/new', (req, res) async {
      // Figure out the path
      // TODO: Add a config option for the host path
      var pkgRoot = p.dirname(p.dirname(req.uri.path));
      var uploadPath = p.join(pkgRoot, 'upload');
      var uploadUri = req.uri.replace(path: uploadPath);
      uploadUri =
          uploadUri.replace(scheme: 'http', host: 'localhost', port: 3000);
      return {'fields': {}, 'url': uploadUri.toString()};
    });

    // TODO: Authentication + uploader check
    router.post('/upload', (req, res) async {
      await req.parseBody();

      if (req.uploadedFiles.isEmpty) {
        throw AngelHttpException.badRequest(message: 'No file was uploaded.');
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
      var archive = TarDecoder().decodeBytes(gzip.decode(gzippedArchiveBytes));

      // Find and parse the pubspec file
      var pubspecFile = archive.files.firstWhere(
          (f) => f.isFile && f.name == 'pubspec.yaml',
          orElse: () => throw AngelHttpException.badRequest(
              message: 'Missing "pubspec.yaml" file.'));
      var pubspecYaml = utf8.decode(pubspecFile.rawContent.toUint8List());
      var pubspec = Pubspec.parse(pubspecYaml, sourceUrl: 'pubspec.yaml');

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
        // TODO: Uploader
      }

      // Otherwise, make sure the user is an uploader
      else {
        // TODO: Uploader
      }

      // Check if such a version already exists.
      if (package.versions.any((v) => v.version == pubspec.version)) {
        var uri = apiRoot.replace(
            path: p.join(apiRoot.path, 'packages', 'upload', 'exists'),
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
          path: p.join(apiRoot.path, 'packages', pubspec.name, 'versions',
              pubspec.version.toString() + '.tar.gz'),
          queryParameters: {
            'package': pubspec.name,
            'version': pubspec.version.toString()
          });

      var versionQuery = PackageVersionQuery();
      versionQuery.values
        ..packageId = package.idAsInt
        ..pubspecYaml = pubspecYaml
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
          path: p.join(apiRoot.path, 'packages', 'upload', 'success')));
    });

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
