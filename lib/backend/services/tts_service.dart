import 'dart:async';
import 'dart:io';

import 'package:flutter_tts_improved/flutter_tts_improved.dart';
import 'package:pedantic/pedantic.dart';
import 'package:rxdart/rxdart.dart';

import 'package:socialbuddybot/backend/backend.dart';
import 'package:socialbuddybot/backend/models/calendar_models.dart';
import 'package:socialbuddybot/backend/services/services.dart';
import 'package:socialbuddybot/backend/services/tts_service/decision_response.dart';
import 'package:socialbuddybot/backend/services/tts_service/greeting.dart';

class TtsService extends Service {
  TtsService._() {
    _tts.setLanguage(Platform.isIOS ? _localeIOS : _localeAndroid);
  }

  static const _localeAndroid = 'nl_NL';
  static const _localeIOS = 'nl-NL';
  static const _captionsClearDuration = Duration(seconds: 5);

  final _tts = FlutterTtsImproved();
  final _captions = BehaviorSubject<String>();

  String _lastGreeting;
  bool _started = false;
  Timer _captionsClearTimer;

  ValueStream<String> get captions => _captions;

  static Future<TtsService> init() async {
    return TtsService._();
  }

  String _getEventAnnouncement(Event event) {
    if (event.type.isAction) {
      return event.actionPrompt;
    }

    return event.title;
  }

  void start() {
    assert(_started == false, 'TtsService has already been.');

    _started = true;

    backend.calendarRepository.latestQueuedEvent.listen((event) {
      final facesDetected = backend.faceDetectionService.facesDetected.value;
      if (!facesDetected) {
        return;
      }

      if (!backend.calendarRepository.hasCalendarSelected) {
        speak('Er is geen agenda geselecteerd.');
      } else if (event == null) {
        speak('Geen afspraken meer.');
        return;
      }

      speak(
        _getEventAnnouncement(event),
        clearAfterDelay: false,
      );
    });

    backend.calendarRepository.currentHandledEvent.listen((handledEvent) {
      if (handledEvent == null) {
        return;
      }

      final facesDetected = backend.faceDetectionService.facesDetected.value;
      if (!facesDetected) {
        return;
      }

      if (handledEvent.data.decision.isExecute) {
        speak(
          handledEvent.event.actionCommand,
          clearAfterDelay: true,
        );
      } else {
        speak(
          getDecisionResponse(handledEvent.data.decision),
          clearAfterDelay: false,
        );
      }
    });

    backend.faceDetectionService.facesDetected.listen((facesDetected) {
      if (!facesDetected) {
        return;
      }

      var greeting = getTimeGreeting();
      if (greeting == _lastGreeting) {
        greeting = '';
      } else {
        _lastGreeting = greeting;
      }

      var prompt = greeting;
      var clearAfterDelay = true;

      if (!backend.calendarRepository.hasCalendarSelected) {
        prompt = '$prompt Er is geen agenda geselecteerd.';
      } else {
        final latestQueuedEvent =
            backend.calendarRepository.latestQueuedEvent.value;

        if (backend.calendarRepository.latestQueuedEvent.value != null) {
          prompt = '$prompt ${_getEventAnnouncement(latestQueuedEvent)}';
          clearAfterDelay = false;
        }
      }

      speak(
        prompt.trim(),
        clearAfterDelay: clearAfterDelay,
      );
    });
  }

  void clearCaptions() {
    _captions.add(null);
  }

  Future<void> speak(
    String message, {
    bool clearAfterDelay = true,
  }) async {
    _captionsClearTimer?.cancel();

    if (message == null || message.isEmpty) {
      return;
    }

    _captions.add(message);

    final ttsCompleter = Completer<void>();
    _tts.setCompletionHandler(() {
      ttsCompleter.complete();
      _tts.setCompletionHandler(null);
    });

    unawaited(_tts.speak(message));

    await ttsCompleter.future;

    if (clearAfterDelay) {
      _captionsClearTimer = Timer(_captionsClearDuration, clearCaptions);
    }
  }
}
