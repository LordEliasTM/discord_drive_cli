import 'dart:typed_data';

import 'package:async/async.dart';
import 'package:discord_drive_cli/index_manager.dart';
import 'package:nyxx/nyxx.dart';

class DiscordDrive {
  DiscordDrive({
    required String driveChannelId,
    required String indexChannelId,
    required String rootIndexMessageId,
  })  : driveChannelId = Snowflake.parse(driveChannelId),
        indexChannelId = Snowflake.parse(indexChannelId),
        rootIndexMessageId = Snowflake.parse(rootIndexMessageId);

  // 25 MB
  static const int maxChunkSize = 25 * 1024 * 1024;

  late final NyxxRest client;
  late final DiscordDriveIndexManager index;
  final Snowflake driveChannelId;
  final Snowflake indexChannelId;
  final Snowflake rootIndexMessageId;

  PartialTextChannel get _driveChannel => client.channels[driveChannelId] as PartialTextChannel;

  Future<void> connect(String token) async {
    client = await Nyxx.connectRest(token);
    index = DiscordDriveIndexManager(
      client: client,
      indexChannelId: indexChannelId,
      rootIndexMessageId: rootIndexMessageId,
    );
  }

  Future<void> uploadFile(Stream<List<int>> stream, String fileName) async {
    final ChunkedStreamReader<int> reader = ChunkedStreamReader<int>(stream);
    final List<int> chunkIds = <int>[];

    // Chunk file and upload the chunks
    try {
      for (int segId = 0; true; segId++) {
        final Uint8List data = await reader.readBytes(maxChunkSize);
        if (data.isEmpty) break;

        final Message msg = await uploadDataToDiscord(
          data,
          fileName,
          segId,
        );

        chunkIds.add(msg.id.value);

        // EOF
        if (data.length < maxChunkSize) break;
      }
    } finally {
      await reader.cancel();
    }

    //index.addFileToIndex(FileEntry(name: fileName, chunkIndexMessageId: chunkMessageId, size: size))
  }

  Future<Message> uploadDataToDiscord(List<int> data, String fileName, int segId) {
    final List<AttachmentBuilder> attachments = <AttachmentBuilder>[AttachmentBuilder(data: data, fileName: fileName)];
    final Future<Message> futureMsg = _driveChannel.sendMessage(MessageBuilder(attachments: attachments));

    return futureMsg;
  }

  Future<void> debugDontUse() async {}

  /// returns (int driveChannelId, int indexChannelId, int rootIndexMessageId)
  static Future<(int, int, int)> firstUseInit(int guildId, String token) async {
    final NyxxRest client = await Nyxx.connectRest(token);
    final PartialGuild guild = client.guilds[Snowflake(guildId)];

    final GuildCategory category = await guild.createChannel(GuildCategoryBuilder(
      name: 'Discord Drive',
    ));
    final GuildTextChannel drive = await guild.createChannel(GuildTextChannelBuilder(
      name: 'drive',
      parentId: category.id,
    ));
    final GuildTextChannel index = await guild.createChannel(GuildTextChannelBuilder(
      name: 'index',
      parentId: category.id,
    ));

    final Message rootIndexMessage = await index.sendMessage(MessageBuilder(
      content: 'rootFolder',
    ));

    return (
      drive.id.value,
      index.id.value,
      rootIndexMessage.id.value,
    );
  }
}
