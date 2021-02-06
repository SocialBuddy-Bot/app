import 'package:device_calendar/device_calendar.dart' show Calendar, Event;
import 'package:socialbuddybot/backend/models/utility_models.dart';
import 'package:socialbuddybot/backend/models/calendar_models/event_type.dart';

export 'package:device_calendar/device_calendar.dart' show Calendar, Event;
export 'calendar_models/event_category.dart';
export 'calendar_models/event_type.dart';
export 'calendar_models/handled_event.dart';

extension CalendarUtils on Calendar {
  String format() {
    return '$name ($id)';
  }
}

extension EventUtils on Event {
  List<String> get _actionParts {
    assert(type.isAction, 'Cannot get action parts for event with type $type.');

    final parts = title
        .trim()
        .split('?')
        .map((part) => part.trim())
        .toList(growable: false);
    parts[0] = '${parts[0]}?';

    return parts;
  }

  EventType get type => EventType.fromEvent(this);

  String get actionPrompt => _actionParts[0];
  String get actionCommand => _actionParts[1];

  String format() {
    return '$title ($eventId, $type, start: ${start.toDay()})';
  }
}

extension EventListUtils on Iterable<Event> {
  bool idsEquals(Iterable<Event> other) {
    if (identical(this, other)) {
      return true;
    }

    if (other == null) {
      return false;
    }

    if (isEmpty && other.isEmpty) {
      return true;
    }

    if (isEmpty || other.isEmpty) {
      return false;
    }

    return first.eventId == other.first.eventId &&
        skip(1).toList().idsEquals(other.skip(1));
  }
}
