import 'package:flutter/widgets.dart';

import 'package:get_it/get_it.dart';
import 'package:meta/meta.dart';

import 'package:socialbuddybot/backend/api/api.dart';
import 'package:socialbuddybot/backend/app_state_store.dart';
import 'package:socialbuddybot/backend/repositories/repositories.dart';
import 'package:socialbuddybot/backend/services/services.dart';

export 'api/api.dart';
export 'repositories/repositories.dart';
export 'services/services.dart';

Backend get backend => Backend.instance;

class Backend {
  Backend._({
    @required this.calendarRepository,
    @required this.faceDetectionService,
    @required this.ttsService,
    @required this.animationService,
  });

  static Future<void> init() async {
    const api = Api();
    final appState = await AppStateStore.init();

    final backend = Backend._(
      calendarRepository: await CalendarRepository.init(api, appState),
      faceDetectionService: FaceDetectionService(),
      ttsService: await TtsService.init(),
      animationService: await AnimationService.init(),
    );

    GetIt.instance.registerSingleton<Backend>(backend);

    backend.ttsService.start();
    backend.animationService.start();
  }

  static Backend get instance {
    return GetIt.instance.get<Backend>();
  }

  final CalendarRepository calendarRepository;

  final FaceDetectionService faceDetectionService;
  final TtsService ttsService;
  final AnimationService animationService;
}
