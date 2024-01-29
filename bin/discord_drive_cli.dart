import 'dart:io';

import 'package:args/command_runner.dart';
import 'package:discord_drive_cli/discord_drive.dart';

const String version = '0.0.1';

void main(List<String> arguments) async {
  CommandRunner runner = CommandRunner("discordDrive", "Discord Drive")..addCommand(FirstUseInitCommand());
  runner.run(arguments);
}

class FirstUseInitCommand extends Command {
  @override
  final name = "firstuse";
  @override
  final description = "Creates category and required channels in provided guild. Saves result into .env file.";

  String get guildId => argResults!.rest[0];
  String get token => argResults!.rest[1];

  FirstUseInitCommand();

  @override
  Future<void> run() async {
    print("creating channels");

    var (driveChannelId, indexChannelId, rootIndexMessageId) =
        await DiscordDrive.firstUseInit(int.parse(guildId), token);

    print("saving .env");

    var file = await File(".env").create();
    file.writeAsString("""
DRIVE_CHANNEL_ID = "$driveChannelId"
INDEX_CHANNEL_ID = "$indexChannelId"
ROOT_INDEX_MESSAGE_ID = "$rootIndexMessageId"
BOT_TOKEN = "$token"
""");
  }
}
