class FolderIndex {
  const FolderIndex({
    required this.version,
    required this.lastEdit,
    required this.next,
    required this.entries,
  });

  /// uint8      Version
  final int version;

  /// uint64     Last edit timestamp
  final int lastEdit;

  /// uint64     Next
  final int next;

  /// []Entry    Entries
  final List<Entry> entries;
}

class Entry {
  const Entry({
    required this.nameLength,
    required this.name,
  });

  /// uint8     Name length
  final int nameLength;

  /// utf-8     File/Folder name
  final String name;
}

class FileEntry extends Entry {
  const FileEntry({
    required super.nameLength,
    required super.name,
    required this.chunkMessageId,
  });

  /// uint64    Chunk index message id
  final int chunkMessageId;
}

class FolderEntry extends Entry {
  const FolderEntry({
    required super.nameLength,
    required super.name,
    required this.indexMessageId,
  });

  /// uint64    Folder index message id
  final int indexMessageId;
}
