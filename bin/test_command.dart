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
    String driveChannelId = env["DRIVE_CHANNEL_ID"];
    String indexChannelId = env["INDEX_CHANNEL_ID"];
    String rootIndexMessageId = env["ROOT_INDEX_MESSAGE_ID"];
    String botToken = env["BOT_TOKEN"];

    var drive = await DiscordDrive(driveChannelId, indexChannelId, rootIndexMessageId).connect(botToken);

    var files = [
      FileEntry(name: "Test", chunkMessageId: 1201581445228015746, size: 128),
    ];
    var index = FolderIndex(version: 1, lastEdit: DateTime.now().millisecondsSinceEpoch, files: files, folders: []);

    await drive.index.writeIndex(index);

    var index2 = await drive.index.readIndex();
    print(index2.version);
    print(index2.lastEdit);
    for (var file in index2.files) {
      print(file.name);
      print(file.chunkMessageId);
      print(file.size);
    }
    for (var file in index2.folders) {
      print(file.name);
      print(file.indexMessageId);
    }
  }
}
