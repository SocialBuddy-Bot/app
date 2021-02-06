import 'package:flutter/material.dart';

import 'package:socialbuddybot/app/assets.dart';
import 'package:socialbuddybot/app/theme.dart';
import 'package:socialbuddybot/backend/backend.dart';
import 'package:socialbuddybot/backend/models/calendar_models.dart';
import 'package:socialbuddybot/utils/utils.dart';
import 'package:socialbuddybot/ux/widgets/app_asset_image.dart';
import 'package:socialbuddybot/ux/widgets/value_stream_builder.dart';
import 'package:socialbuddybot/ux/widgets/widget_utils.dart';

class EventIconSection extends StatelessWidget {
  const EventIconSection();

  AppAsset getIcon(String eventTitle) {
    final titleLowerCase = eventTitle.toLowerCase();

    if (titleLowerCase.containsAny(['eten', 'diner', 'maaltijd'])) {
      return AppImages.food;
    }

    if (titleLowerCase.containsAny(['medicijn', 'medicijnen', 'pillen'])) {
      return AppImages.medicine;
    }

    if (titleLowerCase.containsAny(['muziek', 'speel'])) {
      return AppImages.music;
    }

    if (titleLowerCase.containsAny(['zuster', 'verzorging'])) {
      return AppImages.nurse;
    }

    if (titleLowerCase.containsAny(['bezoek', 'familie'])) {
      return AppImages.visitors;
    }

    return AppImages.event;
  }

  @override
  Widget build(BuildContext context) {
    return ValueStreamBuilder2<bool, Event>(
      valueStream1: backend.faceDetectionService.facesDetected,
      valueStream2: backend.calendarRepository.latestQueuedEvent,
      builder: (context, facesDetected, event) {
        final enabled = facesDetected && event != null;

        final child = !enabled
            ? emptyWidget
            : AppAssetImage(
                getIcon(event.title),
                color: AppTheme.colorGrey,
              );

        return AnimatedSwitcher(
          duration: const Duration(milliseconds: 200),
          child: SizedBox(
            key: !enabled
                ? const Key('event-icon-section-hidden')
                : Key(
                    'event-icon-section-with-icon-${getIcon(event.title).path}',
                  ),
            child: child,
          ),
        );
      },
    );
  }
}
