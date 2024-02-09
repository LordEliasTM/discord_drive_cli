import 'dart:io';

import 'package:dcli/dcli.dart' hide env;
import 'package:discord_drive_cli/discord_drive.dart';
import 'package:sha_env/sha_env.dart';

Future<void> uploadCommand() async {
  final String path = ask('path:');

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

  final Stream<List<int>> file = File(path).openRead();

  //drive.uploadFile();
}
