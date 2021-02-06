import 'dart:async';

import 'package:flutter/foundation.dart';

import 'package:meta/meta.dart';
import 'package:rxdart/rxdart.dart';
import 'package:validators/sanitizers.dart' as sanitizers;

// Typedefs
typedef FromJson<T> = T Function(Map<String, dynamic> json);
typedef FutureValueChanged<T> = FutureOr<void> Function(T value);
typedef ValueBuilder<T> = T Function();
typedef Mapper<T, R> = R Function(T value);
typedef IndexValueChanged<T> = void Function(int index, T value);

// Functions
Mapper<T, T> id<T>() => (value) => value;
Mapper<dynamic, T> castDynamic<T>() => (value) => value as T;

// Classes
class Tuple<T1, T2> {
  const Tuple(this.first, this.second);

  final T1 first;
  final T2 second;
}

// Extensions
extension StringUtils on String {
  String get sanitized {
    return sanitizers
        .whitelist(
          this,
          'abcdefghijklmnopqrstuvwxyz'
          'ABCDEFGHIJKLMNOPQRSTUVWXYZ'
          '0123456789'
          ' &+-',
        )
        .trim();
  }

  bool containsAny(List<String> candidates) {
    for (final candidate in candidates) {
      if (contains(candidate)) {
        return true;
      }
    }

    return false;
  }

  List<String> splitAndRemoveEmpty(Pattern pattern) {
    return split(pattern)
        .safeWhere((element) => element?.isNotEmpty ?? false)
        .toList();
  }
}

extension NumUtils on num {
  int roundToNearest(int rounding) {
    return (this / rounding).round() * rounding;
  }

  String _getStringPadding({
    @required int amount,
    String paddingCharacter = '0',
  }) {
    final padAmount = amount - toString().length;
    return paddingCharacter * (padAmount < 0 ? 0 : padAmount);
  }

  String padLeft({
    @required int amount,
    String paddingCharacter = '0',
  }) {
    return _getStringPadding(
            amount: amount, paddingCharacter: paddingCharacter) +
        toString();
  }

  String padRight({
    @required int amount,
    String paddingCharacter = '0',
  }) {
    return toString() +
        _getStringPadding(amount: amount, paddingCharacter: paddingCharacter);
  }
}

extension IterableUtils<T> on Iterable<T> {
  T get firstOrNull => isEmpty ? null : first;

  T get lastOrNull => isEmpty ? null : last;

  Stream<void> asyncForEach(Future<void> Function(T element) f) async* {
    for (final element in this) {
      yield f(element);
    }
  }

  Stream<R> asyncMap<R>(FutureOr<R> Function(T element) convert) async* {
    for (final element in this) {
      yield await convert(element);
    }
  }

  T get random {
    if (isEmpty) {
      throw StateError('Cannot get random element from empty iterable.');
    }
    return (List<T>.from(this)..shuffle()).first;
  }

  T get randomOrNull {
    if (isEmpty) {
      return null;
    }
    return random;
  }

  Iterable<T> safeWhere(bool Function(T element) test) {
    try {
      return where(test);
      // ignore: avoid_catching_errors
    } on StateError {
      return <T>[];
    }
  }

  Iterable<T> intersperse(T element) sync* {
    final iterator = this.iterator;
    if (iterator.moveNext()) {
      yield iterator.current;
      while (iterator.moveNext()) {
        yield element;
        yield iterator.current;
      }
    }
  }
}

extension ListUtils<T> on List<T> {
  T elementOrNullAt(int index) {
    if (asMap().containsKey(index)) {
      return elementAt(index);
    }

    return null;
  }
}

extension ListenableUtils on Listenable {
  Future<void> waitForValue() {
    final completer = Completer<void>();
    addListener(completer.complete);
    return completer.future;
  }
}

extension StreamUtils<T> on Stream<T> {
  Future<T> get firstNonNull => where((value) => value != null).single;

  ValueStream<T> toValueStream() {
    StreamSubscription<T> subscription;
    final behaviorSubject = BehaviorSubject<T>(
      onCancel: () => subscription?.cancel(),
    );
    subscription = listen(behaviorSubject.add);
    return behaviorSubject;
  }
}

extension FutureUtils<T> on Future<T> {
  ValueStream<T> toValueStream() {
    StreamSubscription<T> subscription;
    final behaviorSubject = BehaviorSubject<T>(
      onCancel: () => subscription?.cancel(),
    );
    then(behaviorSubject.add);
    return behaviorSubject;
  }
}
