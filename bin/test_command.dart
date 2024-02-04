import 'package:discord_drive_cli/discord_drive.dart';
import 'package:discord_drive_cli/index_types.dart';
import 'package:sha_env/sha_env.dart';

Future<void> testCommand() async {
  String driveChannelId = env["DRIVE_CHANNEL_ID"];
  String indexChannelId = env["INDEX_CHANNEL_ID"];
  String rootIndexMessageId = env["ROOT_INDEX_MESSAGE_ID"];
  String botToken = env["BOT_TOKEN"];

  var drive = await DiscordDrive(driveChannelId, indexChannelId, rootIndexMessageId).connect(botToken);

  var lastEdit = DateTime.now().millisecondsSinceEpoch;
  var files = [
    FileEntry(name: "Joe", chunkIndexMessageId: 1201581445228015746, size: 255),
    FileEntry(name: "Mama", chunkIndexMessageId: 1201581445228015746, size: 255),
    FileEntry(name: "Got", chunkIndexMessageId: 1201581445228015746, size: 255),
    FileEntry(name: "cha", chunkIndexMessageId: 1201581445228015746, size: 255),
    FileEntry(name: ":)", chunkIndexMessageId: 1201581445228015746, size: 255),
    FileEntry(name: ":)2", chunkIndexMessageId: 1201581445228015746, size: 255),
  ];
  var folders = [
    FolderEntry(name: "Noug", indexMessageId: 1123123),
    FolderEntry(name: "at", indexMessageId: 1123123),
    FolderEntry(name: "Bal", indexMessageId: 1123123),
    FolderEntry(name: "lz", indexMessageId: 1123123),
  ];
  var index = FolderIndex(version: 1, lastEdit: lastEdit, files: files, folders: folders);

  await drive.index.writeIndex(index);

  print("done");
}
