import 'package:nyxx/nyxx.dart';
import 'package:nyxx_commands/nyxx_commands.dart';
import '../config.dart';

Future<void> sendTicketEmbed(ISend channel) async {
  final embed = EmbedBuilder()
    ..color = DiscordColor.fromRgb(255, 0, 0)
    ..addField(
      name: '**Stimat(ă) client(ă),**',
      value: 'Echipa Maniak Shop va fi la dispoziția dumneavoastră în cel mai scurt timp. Până atunci, vă rugăm să vă asigurați că aveți pregătite:',
      inline: false,
    )
    ..addField(
      name: '',
      value: '• lista completă a produselor dorite,\n• metoda de plată preferată,\n• precum și adresa de livrare corectă.',
      inline: false,
    )
    ..addField(
      name: '',
      value: 'Vă mulțumim pentru încrederea acordată și pentru alegerea Maniak Shop.',
      inline: false,
    )
    ..imageUrl = 'https://cdn.discordapp.com/attachments/1434573416761135114/1434577612965150820/standard_1.gif';

  await channel.sendMessage(MessageBuilder(embeds: [embed]));
}

Future<void> onThreadCreate(IThreadChannelCreateEvent event) async {
  final thread = event.channel as IThreadChannel;
  
  await Future.delayed(Duration(seconds: 3));

  try {
    final auditLogs = await event.guild.getAuditLogs(
      actionType: AuditLogEvent.threadCreate,
      limit: 10,
    );

    for (final entry in auditLogs.entries) {
      if (entry.userId == Snowflake(Config.ticketToolBotId) &&
          entry.targetId == thread.id) {
        
        // Verifică dacă botul a răspuns deja
        final messages = await thread.history(limit: 10).toList();
        if (messages.any((msg) => msg.author.id == event.client.self.id)) {
          return;
        }

        print('🎫 Detectat ticket creat de Ticket Tool: ${thread.name}');
        await sendTicketEmbed(thread);
        break;
      }
    }
  } catch (e) {
    print('❌ Eroare la procesarea thread-ului: $e');
  }
}

Future<void> onGuildChannelCreate(IGuildChannelCreateEvent event) async {
  final channel = event.channel;
  
  await Future.delayed(Duration(seconds: 2));

  try {
    final auditLogs = await event.guild.getAuditLogs(
      actionType: AuditLogEvent.channelCreate,
      limit: 10,
    );

    for (final entry in auditLogs.entries) {
      if (entry.userId == Snowflake(Config.ticketToolBotId) &&
          entry.targetId == channel.id) {
        
        // Verifică dacă este un canal de ticket
        final name = channel.name.toLowerCase();
        if (name.contains('ticket') || name.contains('support')) {
          
          // Verifică dacă botul a răspuns deja
          if (channel is ITextChannel) {
            final messages = await channel.history(limit: 10).toList();
            if (messages.any((msg) => msg.author.id == event.client.self.id)) {
              return;
            }

            print('🎫 Detectat canal ticket creat de Ticket Tool: ${channel.name}');
            await sendTicketEmbed(channel);
          }
        }
        break;
      }
    }
  } catch (e) {
    print('❌ Eroare la procesarea canalului: $e');
  }
}