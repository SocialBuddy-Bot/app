import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

import 'package:socialbuddybot/utils/utils.dart';

// Typedefs
typedef ContextBuilder<T> = T Function(BuildContext context);
typedef ContextValueBuilder<T> = Widget Function(BuildContext context, T value);

// Extensions
extension DurationUtils on Duration {
  String formatAsMinutesAndSeconds() {
    final minutes = '${(inSeconds / 60).floor()}'.padLeft(2, '0');
    final seconds = '${inSeconds % 60}'.padLeft(2, '0');

    return '$minutes:$seconds';
  }
}

extension DateTimeUtils on DateTime {
  String get monthName {
    switch (month) {
      case 1:
        return 'January';
      case 2:
        return 'February';
      case 3:
        return 'March';
      case 4:
        return 'April';
      case 5:
        return 'May';
      case 6:
        return 'June';
      case 7:
        return 'July';
      case 8:
        return 'August';
      case 9:
        return 'September';
      case 10:
        return 'October';
      case 11:
        return 'November';
      case 12:
        return 'December';
      default:
        throw UnsupportedError('Invalid value.');
    }
  }

  String formatFullWritten() {
    return '${formatDateWritten()} ${formatTimeSimple()}';
  }

  String formatDateSimple() {
    String pad(int value) => value.padLeft(amount: 2);
    return '${pad(day)}-${pad(month)}-$year';
  }

  String formatDateWritten() {
    return '$day ${monthName.toLowerCase()} $year';
  }

  String formatTimeSimple() {
    String pad(int value) => value.padLeft(amount: 2);
    return '${pad(hour)}:${pad(minute)}';
  }
}

extension ColorListUtils on List<Color> {
  Color lerp(double t) {
    assert(length >= 2, 'Must have at least 2 colors to lerp.');
    if (length == 2) {
      return Color.lerp(this[0], this[1], t);
    }

    final stops = [for (int i = 0; i < length; i++) i * (1 / (length - 1))];
    for (var s = 0; s < stops.length - 1; s++) {
      final leftStop = stops[s], rightStop = stops[s + 1];
      final leftColor = this[s], rightColor = this[s + 1];
      if (t <= leftStop) {
        return leftColor;
      } else if (t < rightStop) {
        final sectionT = (t - leftStop) / (rightStop - leftStop);
        return Color.lerp(leftColor, rightColor, sectionT);
      }
    }
    return last;
  }
}

String formatPercentage(double percentage) {
  final multiplied = (percentage * 100).round();
  return '${multiplied.roundToNearest(5)}';
}

Widget fadeScaleTransitionBuilder(Widget child, Animation<double> animation) {
  return FadeTransition(
    opacity: animation,
    child: ScaleTransition(
      scale: animation.drive(Tween(begin: 0.8, end: 1.0)),
      child: child,
    ),
  );
}

Future<void> waitForValue(Listenable listenable) {
  final completer = Completer<void>();
  listenable.addListener(completer.complete);
  return completer.future;
}
