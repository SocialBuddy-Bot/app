import 'dart:async';

import 'package:meta/meta.dart';
import 'package:rxdart/rxdart.dart';
import 'package:state_persistence/state_persistence.dart';

import 'package:socialbuddybot/backend/models/calendar_models.dart';
import 'package:socialbuddybot/utils/utils.dart';

class AppStateStore {
  AppStateStore._(
    this._data, {
    @required this.selectedCalendar,
  });

  static const _kStorage = JsonFileStorage(filename: 'app_state_store.json');
  static const _kSaveTimeout = Duration(milliseconds: 500);

  static Future<AppStateStore> init() async {
    final data = await PersistedData.load(_kStorage, _kSaveTimeout);

    final bsf = _StoreBehaviorSubjectFactory(data);

    return AppStateStore._(
      data,
      selectedCalendar: bsf.generateForKey<Calendar>(
        'selectedCalendar',
        fromJson: (json) => Calendar.fromJson(json),
      ),
    );
  }

  final PersistedData _data;

  final BehaviorSubject<Calendar> selectedCalendar;

  bool get isEmpty => _data.isEmpty;

  bool get isNotEmpty => !isEmpty;

  void clear() {
    selectedCalendar.value = null;
    _data.clear();
  }
}

class _StoreBehaviorSubjectFactory {
  const _StoreBehaviorSubjectFactory(this._data);

  final PersistedData _data;

  BehaviorSubject<T> generateForKey<T>(
    String key, {
    T defaultValue,
    Mapper<dynamic, T> fromJson,
    Mapper<T, dynamic> toJson,
  }) {
    final valueFromStorage = _data[key];
    T initialValue;

    if (valueFromStorage == null) {
      initialValue = defaultValue;
    } else {
      initialValue = fromJson?.call(valueFromStorage) ?? valueFromStorage as T;
    }

    return BehaviorSubject<T>.seeded(initialValue)
      ..stream.listen((newValue) {
        _data[key] = toJson?.call(newValue) ?? newValue;
      });
  }

  BehaviorSubject<List<T>> generateListForKey<T>(
    String key, {
    List<T> defaultValue,
    Mapper<dynamic, T> fromJson,
    Mapper<T, dynamic> toJson,
  }) {
    return generateForKey<List<T>>(
      key,
      defaultValue: defaultValue,
      fromJson: (jsonList) {
        return List.from((jsonList as List).map(fromJson ?? castDynamic()));
      },
      toJson: (value) {
        return value.map(toJson ?? id<T>()).toList();
      },
    );
  }
}
