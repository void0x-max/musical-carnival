import 'package:nyxx/nyxx.dart';
import 'package:nyxx_commands/nyxx_commands.dart';

final setupCommand = ChatCommand(
  'setup',
  'Setează sistemul de tickete pentru Maniak Shop',
  id('setup', (ChatContext context) async {
    final embed = EmbedBuilder()
      ..title = '🛠️ **Sistem de Tickete - Maniak Shop**'
      ..description = '**Sistemul de tickete este activ!** 🎫'
      ..color = DiscordColor.fromRgb(255, 0, 0)
      ..addField(
        name: '📝 **Cum funcționează?**',
        value: '• Creezi un ticket folosind Ticket Tool\n• Primești automat instrucțiunile necesare\n• Echipa noastră te contactează rapid',
        inline: false,
      );

    await context.respond(MessageBuilder(embeds: [embed]));
  }),
)..permissions = [
    PermissionsConstants.administrator,
  ];