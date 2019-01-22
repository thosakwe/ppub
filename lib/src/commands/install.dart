import 'dart:async';
import 'dart:io';
import 'package:angel_migration_runner/angel_migration_runner.dart';
import 'package:angel_migration_runner/postgres.dart';
import 'package:args/command_runner.dart';
import 'package:io/ansi.dart';
import 'package:path/path.dart' as p;
import 'package:postgres/postgres.dart';
import 'package:private_pub/models.dart';
import 'package:private_pub/private_pub.dart';
import 'package:prompts/prompts.dart' as prompts;
import 'package:yaml/yaml.dart' as yaml;

File get configFile {
  return File(p.join(defaultConfigDirectory, 'config.yaml'));
}

Future<PostgreSQLConnection> connectToInstalledPostgres() async {
  var config = await yaml.loadYaml(await configFile.readAsString(),
      sourceUrl: configFile.uri);
  return connectToPostgres(config as Map)();
}

Future<PostgresMigrationRunner> createMigrationRunner() async {
  var connection = await connectToInstalledPostgres();
  return PostgresMigrationRunner(connection, migrations: [
    UserMigration(),
    PackageVersionMigration(),
    PackageMigration(),
    UploaderMigration(),
  ]);
}

class InstallCommand extends Command {
  @override
  String get name => 'install';

  @override
  String get description => 'Installs files and configures the database.';

  @override
  Future run() async {
    // Create the config file.
    var uploadPathMessage =
        'Upload directory (relative to $defaultConfigDirectory)';
    var genConfigFile = !await configFile.exists();

    if (!genConfigFile) {
      genConfigFile = await runner.run(['uninstall']) as bool;
    }

    if (genConfigFile) {
      await configFile.create(recursive: true);

      print(
          'Fill in the following prompts to configure the application and database.');
      print(
          'To force ppub to read an environment variable, prefix its name with "\$", ex. \$USER.');
      print('Configuration will be written to ${configFile.path}.\n');

      // Uploads config
      var sink = await configFile.openWrite();
      var apiRoot = prompts.get('Public API root',
          defaultsTo: 'http://localhost:3000/api');
      sink.writeln('api_root: "$apiRoot"');

      var uploadPath = prompts.get(uploadPathMessage, defaultsTo: './uploads');
      sink.writeln('uploads:\n  path: "$uploadPath"');

      // Postgres
      var host = prompts.get('PostgreSQL hostname', defaultsTo: 'localhost');
      var port =
          prompts.get('PostgreSQL port', defaultsTo: '5432', validate: (s) {
        var i = int.tryParse(s);
        return i != null && i >= 0;
      });
      var databaseName = prompts.get('Database name', defaultsTo: 'ppub');
      var username = prompts.get('PostgreSQL username', defaultsTo: 'postgres');
      var password = prompts.get('PostgreSQL password', defaultsTo: 'postgres');
      var useSSL = prompts.getBool('Use SSL for PostgreSQL?');
      sink
        ..writeln('postgres:')
        ..writeln('  host: "$host"')
        ..writeln('  port: $port')
        ..writeln('  database_name: "$databaseName"')
        ..writeln('  username: "$username"')
        ..writeln('  password: "$password"')
        ..writeln('  use_ssl: $useSSL');

      await sink.close();

      // Config is done, now run the migrations.

      // Run psql and create the database
      // postgresql://[user[:password]@][netloc][:port][/dbname]
      var pgUri = Uri(
          scheme: 'postgresql',
          userInfo: '$username:$password',
          host: host,
          port: int.parse(port));
      var psqlArgs = [
        '-c',
        'CREATE DATABASE "$databaseName";',
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
        return;
      }

      var runner = await createMigrationRunner();
      await runMigrations(runner, ['up']);

      // TODO: Daemon, systemd, nginx
      // if (Platform.isLinux) {
      //   var startAsDaemon = prompts.getBool('Start ppub daemon now?');
      // }

      print(cyan.wrap('ppub is now installed!'));
    }
  }
}
