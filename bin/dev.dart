import 'dart:async';
import 'dart:io';
import 'package:angel_framework/angel_framework.dart';
import 'package:angel_hot/angel_hot.dart';
import 'package:file/local.dart';
import 'package:logging/logging.dart';
import 'package:private_pub/private_pub.dart' as ppub;

main() async {
  var hot = HotReloader(createServer, [Directory('lib')]);
  hierarchicalLoggingEnabled = true;
  await hot.startServer('127.0.0.1', 3000);
  print('ppub dev listening at http://localhost:3000');
}

Future<Angel> createServer() async {
  var app = Angel();
  var logger = app.logger = Logger('ppub')
    ..onRecord.listen((rec) {
      print(rec);
      if (rec.error != null) print(rec.error);
      if (rec.stackTrace != null) print(rec.stackTrace);
    });

  app.shutdownHooks.add((_) {
    logger.clearListeners();
  });

  var fs = LocalFileSystem();

  await app.configure(ppub.configureServer(fs, './config'));

  return app;
}
