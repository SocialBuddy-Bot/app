import 'dart:async';
import 'dart:io';
import 'dart:typed_data';
import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:camera/camera.dart';
import 'package:firebase_ml_vision/firebase_ml_vision.dart';
import 'package:path_provider/path_provider.dart';

import 'package:socialbuddybot/utils/utils.dart';

typedef ErrorWidgetBuilder = Widget Function(
    BuildContext context, CameraError error);

enum CameraError {
  unknown,
  cantInitializeCamera,
  androidVersionNotSupported,
  noCameraAvailable,
}

enum _CameraState {
  loading,
  error,
  ready,
}

class MlVisionCamera<T> extends StatefulWidget {
  const MlVisionCamera({
    Key key,
    @required this.detector,
    this.loadingBuilder,
    this.errorBuilder,
    this.overlayBuilder,
    this.cameraLensDirection = CameraLensDirection.back,
    this.resolution,
  })  : assert(detector != null, 'detector cannot be null.'),
        super(key: key);

  final FutureValueChanged<FirebaseVisionImage> detector;
  final WidgetBuilder loadingBuilder;
  final ErrorWidgetBuilder errorBuilder;
  final WidgetBuilder overlayBuilder;
  final CameraLensDirection cameraLensDirection;
  final ResolutionPreset resolution;

  @override
  MlVisionCameraState createState() => MlVisionCameraState<T>();
  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(ObjectFlagProperty<FutureValueChanged<FirebaseVisionImage>>.has(
          'detector', detector))
      ..add(ObjectFlagProperty<WidgetBuilder>.has(
          'loadingBuilder', loadingBuilder))
      ..add(ObjectFlagProperty<ErrorWidgetBuilder>.has(
          'errorBuilder', errorBuilder))
      ..add(ObjectFlagProperty<WidgetBuilder>.has(
          'overlayBuilder', overlayBuilder))
      ..add(EnumProperty<CameraLensDirection>(
          'cameraLensDirection', cameraLensDirection))
      ..add(EnumProperty<ResolutionPreset>('resolution', resolution));
  }
}

class MlVisionCameraState<T> extends State<MlVisionCamera<T>> {
  XFile _lastImage;
  CameraController _cameraController;
  ImageRotation _rotation;
  _CameraState _mlVisionCameraState = _CameraState.loading;
  CameraError _cameraError = CameraError.unknown;
  bool _alreadyCheckingImage = false;
  bool _isStreaming = false;
  bool _isInactive = false;

  @override
  void initState() {
    super.initState();
    _initialize();
  }

  Future<void> stop() async {
    if (_cameraController != null) {
      if (_lastImage != null && File(_lastImage.path).existsSync()) {
        await File(_lastImage.path).delete();
      }

      try {
        _lastImage = await _cameraController.takePicture();
      } on PlatformException catch (e) {
        debugPrint('$e');
      }

      _stop(false);
    }
  }

  void _stop(bool silently) {
    Future.microtask(() async {
      if (_cameraController?.value?.isStreamingImages == true && mounted) {
        await _cameraController.stopImageStream();
      }
    });

    if (silently) {
      _isStreaming = false;
    } else {
      setState(() {
        _isStreaming = false;
      });
    }
  }

  void start() {
    if (_cameraController != null) {
      _start(false);
    }
  }

  void _start(bool silently) {
    _cameraController.startImageStream(_processImage);
    if (silently) {
      _isStreaming = true;
    } else {
      setState(() {
        _isStreaming = true;
      });
    }
  }

  CameraValue get cameraValue => _cameraController?.value;
  ImageRotation get imageRotation => _rotation;

  Future<void> Function() get prepareForVideoRecording =>
      _cameraController.prepareForVideoRecording;

  Future<void> startVideoRecording() async {
    await _cameraController.stopImageStream();
    return _cameraController.startVideoRecording();
  }

  Future<void> stopVideoRecording() async {
    await _cameraController.stopVideoRecording();
    await _cameraController.startImageStream(_processImage);
  }

  Future<void> Function() get takePicture => _cameraController.takePicture;

  Future<void> _initialize() async {
    final description = await _getCamera(widget.cameraLensDirection);
    if (description == null) {
      _mlVisionCameraState = _CameraState.error;
      _cameraError = CameraError.noCameraAvailable;

      return;
    }
    _cameraController = CameraController(
      description,
      // As the docs say, better to set this to low when streaming images to
      // avoid dropping frames on older devices.
      widget.resolution ?? ResolutionPreset.low,
      enableAudio: false,
    );
    if (!mounted) {
      return;
    }

    try {
      await _cameraController.initialize();
    } on CameraException catch (ex, stack) {
      setState(() {
        _mlVisionCameraState = _CameraState.error;
        _cameraError = CameraError.cantInitializeCamera;
      });
      debugPrint('Can\'t initialize camera');
      debugPrint('$ex, $stack');
      return;
    }

    setState(() {
      _mlVisionCameraState = _CameraState.ready;
    });
    _rotation = _rotationIntToImageRotation(0);

    await Future.delayed(const Duration(milliseconds: 200));
    start();
  }

  @override
  void deactivate() {
    final isCurrentRoute = ModalRoute.of(context).isCurrent;
    if (_cameraController != null) {
      if (_isInactive && isCurrentRoute) {
        _isInactive = false;
        _start(true);
      } else if (!_isInactive) {
        _isInactive = true;
        _stop(true);
      }
    }
    super.deactivate();
  }

  @override
  void dispose() {
    if (_lastImage != null && File(_lastImage.path).existsSync()) {
      File(_lastImage.path).delete();
    }
    if (_cameraController != null) {
      _cameraController.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_mlVisionCameraState == _CameraState.loading) {
      return widget.loadingBuilder == null
          ? const Center(child: CircularProgressIndicator())
          : widget.loadingBuilder(context);
    }
    if (_mlVisionCameraState == _CameraState.error) {
      return widget.errorBuilder == null
          ? Center(child: Text('$_mlVisionCameraState $_cameraError'))
          : widget.errorBuilder(context, _cameraError);
    }

    Widget cameraPreview = AspectRatio(
      aspectRatio: _cameraController.value.aspectRatio,
      child: _isStreaming
          ? CameraPreview(
              _cameraController,
            )
          : _getPicture(),
    );
    if (widget.overlayBuilder != null) {
      cameraPreview = Stack(
        fit: StackFit.passthrough,
        children: [
          cameraPreview,
          widget.overlayBuilder(context),
        ],
      );
    }
    return FittedBox(
      alignment: Alignment.center,
      fit: BoxFit.cover,
      child: SizedBox(
        width: _cameraController.value.previewSize.height *
            _cameraController.value.aspectRatio,
        height: _cameraController.value.previewSize.height,
        child: cameraPreview,
      ),
    );
  }

  Future<void> _processImage(CameraImage cameraImage) async {
    if (!_alreadyCheckingImage) {
      _alreadyCheckingImage = true;
      try {
        await _detect(cameraImage, widget.detector, _rotation);
      } on Exception catch (e, stack) {
        debugPrint('$e, $stack');
      }
      _alreadyCheckingImage = false;
    }
  }

  void toggle() {
    if (_isStreaming && _cameraController.value.isStreamingImages) {
      stop();
    } else {
      start();
    }
  }

  Widget _getPicture() {
    if (_lastImage != null) {
      final file = File(_lastImage.path);
      if (file.existsSync()) {
        return Image.file(file);
      }
    }

    return const SizedBox();
  }
}

Future<CameraDescription> _getCamera(CameraLensDirection dir) {
  return availableCameras().then(
    (cameras) => cameras.firstWhere(
      (camera) => camera.lensDirection == dir,
      orElse: () => cameras.isNotEmpty ? cameras.first : null,
    ),
  );
}

Uint8List _concatenatePlanes(List<Plane> planes) {
  final allBytes = WriteBuffer();
  for (final plane in planes) {
    allBytes.putUint8List(plane.bytes);
  }
  return allBytes.done().buffer.asUint8List();
}

FirebaseVisionImageMetadata buildMetaData(
  CameraImage image,
  ImageRotation rotation,
) {
  return FirebaseVisionImageMetadata(
    rawFormat: image.format.raw,
    size: Size(image.width.toDouble(), image.height.toDouble()),
    rotation: rotation,
    planeData: image.planes
        .map(
          (plane) => FirebaseVisionImagePlaneMetadata(
            bytesPerRow: plane.bytesPerRow,
            height: plane.height,
            width: plane.width,
          ),
        )
        .toList(),
  );
}

Future<void> _detect(
  CameraImage image,
  FutureValueChanged<FirebaseVisionImage> handleDetection,
  ImageRotation rotation,
) {
  return handleDetection(
    FirebaseVisionImage.fromBytes(
      _concatenatePlanes(image.planes),
      buildMetaData(image, rotation),
    ),
  );
}

ImageRotation _rotationIntToImageRotation(int rotation) {
  switch (rotation) {
    case 0:
      return ImageRotation.rotation0;
    case 90:
      return ImageRotation.rotation90;
    case 180:
      return ImageRotation.rotation180;
    case 270:
      return ImageRotation.rotation270;
    default:
      throw UnsupportedError(
          'Image rotation of $rotation degrees not possible.');
  }
}
