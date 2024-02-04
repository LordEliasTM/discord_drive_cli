import 'package:async/async.dart';
import 'package:discord_drive_cli/index_manager.dart';
import 'package:nyxx/nyxx.dart';

const maxChunkSize = 25 * 1024 * 1024; // 25 MB

class DiscordDrive {
  late final NyxxRest client;
  late final Snowflake driveChannelId;
  late final Snowflake indexChannelId;
  late final Snowflake rootIndexMessageId;
  late final DiscordDriveIndexManager index;

  DiscordDrive(String driveChannelId, String indexChannelId, String rootIndexMessageId) {
    this.driveChannelId = Snowflake.parse(driveChannelId);
    this.indexChannelId = Snowflake.parse(indexChannelId);
    this.rootIndexMessageId = Snowflake.parse(rootIndexMessageId);
  }

  PartialTextChannel get _driveChannel => client.channels[driveChannelId] as PartialTextChannel;

  Future<DiscordDrive> connect(String token) async {
    client = await Nyxx.connectRest(token);
    index = DiscordDriveIndexManager(client, indexChannelId, rootIndexMessageId);
    return this;
  }

  Future<void> uploadFile(Stream<List<int>> stream, String fileName) async {
    final reader = ChunkedStreamReader(stream);
    final chunkIds = <int>[];

    // Chunk file and upload the chunks
    try {
      for (var segId = 0; true; segId++) {
        final data = await reader.readBytes(maxChunkSize);
        if (data.isEmpty) break;

        final msg = await uploadDataToDiscord(data, fileName, segId);

        chunkIds.add(msg.id.value);

        // EOF
        if (data.length < maxChunkSize) break;
      }
    } finally {
      reader.cancel();
    }

    //index.addFileToIndex(FileEntry(name: fileName, chunkIndexMessageId: chunkMessageId, size: size))
  }

  Future<Message> uploadDataToDiscord(List<int> data, String fileName, int segId) {
    final attachments = [AttachmentBuilder(data: data, fileName: fileName)];
    final futureMsg = _driveChannel.sendMessage(MessageBuilder(attachments: attachments));

    return futureMsg;
  }

  Future<void> debugDontUse() async {}

  /// returns (int driveChannelId, int indexChannelId, int rootIndexMessageId)
  static Future<(int, int, int)> firstUseInit(int guildId, String token) async {
    var client = await Nyxx.connectRest(token);
    var guild = client.guilds[Snowflake(guildId)];

    var category = await guild.createChannel(GuildCategoryBuilder(name: "Discord Drive"));
    var drive = await guild.createChannel(GuildTextChannelBuilder(name: "drive", parentId: category.id));
    var index = await guild.createChannel(GuildTextChannelBuilder(name: "index", parentId: category.id));

    var rootIndexMessage = await index.sendMessage(MessageBuilder(content: "rootFolder"));

    return (drive.id.value, index.id.value, rootIndexMessage.id.value);
  }
}
