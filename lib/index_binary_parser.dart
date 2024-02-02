import 'package:discord_drive_cli/byte_data_reader.dart';
import 'package:discord_drive_cli/index_types.dart';

class IndexBinaryParser extends ByteDataReader {
  IndexBinaryParser({required super.data});

  FolderIndex parseIndex() {
    final int version = readUint8();
    final int lastEditTimestamp = readUint64();
    final List<FileEntry> files = <FileEntry>[];
    final List<FolderEntry> folders = <FolderEntry>[];

    while (!finished) {
      final List<bool> flags = readBit8Array();
      final bool isDirectory = flags[0];
      final int messageId = readUint64();
      final int fileSize = isDirectory ? 0 : readUint64();
      final int nameLength = readUint8();
      final String name = readString(nameLength);

      if (isDirectory) {
        folders.add(FolderEntry(
          name: name,
          indexMessageId: messageId,
        ));
      } else {
        files.add(FileEntry(
          name: name,
          chunkMessageId: messageId,
          size: fileSize,
        ));
      }
    }

    return FolderIndex(
      version: version,
      lastEdit: lastEditTimestamp,
      files: files,
      folders: folders,
    );
  }
}
