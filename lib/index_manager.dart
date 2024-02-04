import 'dart:typed_data';

import 'package:discord_drive_cli/discord_data.dart';
import 'package:discord_drive_cli/index_binary_encoder.dart';
import 'package:discord_drive_cli/index_binary_parser.dart';
import 'package:discord_drive_cli/index_types.dart';
import 'package:nyxx/nyxx.dart';

class DiscordDriveIndexManager {
  final NyxxRest client;
  final Snowflake indexChannelId;
  final Snowflake rootIndexMessageId;

  DiscordDriveIndexManager(this.client, this.indexChannelId, this.rootIndexMessageId);

  final DiscordData discordData = DiscordData();

  PartialTextChannel get _indexChannel => client.channels[indexChannelId] as PartialTextChannel;
  PartialMessage get _rootIndexMessage => _indexChannel.messages[rootIndexMessageId];

  Future<void> writeIndex(FolderIndex index) async {
    final data = IndexBinaryEncoder(index: index).encodeIndex();

    await discordData.writeDataToDiscord(data, _rootIndexMessage);
  }

  Future<FolderIndex> readIndex() async {
    final data = await discordData.readDataFromDiscord(_rootIndexMessage);

    var index = IndexBinaryParser(data: data).parseIndex();

    return index;
  }

  _convertUint64ListToUint8List(List<int> data) => Uint64List.fromList(data).buffer.asUint8List();

  /*Future<void> addFileToIndex(List<int> chunkIds, String name, int size) async {
    final data = _convertUint64ListToUint8List(chunkIds);
    //final compressed = Uint8List.fromList(gzip.encode(data));
    final attachments = [AttachmentBuilder(data: data, fileName: "${name}_index")];
    final chunkIndexMessage = await _indexChannel.sendMessage(MessageBuilder(attachments: attachments));

    final file = FileEntry(name: name, chunkIndexMessageId: chunkIndexMessage.id.value, size: size);
  }

  Future<void> _addFileToIndex() {}*/
}
