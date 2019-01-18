import 'dart:io';
import 'package:angel_framework/angel_framework.dart';
import 'package:angel_production/angel_production.dart';
import 'package:args/command_runner.dart';
import 'package:file/local.dart';
import 'package:private_pub/private_pub.dart' as ppub;

class StartCommand extends Command {
  @override
  String get name => 'start';

  @override
  String get description => 'Run the standalone server in this shell.';

  StartCommand() {
    argParser
      ..addFlag('respawn',
          help: 'Automatically respawn crashed application instances.',
          defaultsTo: true,
          negatable: true)
      ..addFlag('use-zone',
          negatable: false, help: 'Create a new Zone for each request.')
      ..addOption('address',
          abbr: 'a', defaultsTo: '127.0.0.1', help: 'The address to listen on.')
      ..addOption('concurrency',
          abbr: 'j',
          defaultsTo: Platform.numberOfProcessors.toString(),
          help: 'The number of isolates to spawn.')
      ..addOption('port',
          abbr: 'p', defaultsTo: '3000', help: 'The port to listen on.');
  }

  static Future _configureServer(Angel app) async {
    var configurer =
        ppub.configureServer(LocalFileSystem(), ppub.defaultConfigDirectory);
    await app.configure(configurer);
  }

  @override
  Future run() {
    var runner = Runner('ppub', _configureServer);
    return runner.run(argResults.arguments);
  }
}
