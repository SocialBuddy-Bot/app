// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'handled_event.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

EventHandlingData _$EventHandlingDataFromJson(Map json) {
  return EventHandlingData(
    decision: json['decision'] == null
        ? null
        : EventDecision.fromJson(json['decision'] as String),
    remindDate: json['remind_date'] == null
        ? null
        : DateTime.parse(json['remind_date'] as String),
    handlingDay: json['handling_day'] == null
        ? null
        : Day.fromJson(json['handling_day'] as Map),
  );
}

Map<String, dynamic> _$EventHandlingDataToJson(EventHandlingData instance) =>
    <String, dynamic>{
      'decision': instance.decision?.toJson(),
      'handling_day': instance.handlingDay?.toJson(),
      'remind_date': instance.remindDate?.toIso8601String(),
    };
