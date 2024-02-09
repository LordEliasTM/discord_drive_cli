import 'dart:typed_data';

import 'package:discord_drive_cli/byte_data_writer.dart';
import 'package:discord_drive_cli/index_types.dart';

class IndexBinaryEncoder extends ByteDataWriter {
  IndexBinaryEncoder({
    required this.index,
  });

  final FolderIndex index;

  Uint8List encodeIndex() {
    writeUint8(index.version);
    writeUint64(index.lastEdit);

    for (final FileEntry file in index.files) {
      // isDirectory, reserved...
      writeBit8Array(<bool>[false, false, false, false, false, false, false, false]);
      writeUint64(file.chunkIndexMessageId);
      writeUint64(file.size);
      writeString(file.name, prependDataLength: true);
    }

    for (final FolderEntry folder in index.folders) {
      // isDirectory, reserved...
      writeBit8Array(<bool>[true, false, false, false, false, false, false, false]);
      writeUint64(folder.indexMessageId);
      writeString(folder.name, prependDataLength: true);
    }

    return Uint8List.fromList(data);
  }
}
