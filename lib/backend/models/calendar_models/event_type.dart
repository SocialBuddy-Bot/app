import 'package:socialbuddybot/backend/models/calendar_models.dart';
import 'package:socialbuddybot/utils/utils.dart';

class EventType {
  const EventType._(this._value);

  factory EventType.fromEvent(Event event) {
    final title = event.title.trim();

    // Reminder check
    if (title.endsWith('!')) {
      return EventType.reminder;
    }

    // Important reminder check
    if (title.endsWith('!?')) {
      return EventType.importantReminder;
    }

    // Action check
    if (title.splitAndRemoveEmpty('?').length >= 2) {
      return EventType.action;
    }

    // Otherwise, it's an announcement
    return EventType.announcement;
  }

  static const announcement = EventType._('announcement');
  static const action = EventType._('action');
  static const reminder = EventType._('reminder');
  static const importantReminder = EventType._('important_reminder');

  static List<EventType> get values => [
        announcement,
        action,
        reminder,
        importantReminder,
      ];

  final String _value;

  bool get isAnnouncement => this == announcement;
  bool get isAction => this == action;
  bool get isReminder => this == reminder;
  bool get isImportantReminder => this == importantReminder;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }

    return other is EventType && other._value == _value;
  }

  @override
  int get hashCode => _value.hashCode;

  @override
  String toString() => _value;
}
