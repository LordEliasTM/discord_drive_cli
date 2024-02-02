class FolderIndex {
  const FolderIndex({
    required this.version,
    required this.lastEdit,
    required this.files,
    required this.folders,
  });

  final int version;
  final int lastEdit;
  final List<FileEntry> files;
  final List<FolderEntry> folders;

  @override
  String toString() {
    String result = "";
    for (var folder in folders) {
      result += "📁 ${folder.name}\n";
    }
    for (var file in files) {
      result += "📄 ${file.name}\n";
    }
    return result;
  }
}

class FileEntry {
  const FileEntry({
    required this.name,
    required this.chunkMessageId,
    required this.size,
  });

  final String name;
  final int chunkMessageId;
  final int size;
}

class FolderEntry {
  const FolderEntry({
    required this.name,
    required this.indexMessageId,
  });

  final String name;
  final int indexMessageId;
}
