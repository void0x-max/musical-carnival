import 'dart:io';
import 'package:nyxx/nyxx.dart';
import 'package:nyxx_commands/nyxx_commands.dart';
import 'package:logging/logging.dart';
import '../lib/config.dart';
import '../lib/events/ready_event.dart';
import '../lib/events/ticket_events.dart';

final Logger _logger = Logger('Main');

void main() async {
  // Setup logging
  Logger.root.level = Level.ALL;
  Logger.root.onRecord.listen((record) {
    print('${record.level.name}: ${record.time}: ${record.message}');
    if (record.error != null) {
      print('Error: ${record.error}');
      if (record.stackTrace != null) {
        print('Stack trace: ${record.stackTrace}');
      }
    }
  });

  _logger.info('🚀 Starting Discord bot pentru Maniak Shop...');

  try {
    // Încarcă configurația
    Config.load();
    
    // Creează instanța botului
    final bot = NyxxFactory.createNyxxWebsocket(
      Config.token,
      GatewayIntents.allUnprivileged | GatewayIntents.messageContent,
      options: ClientConfiguration(
        plugins: [
          Logging(
            level: LogLevel.info,
            timeInUtc: true,
          ),
          CliIntegration(),
          IgnoreExceptions(),
        ],
      ),
    );

    // Înregistrează event handlers
    bot
      ..registerPlugin(LoggingPlugin(level: LogLevel.info))
      ..registerPlugin(CliIntegrationPlugin())
      ..onReady.listen((event) => readyHandler(bot, event))
      ..onThreadChannelCreate.listen(onThreadCreate)
      ..onGuildChannelCreate.listen(onGuildChannelCreate)
      ..onDisconnect.listen((_) => _logger.warning('🔌 Bot disconnected'))
      ..onReconnect.listen((_) => _logger.info('🔗 Bot reconnected'));

    // Conectează botul
    await bot.connect();

    // Menține botul online
    _logger.info('🤖 Botul este online și rulează...');
    await bot.keepAlive();
    
  } catch (e) {
    _logger.severe('💥 Eroare fatală: $e');
    exit(1);
  }
}