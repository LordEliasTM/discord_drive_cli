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

    var lastEdit = DateTime.now().millisecondsSinceEpoch;
    var files = [
      FileEntry(name: "Test1", chunkMessageId: 1201581445228015746, size: 255),
      FileEntry(name: "Test2", chunkMessageId: 1201581445228015746, size: 255),
      FileEntry(name: "Test3", chunkMessageId: 1201581445228015746, size: 255),
      FileEntry(name: "Test4", chunkMessageId: 1201581445228015746, size: 255),
      FileEntry(name: "Test5", chunkMessageId: 1201581445228015746, size: 255),
    ];
    var folders = [
      FolderEntry(name: "F1", indexMessageId: 1123123),
      FolderEntry(name: "F2", indexMessageId: 1123123),
      FolderEntry(name: "F3", indexMessageId: 1123123),
      FolderEntry(name: "F5", indexMessageId: 1123123),
      FolderEntry(name: "F9", indexMessageId: 1123123),
    ];
    var index = FolderIndex(version: 1, lastEdit: lastEdit, files: files, folders: folders);

    await drive.index.writeIndex(index);

    var index2 = await drive.index.readIndex();
    print(index2);
  }
}
