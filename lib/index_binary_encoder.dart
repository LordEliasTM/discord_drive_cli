import 'package:discord_drive_cli/byte_data_writer.dart';
import 'package:discord_drive_cli/index_types.dart';

class IndexBinaryEncoder extends ByteDataWriter {
  IndexBinaryEncoder({required this.index}) {
    super.data = <int>[];
  }

  final FolderIndex index;

  List<int> encode() {
    writeUint8(index.version);
    writeUint64(index.lastEdit);
    writeUint64(index.next);

    for (var entry in index.entries) {
      if (entry is FileEntry) {
        // isDirectory, reserved...
        writeBit8Array([false, false, false, false, false, false, false, false]);
        writeUint64(entry.chunkMessageId);
      }
      if (entry is FolderEntry) {
        // isDirectory, reserved...
        writeBit8Array([true, false, false, false, false, false, false, false]);
        writeUint64(entry.indexMessageId);
      }
      writeUint8(entry.nameLength);
      writeString(entry.name);
    }

    return data;
  }
}
