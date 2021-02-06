import 'dart:async';

import 'package:rxdart/rxdart.dart';

import 'package:socialbuddybot/backend/backend.dart';
import 'package:socialbuddybot/backend/models/animation_models.dart';
import 'package:socialbuddybot/backend/services/services.dart';

class AnimationService extends Service {
  AnimationService._();

  final _state = BehaviorSubject<AnimationState>.seeded(AnimationState.closed);

  bool _started = false;

  ValueStream<AnimationState> get state => _state;

  static Future<AnimationService> init() async {
    return AnimationService._();
  }

  void start() {
    assert(_started == false, 'AnimationService has already been.');

    backend.calendarRepository.currentHandledEvent.listen((handledEvent) {
      if (handledEvent == null) {
        return;
      }

      if (handledEvent.data.decision.isCheckOff) {
        _state.add(AnimationState.happy);
      } else if (handledEvent.data.decision.isPostpone) {
        _state.add(AnimationState.sad);
      }
    });

    backend.faceDetectionService.facesDetected.listen((facesDetected) {
      if (facesDetected) {
        _state.add(AnimationState.awakened);
      } else {
        _state.add(AnimationState.closed);
      }
    });

    _started = true;
  }

  void dispose() {
    _state.close();
  }
}
