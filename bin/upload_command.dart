import 'dart:io';

import 'package:dcli/dcli.dart' hide env;
import 'package:discord_drive_cli/discord_drive.dart';
import 'package:sha_env/sha_env.dart';

Future<void> uploadCommand() async {
  String path = ask("path:");

  String driveChannelId = env["DRIVE_CHANNEL_ID"];
  String indexChannelId = env["INDEX_CHANNEL_ID"];
  String rootIndexMessageId = env["ROOT_INDEX_MESSAGE_ID"];
  String botToken = env["BOT_TOKEN"];

  var drive = await DiscordDrive(driveChannelId, indexChannelId, rootIndexMessageId).connect(botToken);

  var file = File(path).openRead();

  //drive.uploadFile();
}
