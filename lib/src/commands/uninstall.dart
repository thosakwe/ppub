import 'dart:io';

import 'package:angel_migration_runner/angel_migration_runner.dart';
import 'package:args/command_runner.dart';
import 'package:io/ansi.dart';
import 'package:prompts/prompts.dart' as prompts;
import 'install.dart';

class UninstallCommand extends Command {
  @override
  String get name => 'uninstall';

  @override
  String get description => 'Delete configuration, and drop the database.';

  @override
  Future<bool> run() async {
    if (await configFile.exists()) {
      var deleteMessage = 'Delete existing configuration "${configFile.path}"?';

      if (!prompts.getBool(deleteMessage)) {
        print('Not modifying current configuration.');
        return false;
      } else {
        var runner = await createMigrationRunner();
        var connection = await connectToInstalledPostgres();
        var username = connection.username;
        var password = connection.password;
        var host = connection.host;
        var databaseName = connection.databaseName;
        var port = connection.port;

        await runMigrations(runner, ['reset']);

        // Run psql and create the database
        // postgresql://[user[:password]@][netloc][:port][/dbname]
        var pgUri = Uri(
            scheme: 'postgresql',
            userInfo: '$username:$password',
            host: host,
            port: port);
        var psqlArgs = [
          '-c',
          'DROP DATABASE "$databaseName";',
          pgUri.toString()
        ];
        var pgInvocation = 'psql ${psqlArgs.join(' ')}';

        print(lightGray.wrap('Running `$pgInvocation`'));
        var psql = await Process.start('psql', psqlArgs,
            runInShell: true, mode: ProcessStartMode.inheritStdio);
        var code = await psql.exitCode;

        if (code != 0) {
          print('`$pgInvocation` terminated with exit code $code.');
          exitCode = 1;
          return false;
        }

        await configFile.parent.delete(recursive: true);
        return true;
      }
    } else {
      return true;
    }
  }
}
