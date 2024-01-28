class FolderIndex {
  const FolderIndex({
    required this.version,
    required this.lastEditTimestamp,
    required this.next,
    required this.entries,
  });

  /// uint8      Version
  final int version;

  /// uint64     Last edit timestamp
  final int lastEditTimestamp;

  /// uint64     Next
  final int? next;

  /// []Entry    Entries
  final List<Entry> entries;
}

class Entry {
  const Entry({
    required this.flags,
    required this.indexMessageId,
    required this.nameLength,
    required this.name,
  });

  /// uint8     Flags: [isFolder, ...reserved]
  final int flags;

  /// uint64    Chunk/Folder index message id
  final int indexMessageId;

  /// uint8     Name length
  final int nameLength;

  /// utf-8     File/Folder name
  final String name;
}
