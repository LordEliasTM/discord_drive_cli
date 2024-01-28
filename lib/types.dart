class FolderIndex {
  int version;            // uint8      Version
  int lastEditTimestamp;  // uint64     Last edit timestamp
  int? next;              // uint64     Next
  List<Entry> entries;    // []Entry    Entries

  FolderIndex(this.version, this.lastEditTimestamp, this.next, this.entries);
}

abstract class Entry {
  int flags;           // uint8     Flags: [isFolder, ...reserved]
  int indexMessageId;  // uint64    Chunk/Folder index message id
  int nameLength;      // uint8     Name length
  String name;         // utf-8     File/Folder name

  Entry(this.flags, this.indexMessageId, this.nameLength, this.name);
}
