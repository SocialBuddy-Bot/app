import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';

import 'package:meta/meta.dart';
import 'package:rxdart/rxdart.dart';

import 'package:socialbuddybot/backend/api/api.dart';
import 'package:socialbuddybot/backend/app_state_store.dart';
import 'package:socialbuddybot/backend/models/calendar_models.dart';
import 'package:socialbuddybot/backend/models/utility_models.dart';
import 'package:socialbuddybot/backend/repositories/repositories.dart';
import 'package:socialbuddybot/utils/context_logger.dart';
import 'package:socialbuddybot/utils/utils.dart';

class CalendarRepository extends Repository {
  CalendarRepository._(this._api, this._appState) : super(_api, _appState) {
    _latestQueuedEvent =
        _eventQueue.stream.map((events) => events.firstOrNull).toValueStream();

    _resetEventCheckTimer();

    eventQueue.listen(notify);
    currentHandledEvent.listen(notify);
    selectedCalendar.listen(notify);
  }

  static Future<CalendarRepository> init(
      Api api, AppStateStore appState) async {
    await api.ensureCalendarPermission();

    return CalendarRepository._(api, appState);
  }

  static Duration getHandledEventConfirmationDurationForDecision(
      EventDecision decision) {
    if (decision.isExecute) {
      return const Duration(seconds: 10);
    }

    return const Duration(seconds: 5);
  }

  final Api _api;
  final AppStateStore _appState;

  static const _log = ContextLogger('CLDNR');
  final _eventQueue = BehaviorSubject<List<Event>>();
  final _currentHandledEvent = BehaviorSubject<HandledEvent>();

  static const _eventCheckInterval = Duration(seconds: 5);
  static const _eventPastTimespanLimit = Duration(hours: 12);
  static const _eventFutureTimespanLimit = Duration(minutes: 15);
  static const _handledEventPostponingDuration = Duration(minutes: 30);

  Timer _eventCheckTimer;
  ValueStream<Event> _latestQueuedEvent;

  ValueStream<List<Event>> get eventQueue => _eventQueue;
  ValueStream<Event> get latestQueuedEvent => _latestQueuedEvent;
  ValueStream<HandledEvent> get currentHandledEvent => _currentHandledEvent;

  ValueStream<Calendar> get selectedCalendar => _appState.selectedCalendar;

  bool get hasCalendarSelected => selectedCalendar.value != null;

  void _resetEventCheckTimer() {
    _eventCheckTimer?.cancel();
    _eventCheckTimer =
        Timer.periodic(_eventCheckInterval, (_) => _checkForNewEvents());
    _checkForNewEvents();
  }

  void _pushNewEvents(List<Event> events) {
    final _logMessage =
        _log.function('_pushNewEvents', events.map((e) => e.format()).toList());

    if (events.idsEquals(_eventQueue.value)) {
      _logMessage('No new events. Preventing push.');
      return;
    }

    _eventQueue.add(events);
  }

  Future<void> _checkForNewEvents() async {
    final _logMessage = _log.function('_checkForNewEvents',
        {'selectedCalendar': selectedCalendar.value?.format()});

    if (selectedCalendar.value == null) {
      _logMessage('No calendar selected. Emptying queue...');
      _pushNewEvents([]);
      return;
    }

    final events = await _api.getEventsForCalendar(
      selectedCalendar.value,
      start: DateTime.now().subtract(_eventPastTimespanLimit),
      end: DateTime.now().add(_eventFutureTimespanLimit),
    );
    _logMessage(
      // ignore: prefer_interpolation_to_compose_strings, prefer_adjacent_string_concatenation
      'original events: ' +
          '[' +
          (events.isEmpty
              ? 'NONE'
              : events.map((event) => event.format()).join(', ')) +
          ']',
    );

    final handledEvents = <HandledEvent>[];
    for (final event in events) {
      if (event.description?.isEmpty ?? true) {
        continue;
      }

      try {
        final handledEvent = HandledEvent.fromJsonWithEvent(
            event, json.decode(event.description));
        if (handledEvent.data.handlingDay == handledEvent.event.start.toDay()) {
          handledEvents.add(handledEvent);
        }
        // ignore: avoid_catches_without_on_clauses
      } catch (e) {
        // Don't add any events.
      }
    }

    final eventsToRepeat = handledEvents
        .safeWhere((handledEvent) {
          _logMessage('- HandledEvent <${handledEvent.event.eventId}>');
          if (!handledEvent.data.decision.shouldBeRepeated) {
            _logMessage(
              '  event decision ${handledEvent.data.decision} not repeatable. '
              'Excluding from events to repeat...',
            );
            return false;
          }

          final eventRemindDateHasPassed =
              DateTime.now().compareTo(handledEvent.data.remindDate) == 1;
          final eventIsTooOld = eventRemindDateHasPassed &&
              (DateTime.now().difference(handledEvent.event.start).inHours)
                      .abs() >
                  24;

          _logMessage('  ${{
            'eventRemindDateHasPassed': eventRemindDateHasPassed,
            'eventIsTooOld': eventIsTooOld,
          }}');

          return eventRemindDateHasPassed && !eventIsTooOld;
        })
        .map((handledEvent) => handledEvent.event)
        .toList();

    _logMessage(
      // ignore: prefer_interpolation_to_compose_strings, prefer_adjacent_string_concatenation
      'Events to repeat: ' +
          '[' +
          (eventsToRepeat.isEmpty
              ? 'NONE'
              : eventsToRepeat
                  .map((event) => '${event.title} (${event.eventId})')
                  .join(', ')) +
          ']',
    );

    final handledEventIds =
        handledEvents.map((handledEvent) => handledEvent.event.eventId);

    final queue = [
      ...events
          .where((event) => !handledEventIds.contains(event.eventId))
          .toList(),
      ...eventsToRepeat,
    ];
    // ..addAll()

    _logMessage(
      // ignore: prefer_interpolation_to_compose_strings, prefer_adjacent_string_concatenation
      'events to push: ' +
          '[' +
          (queue.isEmpty
              ? 'NONE'
              : queue.map((event) => event.format()).join(', ')) +
          ']',
    );

    _logMessage('pushing events...');
    _pushNewEvents(queue);
  }

  Future<List<Calendar>> getCalendars() {
    return _api.getCalendars();
  }

  Future<List<Event>> getEventsForCalendar(
    Calendar calendar, {
    @required DateTime start,
    @required DateTime end,
  }) {
    return _api.getEventsForCalendar(
      calendar,
      start: start,
      end: end,
    );
  }

  void deselectCalendar() {
    setSelectedCalendar(null);
  }

  void setSelectedCalendar(Calendar calendar) {
    if (_appState.selectedCalendar.value?.id == calendar?.id) {
      return;
    }

    _appState.selectedCalendar.value = calendar;
    _resetEventCheckTimer();
  }

  Future<void> handleEvent(Event event, EventDecision decision) async {
    final handledEvent = HandledEvent(
      event,
      data: EventHandlingData(
        decision: decision,
        remindDate: !decision.shouldBeRepeated
            ? null
            : DateTime.now().add(_handledEventPostponingDuration),
      ),
    );

    if (!decision.isDismiss && !decision.isAbort) {
      _currentHandledEvent.add(handledEvent);
      await Future.delayed(
        getHandledEventConfirmationDurationForDecision(decision),
      );
      _currentHandledEvent.add(null);
    }

    await _api.createOrUpdateEvent(handledEvent.getUpdatedEvent());
    _resetEventCheckTimer();
  }

  @override
  void dispose() {
    _eventCheckTimer.cancel();
    _currentHandledEvent.close();
    _eventQueue.close();
    super.dispose();
  }
}
