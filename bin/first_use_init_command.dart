import 'dart:io';

import 'package:args/command_runner.dart';
import 'package:discord_drive_cli/discord_drive.dart';

class FirstUseInitCommand extends Command {
  @override
  final String name = 'firstuse';
  @override
  final String description = 'Creates category and required channels in provided guild. Saves result into .env file.';

  String get guildId => argResults!.rest[0];
  String get token => argResults!.rest[1];

  @override
  Future<void> run() async {
    print('creating channels');

    final (int driveChannelId, int indexChannelId, int rootIndexMessageId) =
        await DiscordDrive.firstUseInit(int.parse(guildId), token);

    print('saving .env');

    final File file = await File('.env').create();
    await file.writeAsString('''
DRIVE_CHANNEL_ID = "$driveChannelId"
INDEX_CHANNEL_ID = "$indexChannelId"
ROOT_INDEX_MESSAGE_ID = "$rootIndexMessageId"
BOT_TOKEN = "$token"
''');
  }
}
