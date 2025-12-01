import 'package:nyxx/nyxx.dart';
import 'package:nyxx_commands/nyxx_commands.dart';
import '../config.dart';
import '../commands/setup_command.dart';

Future<void> readyHandler(INyxxWebsocket client, IReadyEvent event) async {
  print('✅ Botul ${client.self.tag} este online!');

  // Sincronizează comenzile slash
  try {
    final commands = CommandsPlugin(
      prefix: (message) => Config.botPrefix,
      options: CommandsOptions(logErrors: true),
    );

    commands.addCommand(setupCommand);
    
    client.registerPlugin(commands);
    print('✅ Comenzi slash sincronizate');
  } catch (e) {
    print('❌ Eroare la sincronizarea comenzilor: $e');
  }

  // Setează statusul botului
  await client.setPresence(
    PresenceBuilder.of(
      status: UserStatus.online,
      activity: ActivityBuilder.game('Maniak Shop'),
    ),
  );
}