import 'package:angel_framework/angel_framework.dart';
import 'package:angel_orm/angel_orm.dart';
import 'package:angel_static/angel_static.dart';
import 'package:file/file.dart';
import 'package:path/path.dart' as p;
import 'package:private_pub/private_pub.dart';
import 'package.dart';

AngelConfigurer configureServer(FileSystem fs) {
  return (Angel app) {
    var executor = app.container.make<QueryExecutor>();
    var apiRoot = Uri.parse(app.configuration['api_root'] as String);
    var uploadDirBase = app.configuration['uploads']['path'] as String;
    var uploadDirPath = p.join(defaultConfigDirectory, uploadDirBase);
    configureRouter(app, fs, fs.directory(uploadDirPath), executor, apiRoot)(app);
  };
}

void Function(Router<RequestHandler>) configureRouter(
    Angel app, FileSystem fs, Directory uploadDir, QueryExecutor executor, Uri apiRoot) {
  return (router) {
    var vDir = CachingVirtualDirectory(app, fs, source: uploadDir);

    router.group('/api/packages', packageRoutes(fs, executor, apiRoot));

    router.get(r'/packages/:name/versions/:versionName.tar.gz', (req, res) {
      // TODO: Angel is lumping ".tar.gz" into versionName
      var name = req.params['name'] as String;
      var versionName = req.params['versionName'] as String;
      var archiveBasename = '$name-$versionName';
      return vDir.servePath(archiveBasename, req, res);
    });
  };
}
