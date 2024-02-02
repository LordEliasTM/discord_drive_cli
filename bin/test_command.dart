import 'package:args/command_runner.dart';
import 'package:discord_drive_cli/discord_drive.dart';
import 'package:discord_drive_cli/index_types.dart';
import 'package:sha_env/sha_env.dart';

class TestCommand extends Command {
  @override
  final name = "test";
  @override
  final description = "test";

  @override
  Future<void> run() async {
    var driveChannelId = int.parse(env["DRIVE_CHANNEL_ID"]);
    var indexChannelId = int.parse(env["INDEX_CHANNEL_ID"]);
    var rootIndexMessageId = int.parse(env["ROOT_INDEX_MESSAGE_ID"]);
    var botToken = env["BOT_TOKEN"];

    var drive = await DiscordDrive(driveChannelId, indexChannelId, rootIndexMessageId).connect(botToken);

    var entries = [
      FileEntry(nameLength: 4, name: "Test", chunkMessageId: 1201581445228015746),
    ];
    var index = FolderIndex(version: 1, lastEdit: DateTime.now().millisecondsSinceEpoch, next: 0, entries: entries);

    await drive.index.writeIndex(index);

    var index2 = await drive.index.readIndex();
    print(index2.version);
    print(index2.lastEdit);
    for (var element in index2.entries) {
      print(element.name);
    }
  }
}
