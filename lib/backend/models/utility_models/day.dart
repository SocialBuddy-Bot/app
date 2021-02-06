import 'package:json_annotation/json_annotation.dart';

part 'day.g.dart';

@JsonSerializable()
class Day {
  const Day(this.year, this.month, this.day)
      : assert(month >= 1 && month <= 12,
            'Month must be between 1 and 12 (inclusive).'),
        assert(
            day >= 1 && day <= 31, 'Day must be between 1 and 31 (inclusive).');

  final int year;
  final int month;
  final int day;

  static Day get today => DateTime.now().toDay();

  bool get isToday => this == today;

  DateTime toDateTime() => DateTime(year, month, day);

  static Day fromJson(Map<String, dynamic> json) => _$DayFromJson(json);

  Map<String, dynamic> toJson() => _$DayToJson(this);

  static Day fromString(String source) {
    final parts = source.split('-').map(int.parse).toList();
    return Day(parts[0], parts[1], parts[2]);
  }

  @override
  String toString() {
    final yearStr = '$year';
    final monthStr = '$month'.padLeft(2, '0');
    final dayStr = '$day'.padLeft(2, '0');

    return '$yearStr-$monthStr-$dayStr';
  }

  @override
  int get hashCode => year.hashCode ^ month.hashCode ^ day.hashCode;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is Day &&
            year == other.year &&
            month == other.month &&
            day == other.day;
  }
}

extension DateTimeToDay on DateTime {
  Day toDay() => Day(year, month, day);
}
