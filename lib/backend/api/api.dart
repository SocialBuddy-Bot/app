import 'package:flutter/services.dart';

import 'package:device_calendar/device_calendar.dart';
import 'package:meta/meta.dart';

import 'package:socialbuddybot/backend/models/calendar_models.dart';

class Api {
  const Api();

  static final _calendarPlugin = DeviceCalendarPlugin();

  Future<bool> ensureCalendarPermission() async {
    final hasPermission = (await _calendarPlugin.hasPermissions()).data;
    return hasPermission || (await _calendarPlugin.requestPermissions()).data;
  }

  Future<List<Calendar>> getCalendars() async {
    print('${DateTime.now()} - getCalendars');
    final result = await _calendarPlugin.retrieveCalendars();
    print(
      '... calendar data: [${result.data?.map((c) => c.format())}], '
      'errorMessages: [${result.errorMessages?.join(', ')}]',
    );

    if (!result.isSuccess) {
      throw PlatformException(
        code: 'DeviceCalendarPluginException',
        message: 'ErrorMessages: [${result.errorMessages?.join(', ')}]',
      );
    }

    return result.data;
  }

  Future<List<Event>> getEventsForCalendar(
    Calendar calendar, {
    @required DateTime start,
    @required DateTime end,
  }) async {
    final result = await _calendarPlugin.retrieveEvents(
      calendar.id,
      RetrieveEventsParams(startDate: start, endDate: end),
    );

    return result.data;
  }

  Future<Result<String>> createOrUpdateEvent(Event event) {
    return _calendarPlugin.createOrUpdateEvent(event);
  }
}
