import 'package:dotenv/dotenv.dart' as dotenv;

class Config {
  static late final String token;
  static late final int ticketToolBotId;
  static late final String botPrefix;

  static void load() {
    dotenv.load();
    
    token = dotenv.env['DISCORD_BOT_TOKEN'] ?? '';
    if (token.isEmpty) {
      throw Exception('DISCORD_BOT_TOKEN nu este setat în .env');
    }

    final ticketToolId = dotenv.env['TICKET_TOOL_BOT_ID'] ?? '557628352828014614';
    ticketToolBotId = int.tryParse(ticketToolId) ?? 557628352828014614;
    
    botPrefix = dotenv.env['BOT_PREFIX'] ?? '/';
  }
}