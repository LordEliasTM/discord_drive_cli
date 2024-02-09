import 'package:discord_drive_cli/discord_drive.dart';
import 'package:discord_drive_cli/index_types.dart';
import 'package:sha_env/sha_env.dart';

Future<void> testCommand() async {
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

  final int lastEdit = DateTime.now().millisecondsSinceEpoch;
  final List<FileEntry> files = <FileEntry>[
    FileEntry(name: 'Joe', chunkIndexMessageId: 1201581445228015746, size: 255),
    FileEntry(name: 'Mama', chunkIndexMessageId: 1201581445228015746, size: 255),
    FileEntry(name: 'Got', chunkIndexMessageId: 1201581445228015746, size: 255),
    FileEntry(name: 'cha', chunkIndexMessageId: 1201581445228015746, size: 255),
    FileEntry(name: ':)', chunkIndexMessageId: 1201581445228015746, size: 255),
    FileEntry(name: ':)2', chunkIndexMessageId: 1201581445228015746, size: 255),
    FileEntry(name: 'IJBHDVUIJNWUIJUNVIJNSJHSBVIHSBBDVUISDBJN', chunkIndexMessageId: 1201581445228015746, size: 255),
  ];
  final List<FolderEntry> folders = <FolderEntry>[
    FolderEntry(name: 'Noug', indexMessageId: 1123123),
    FolderEntry(name: 'at', indexMessageId: 1123123),
    FolderEntry(name: 'Bal', indexMessageId: 1123123),
    FolderEntry(name: 'lz', indexMessageId: 1123123),
  ];
  final FolderIndex index = FolderIndex(version: 1, lastEdit: lastEdit, files: files, folders: folders);

  await drive.index.writeIndex(index);

  print('done');
}
