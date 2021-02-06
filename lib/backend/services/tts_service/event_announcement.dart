import 'package:device_calendar/device_calendar.dart';

import 'package:socialbuddybot/utils/utils.dart';

List<String> getEventAnnouncements(Event event) {
  final eventTitle = event.title.sanitized;

  final eventIsInFuture = event.start.compareTo(DateTime.now()) == 1;

  // final timePrompt = _getTimePrompt(event.start);
  final hour = event.start.hour.padLeft(amount: 2);
  final minute = event.start.minute.padLeft(amount: 2);

  final timePrompt = '$hour:$minute';

  final minutesRemaining =
      (DateTime.now().difference(event.start).inMinutes).abs();

  final elapsedTimePrompt = minutesRemaining > 60
      ? '${(minutesRemaining / 60).round()} uur'
      : '$minutesRemaining ${minutesRemaining == 1 ? 'minuut' : 'minuten'}';

  if (eventIsInFuture) {
    return [
      'Om $timePrompt heb je de afspraak $eventTitle.',
      'Over $elapsedTimePrompt start je afspraak $eventTitle.',
      'Zometeen begint je afspraak $eventTitle.',
    ];
  } else {
    return [
      'Je afspraak $eventTitle is $elapsedTimePrompt geleden begonnen.',
      'Om $timePrompt begon je afspraak $eventTitle.',
      '$elapsedTimePrompt geleden is je afspraak $eventTitle begonnen.'
    ];
  }
}
