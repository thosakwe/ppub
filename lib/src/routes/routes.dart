import 'package:angel_framework/angel_framework.dart';
import 'package:angel_orm/angel_orm.dart';
import 'package:file/file.dart';
import 'package:http_parser/http_parser.dart';
import 'package:path/path.dart' as p;
import 'package:private_pub/private_pub.dart';
import 'package.dart';

AngelConfigurer configureServer(FileSystem fs) {
  return (Angel app) {
    var executor = app.container.make<QueryExecutor>();
    configureRouter(fs, executor)(app);
  };
}

void Function(Router<RequestHandler>) configureRouter(
    FileSystem fs, QueryExecutor executor) {
  return (router) {
    router.group('/api/packages', packageRoutes(fs, executor));

    router.get(r'/packages/:name/versions/:versionName.tar.gz',
        (req, res) async {
      // TODO: Resolve upload dir using config
      // TODO: Use pkg:file
      // TODO: Angel is lumping ".tar.gz" into versionName
      var name = req.params['name'] as String;
      var versionName = req.params['versionName'] as String;
      var archiveBasename = '$name-$versionName';
      var archivePath =
          p.join(defaultConfigDirectory, './uploads', archiveBasename);
      var archiveFile = fs.file(archivePath);
      print(archivePath);

      if (!await archiveFile.exists()) {
        throw AngelHttpException.notFound();
      } else {
        await res.streamFile(archiveFile);
      }
    });
  };
}
