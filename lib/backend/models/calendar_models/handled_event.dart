import 'dart:convert';

import 'package:json_annotation/json_annotation.dart';
import 'package:meta/meta.dart';

import 'package:socialbuddybot/backend/models/calendar_models.dart';
import 'package:socialbuddybot/backend/models/calendar_models/event_converter.dart';
import 'package:socialbuddybot/backend/models/utility_models.dart';

part 'handled_event.g.dart';

@immutable
class HandledEvent {
  const HandledEvent(
    this.event, {
    @required this.data,
  }) : assert(data != null, 'data cannot be null.');

  @EventConverter()
  final Event event;
  final EventHandlingData data;

  factory HandledEvent.fromJsonWithEvent(
      Event event, Map<String, dynamic> json) {
    return HandledEvent(event, data: EventHandlingData.fromJson(json));
  }

  Event getUpdatedEvent() {
    return event..description = json.encode(data.toJson());
  }
}

@immutable
@JsonSerializable()
class EventHandlingData {
  EventHandlingData({
    @required this.decision,
    this.remindDate,
    Day handlingDay,
  }) : handlingDay = handlingDay ?? Day.today;

  @EventConverter()
  final EventDecision decision;
  final Day handlingDay;
  final DateTime remindDate;

  bool get hasRemindDate => remindDate != null;

  factory EventHandlingData.fromJson(Map<String, dynamic> json) =>
      _$EventHandlingDataFromJson(json);
  Map<String, dynamic> toJson() => _$EventHandlingDataToJson(this);
}

class EventDecision {
  const EventDecision._(this._value);

  static const dismiss = EventDecision._('dismiss');
  static const checkOff = EventDecision._('checkOff');
  static const postpone = EventDecision._('postpone');
  static const execute = EventDecision._('execute');
  static const abort = EventDecision._('abort');

  static List<EventDecision> get values => [
        dismiss,
        checkOff,
        postpone,
        execute,
        abort,
      ];

  final String _value;

  bool get isDismiss => this == dismiss;
  bool get isCheckOff => this == checkOff;
  bool get isPostpone => this == postpone;
  bool get isExecute => this == execute;
  bool get isAbort => this == abort;

  bool get shouldBeRepeated => isPostpone || isExecute || isAbort;

  factory EventDecision.fromJson(String json) =>
      values.firstWhere((e) => e._value == json);

  String toJson() => toString();

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }

    return other is EventDecision && other._value == _value;
  }

  @override
  int get hashCode => _value.hashCode;

  @override
  String toString() {
    return _value;
  }
}
