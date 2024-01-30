import 'package:discord_drive_cli/byte_data_reader.dart';
import 'package:discord_drive_cli/index_types.dart';

class IndexBinaryParser extends ByteDataReader {
  IndexBinaryParser({required super.data});

  FolderIndex parseIndex() {
    final int version = readUint8();
    final int lastEditTimestamp = readUint64();
    final int next = readUint64();
    final List<Entry> entries = <Entry>[];

    while (!finished) {
      final List<bool> flags = readBit8Array();
      final bool isDirectory = flags[0];
      final int messageId = readUint64();
      final int nameLength = readUint8();
      final String name = readString(nameLength);

      if (isDirectory) {
        entries.add(FolderEntry(
          indexMessageId: messageId,
          nameLength: nameLength,
          name: name,
        ));
      } else {
        entries.add(FileEntry(
          chunkMessageId: messageId,
          nameLength: nameLength,
          name: name,
        ));
      }
    }

    return FolderIndex(
      version: version,
      lastEdit: lastEditTimestamp,
      next: next,
      entries: entries,
    );
  }
}
