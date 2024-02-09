import 'package:discord_drive_cli/discord_drive.dart';
import 'package:discord_drive_cli/index_types.dart';
import 'package:sha_env/sha_env.dart';

Future<void> listCommand() async {
  final String driveChannelId = env['DRIVE_CHANNEL_ID'];
  final String indexChannelId = env['INDEX_CHANNEL_ID'];
  final String rootIndexMessageId = env['ROOT_INDEX_MESSAGE_ID'];
  final String botToken = env['BOT_TOKEN'];

  final DiscordDrive drive = DiscordDrive(
    driveChannelId: driveChannelId,
    indexChannelId: indexChannelId,
    rootIndexMessageId: rootIndexMessageId,
  );

  await drive.connect(botToken);

  final FolderIndex index = await drive.index.readIndex();

  String result = '';
  for (FolderEntry folder in index.folders) {
    result += '📁 ${folder.name}\n';
  }
  for (FileEntry file in index.files) {
    result += '📄 ${file.name}\n';
  }
  result = result.substring(0, result.length - 1);

  print(result);
}
