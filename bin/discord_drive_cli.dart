import 'package:dcli/dcli.dart';
import 'package:sha_env/sha_env.dart';

import 'list_command.dart';
import 'test_command.dart';
import 'upload_command.dart';

const String version = '0.0.1';

void main(List<String> arguments) async {
  await ShaEnv().load();

  loop:
  while (true) {
    final command = ask(">");
    switch (command) {
      case "?":
      case "h":
      case "help":
        // TODO
        print("TODO");
        break;

      case "ls":
      case "list":
        await listCommand();
        break;

      case "test":
        await testCommand();
        break;

      case "upload":
        await uploadCommand();
        break;

      case "q":
      case "x":
      case "exit":
        break loop;
    }
  }
}
