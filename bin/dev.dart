import 'dart:async';
import 'dart:io';
import 'package:angel_framework/angel_framework.dart';
import 'package:angel_hot/angel_hot.dart';
import 'package:file/local.dart';
import 'package:io/ansi.dart';
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
  app.logger = Logger.detached('ppub')..onRecord.listen(prettyLog);

  app.shutdownHooks.add((_) {
    app.logger.clearListeners();
  });

  var fs = LocalFileSystem();

  await app.configure(ppub.configureServer(fs, ppub.defaultConfigDirectory));

  return app;
}

/// Prints the contents of a [LogRecord] with pretty colors.
void prettyLog(LogRecord record) {
  var code = chooseLogColor(record.level);

  if (record.error == null) print(code.wrap(record.toString()));

  if (record.error != null) {
    var err = record.error;
    if (err is AngelHttpException && err.statusCode != 500) return;
    print(code.wrap(record.toString() + '\n'));
    print(code.wrap(err.toString()));

    if (record.stackTrace != null) {
      print(code.wrap(record.stackTrace.toString()));
    }
  }
}

/// Chooses a color based on the logger [level].
AnsiCode chooseLogColor(Level level) {
  if (level == Level.SHOUT)
    return backgroundRed;
  else if (level == Level.SEVERE)
    return red;
  else if (level == Level.WARNING)
    return yellow;
  else if (level == Level.INFO)
    return cyan;
  else if (level == Level.FINER || level == Level.FINEST) return lightGray;
  return resetAll;
}
