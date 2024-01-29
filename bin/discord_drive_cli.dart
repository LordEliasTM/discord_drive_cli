import 'package:args/command_runner.dart';
import 'package:sha_env/sha_env.dart';

import 'first_use_init_command.dart';
import 'list_command.dart';

const String version = '0.0.1';

void main(List<String> arguments) async {
  await ShaEnv().load();

  CommandRunner runner = CommandRunner("discordDrive", "Discord Drive")
    ..addCommand(FirstUseInitCommand())
    ..addCommand(ListCommand());
  runner.run(arguments);
}
