import 'package:flutter/material.dart';

import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:socialbuddybot/backend/models/calendar_models.dart';

part 'event_category_keywords.dart';

class EventCategory {
  const EventCategory._(
    this.value, {
    @required this.color,
    @required this.icon,
  });

  factory EventCategory.fromEvent(Event event) {
    for (final entry in _eventCategoryKeywords.entries) {
      final eventWords =
          event.title.split(' ') + (event.description?.split(' ') ?? []);
      if (eventWords.any((word) => entry.value.contains(word.toLowerCase()))) {
        return entry.key;
      }
    }

    return EventCategory.other;
  }

  static const medication = EventCategory._(
    'Medication',
    color: Colors.green,
    icon: FontAwesomeIcons.pills,
  );
  static const people = EventCategory._(
    'People',
    color: Colors.blue,
    icon: FontAwesomeIcons.userFriends,
  );
  static const other = EventCategory._(
    'Other',
    color: Colors.blueGrey,
    icon: FontAwesomeIcons.calendarAlt,
  );

  static List<EventCategory> get values => [
        medication,
        people,
        other,
      ];

  final String value;
  final Color color;
  final IconData icon;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is EventCategory &&
        runtimeType == other.runtimeType &&
        value == other.value) {
      return true;
    }
    if (other is String) {
      return value == other;
    }
    return false;
  }

  @override
  int get hashCode => value.hashCode;

  @override
  String toString() {
    return value;
  }
}
