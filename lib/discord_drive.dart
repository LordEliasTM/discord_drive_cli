import 'package:discord_drive_cli/index_manager.dart';
import 'package:nyxx/nyxx.dart';

class DiscordDrive {
  late final NyxxRest client;
  late final Snowflake driveChannelId;
  late final Snowflake indexChannelId;
  late final Snowflake rootIndexMessageId;
  late final DiscordDriveIndexManager index;

  DiscordDrive(int driveChannelId, int indexChannelId, int rootIndexMessageId) {
    this.driveChannelId = Snowflake(driveChannelId);
    this.indexChannelId = Snowflake(indexChannelId);
    this.rootIndexMessageId = Snowflake(rootIndexMessageId);
  }

  void connect(String token) async {
    client = await Nyxx.connectRest(token);
    index = DiscordDriveIndexManager(client, indexChannelId, rootIndexMessageId);
  }

  Future<void> debugDontUse() async {}

  /// (int driveChannelId, int indexChannelId, int rootIndexMessageId)
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
