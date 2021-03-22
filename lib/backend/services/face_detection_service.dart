import 'dart:async';

import 'package:firebase_ml_vision/firebase_ml_vision.dart';
import 'package:rxdart/rxdart.dart';

import 'package:socialbuddybot/backend/services/services.dart';
import 'package:socialbuddybot/utils/context_logger.dart';

class FaceDetectionService extends Service {
  static const _log = ContextLogger('FACES');
  static const _faceDetectionRate = Duration(milliseconds: 1000);
  static const _facesDetectedTimeoutDuration = Duration(seconds: 3);

  /// The amount of faces found since the last
  /// detection.
  // ignore: close_sinks
  final _facesDetected = BehaviorSubject<bool>.seeded(false);

  /// The amount of calls done to [handleFirebaseVisionImage]
  /// that have been done before [_canDetect] evaluated to true.
  int _rejectedCalls = 0;

  /// The last time the service attempted to detect faces.
  DateTime _lastDetectionTime;

  /// A timeout that, when expired, will
  /// set the amount of faces to 0.
  Timer _facesDetectedTimeoutTimer;

  /// Indicates if the time since the [_lastDetectionTime]
  /// exceeds the [_faceDetectionRate].
  bool get _canDetect {
    if (_lastDetectionTime == null) {
      return true;
    }

    return _lastDetectionTime.difference(DateTime.now()).abs() >
        _faceDetectionRate;
  }

  /// Sets the [_facesDetected]'s value.
  void _setFacesDetected(bool detected) {
    if (_facesDetected.value != detected) {
      _log.function('_setFacesDetected', 'Setting _facesDetected to $detected');
      _facesDetected.add(detected);
    }
  }

  /// Sets whether any faces are detected and
  /// starts the [_facesDetectedTimeoutTimer]
  /// if no faces are detected.
  void _registerFacesDetected(bool detected) {
    if (detected) {
      _facesDetectedTimeoutTimer?.cancel();
      _setFacesDetected(true);
    } else {
      _startFacesDetectedTimeoutCountdown();
    }
  }

  void _startFacesDetectedTimeoutCountdown() {
    final logMessage = _log.function('_startFacesDetectedTimeoutCountdown');

    if (_facesDetectedTimeoutTimer?.isActive ?? false) {
      return;
    }

    logMessage(
        'Starting timer with duration $_facesDetectedTimeoutDuration...');

    _facesDetectedTimeoutTimer = Timer(_facesDetectedTimeoutDuration, () {
      logMessage('_facesDetectedTimeoutTimer expired.');
      _setFacesDetected(false);
    });
  }

  /// The amount of faces found since the last
  /// detection.
  ValueStream<bool> get facesDetected => _facesDetected;

  Future<void> handleFirebaseVisionImage(
      FirebaseVisionImage visionImage) async {
    final logMessage = _log.function('handleFirebaseVisionImage');

    // If too little time has passed since the last check, do nothing.
    if (!_canDetect) {
      _rejectedCalls++;
      return;
    }

    _lastDetectionTime = DateTime.now();

    logMessage('Detecting faces after $_rejectedCalls calls...');

    _rejectedCalls = 0;
    final faces =
        await FirebaseVision.instance.faceDetector().processImage(visionImage);

    logMessage('Faces detected: ${faces.isNotEmpty}');

    _registerFacesDetected(faces.isNotEmpty);
  }
}
