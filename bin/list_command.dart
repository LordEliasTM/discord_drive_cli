import 'package:args/command_runner.dart';
import 'package:discord_drive_cli/discord_drive.dart';
import 'package:sha_env/sha_env.dart';

class ListCommand extends Command {
  @override
  final name = "list";
  @override
  final description = "List cloud content";

  @override
  Future<void> run() async {
    var drive = DiscordDrive(env["DRIVE_CHANNEL_ID"], env["INDEX_CHANNEL_ID"], env["ROOT_INDEX_MESSAGE_ID"])
      ..connect(env["BOT_TOKEN"]);

    // TODO
  }
}
