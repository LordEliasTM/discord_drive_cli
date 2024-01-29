import 'package:nyxx/nyxx.dart';

class DiscordDriveIndexManager {
  final NyxxRest client;
  final Snowflake indexChannelId;
  final Snowflake rootIndexMessageId;

  DiscordDriveIndexManager(this.client, this.indexChannelId, this.rootIndexMessageId);
}
