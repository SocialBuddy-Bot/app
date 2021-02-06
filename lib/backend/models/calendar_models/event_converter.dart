import 'package:json_annotation/json_annotation.dart';

import 'package:socialbuddybot/backend/models/calendar_models.dart';

class EventConverter implements JsonConverter<Event, Map<String, dynamic>> {
  const EventConverter();

  @override
  Event fromJson(Map<String, dynamic> json) => Event.fromJson(json);

  @override
  Map<String, dynamic> toJson(Event value) {
    return {
      'eventId': value.eventId,
      'calendarId': value.calendarId,
      'title': value.title,
      'description': value.description,
      'start': value.start.millisecondsSinceEpoch,
      'end': value.end.millisecondsSinceEpoch,
      'allDay': value.allDay,
      'location': value.location,
      if (value.attendees != null)
        'attendees': value.attendees.map((a) => a.toJson()).toList(),
      if (value.recurrenceRule != null)
        'recurrenceRule': value.recurrenceRule.toJson(),
      if (value.reminders != null)
        'reminders': value.reminders.map((r) => r.toJson()).toList(),
    };
  }
}
