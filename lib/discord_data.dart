import 'dart:io';
import 'dart:typed_data';

import 'package:discord_drive_cli/base_discord.dart';
import 'package:nyxx/nyxx.dart';

class DiscordData {
  final PartialTextChannel _channel;

  DiscordData(this._channel);

  Future<void> writeDataToDiscord(Uint8List data, PartialMessage message, {bool compress = true}) async {
    if (compress) data = Uint8List.fromList(gzip.encode(data));
    final overMessageSizeLimit = data.length > 4000;

    // if not over limit just put it in the message
    // if over limit upload as file and reference it fromt he message
    if (!overMessageSizeLimit) {
      await message.edit(MessageUpdateBuilder(content: encodeBase256(data)));
    } else {
      final attachements = [AttachmentBuilder(data: data, fileName: "discordData_${message.id}")];
      final fileMessage = await _channel.sendMessage(MessageBuilder(attachments: attachements));
      await message.edit(MessageUpdateBuilder(content: "#${fileMessage.id}"));
    }
  }

  bool isCompressed(Uint8List data) => data[0] == 0x1f && data[1] == 0x8b;

  Future<Uint8List> readDataFromDiscord(PartialMessage message) async {
    final msg = (await message.fetch()).content;
    final overMessageSizeLimit = msg[0] == "#";

    Uint8List data;

    if (!overMessageSizeLimit) {
      data = decodeBase256(msg);
    } else {
      // format is #1201581445228015749, so need to remove hashtag
      final fileMessageId = Snowflake.parse(msg.substring(1));
      final fileMessage = await _channel.messages.get(fileMessageId);
      data = await fileMessage.attachments[0].fetch();
    }

    if (isCompressed(data)) {
      data = Uint8List.fromList(gzip.decode(data));
    }

    return data;
  }
}
