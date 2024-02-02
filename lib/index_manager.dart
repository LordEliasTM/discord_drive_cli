import 'package:discord_drive_cli/base_discord.dart';
import 'package:discord_drive_cli/index_binary_encoder.dart';
import 'package:discord_drive_cli/index_binary_parser.dart';
import 'package:discord_drive_cli/index_types.dart';
import 'package:nyxx/nyxx.dart';

class DiscordDriveIndexManager {
  final NyxxRest client;
  final Snowflake indexChannelId;
  final Snowflake rootIndexMessageId;

  DiscordDriveIndexManager(this.client, this.indexChannelId, this.rootIndexMessageId);

  PartialTextChannel get _indexChannel => client.channels[indexChannelId] as PartialTextChannel;
  PartialMessage get _rootIndexMessage => _indexChannel.messages[rootIndexMessageId];

  Future<void> writeIndex(FolderIndex index) async {
    print("writing to index");

    var data = IndexBinaryEncoder(index: index).encodeIndex();
    print(data);
    var overMessageSizeLimit = data.length > 4000;

    if (!overMessageSizeLimit) {
      _rootIndexMessage.edit(MessageUpdateBuilder(content: encodeBase256(data)));
    } else {
      var indexFileMessage = await _indexChannel
          .sendMessage(MessageBuilder(attachments: [AttachmentBuilder(data: data, fileName: "rootIndex")]));
      _rootIndexMessage.edit(MessageUpdateBuilder(content: "#${indexFileMessage.id}"));
    }
  }

  Future<FolderIndex> readIndex() async {
    print("reading index");

    var msg = (await _rootIndexMessage.fetch()).content;
    var overMessageSizeLimit = msg[0] == "#";

    if (!overMessageSizeLimit) {
      var data = decodeBase256(msg);
      var index = IndexBinaryParser(data: data).parseIndex();
      return index;
    } else {
      // format is #1201581445228015749, so need to remove hashtag
      var indexFileMessageId = Snowflake.parse(msg.substring(1));
      var indexFileMessage = await _indexChannel.messages.get(indexFileMessageId);
      var data = await indexFileMessage.attachments[0].fetch();
      var index = IndexBinaryParser(data: data).parseIndex();
      return index;
    }
  }
}
