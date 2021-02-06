// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'day.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Day _$DayFromJson(Map json) {
  return Day(
    json['year'] as int,
    json['month'] as int,
    json['day'] as int,
  );
}

Map<String, dynamic> _$DayToJson(Day instance) => <String, dynamic>{
      'year': instance.year,
      'month': instance.month,
      'day': instance.day,
    };
