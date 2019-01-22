import 'dart:io';
import 'package:angel_configuration/angel_configuration.dart';
import 'package:angel_framework/angel_framework.dart';
import 'package:angel_orm/angel_orm.dart';
import 'package:angel_orm_postgres/angel_orm_postgres.dart';
import 'package:file/file.dart';
import 'package:path/path.dart' as p;
import 'package:postgres/postgres.dart';
import 'src/routes/routes.dart' as routes;

String get defaultConfigDirectory {
  var homeDir = Platform.isWindows
      ? Platform.environment['USERPROFILE']
      : Platform.environment['HOME'];

  if (homeDir == null) {
    throw ArgumentError.value(homeDir, r'$HOME or %USERPROFILE%',
        'must be present in the environment');
  } else {
    return p.join(homeDir, '.ppub');
  }
}

PostgreSQLConnection Function() connectToPostgres(Map globalConfiguration) {
  var postgresConfig = globalConfiguration['postgres'] ?? {};

  if (postgresConfig is Map) {
    return () {
      return PostgreSQLConnection(
        postgresConfig['host'] as String ?? 'localhost',
        postgresConfig['port'] as int ?? 5432,
        postgresConfig['database_name'] as String ?? 'ppub',
        username: postgresConfig['username'] as String,
        password: postgresConfig['password'] as String,
        useSSL: postgresConfig['use_ssl'] == true,
      );
    };
  } else {
    throw ArgumentError.value(
        postgresConfig, '"postgres" configuration object', 'must be a Map');
  }
}

AngelConfigurer configureServer(FileSystem fs, String configDirectory) {
  return (app) async {
    // Load the config file
    await app.configure(configuration(fs,
        directoryPath: configDirectory, overrideEnvironmentName: 'config'));

    // Set up PostgreSQL
    var connection = connectToPostgres(app.configuration)();
    var executor = PostgreSQLExecutor(connection);
    await connection.open();

    app
      ..container.registerSingleton<QueryExecutor>(executor)
      ..shutdownHooks.add((_) => executor.close());

    await app.configure(routes.configureServer(fs));

    // Default to 404
    app.fallback((req, res) => throw AngelHttpException.notFound());

    // Send errors as JSON
    app.errorHandler = (e, req, res) async {
      res
        ..statusCode = e.statusCode
        ..write(e.message);
      await res.close();
    };
  };
}
