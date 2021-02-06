import 'package:flutter/material.dart';

import 'package:camera/camera.dart';
import 'package:firebase_ml_vision/firebase_ml_vision.dart';

import 'package:socialbuddybot/backend/backend.dart';
import 'package:socialbuddybot/ux/widgets/ml_vision_camera.dart';
import 'package:socialbuddybot/ux/widgets/value_stream_builder.dart';

class FaceDetectionCamera extends StatelessWidget {
  const FaceDetectionCamera() : super(key: const Key('face-detection-camera'));
  @override
  Widget build(BuildContext context) {
    final faceDetectionService = backend.faceDetectionService;
    return MlVisionCamera<List<Face>>(
      detector: faceDetectionService.handleFirebaseVisionImage,
      cameraLensDirection: CameraLensDirection.front,
      resolution: ResolutionPreset.low,
      overlayBuilder: (context) {
        return Align(
          alignment: Alignment.topLeft,
          child: ValueStreamBuilder<bool>(
            valueStream: faceDetectionService.facesDetected,
            builder: (context, detected) {
              return Material(
                color: Colors.black.withOpacity(0.5),
                child: Text(
                  'FacesDetected: $detected',
                  style: const TextStyle(fontSize: 16, color: Colors.white),
                ),
              );
            },
          ),
        );
      },
    );
  }
}
