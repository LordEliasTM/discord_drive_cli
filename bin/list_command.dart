import 'package:discord_drive_cli/discord_drive.dart';
import 'package:sha_env/sha_env.dart';

Future<void> listCommand() async {
  String driveChannelId = env["DRIVE_CHANNEL_ID"];
  String indexChannelId = env["INDEX_CHANNEL_ID"];
  String rootIndexMessageId = env["ROOT_INDEX_MESSAGE_ID"];
  String botToken = env["BOT_TOKEN"];

  var drive = await DiscordDrive(driveChannelId, indexChannelId, rootIndexMessageId).connect(botToken);

  var index = await drive.index.readIndex();

  String result = "";
  for (var folder in index.folders) {
    result += "📁 ${folder.name}\n";
  }
  for (var file in index.files) {
    result += "📄 ${file.name}\n";
  }
  result = result.substring(0, result.length - 1);

  print(result);
}
