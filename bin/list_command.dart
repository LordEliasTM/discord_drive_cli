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
    String driveChannelId = env["DRIVE_CHANNEL_ID"];
    String indexChannelId = env["INDEX_CHANNEL_ID"];
    String rootIndexMessageId = env["ROOT_INDEX_MESSAGE_ID"];
    String botToken = env["BOT_TOKEN"];

    var drive = await DiscordDrive(driveChannelId, indexChannelId, rootIndexMessageId).connect(botToken);

    var index = await drive.index.readIndex();

    print(index);
  }
}
