import 'dart:async';
import 'package:args/command_runner.dart';
import 'package:private_pub/commands.dart';

Future main(List<String> args) {
  var runner = CommandRunner('ppub', 'Private Pub host.')
    ..addCommand(InstallCommand())
    ..addCommand(StartCommand());
  return runner.run(args);
}
