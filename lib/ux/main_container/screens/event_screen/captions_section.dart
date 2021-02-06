import 'package:flutter/material.dart';

import 'package:socialbuddybot/backend/backend.dart';
import 'package:socialbuddybot/ux/widgets/value_stream_builder.dart';
import 'package:socialbuddybot/ux/widgets/widget_utils.dart';

class CaptionsSection extends StatelessWidget {
  const CaptionsSection();

  @override
  Widget build(BuildContext context) {
    return ValueStreamBuilder2<bool, String>(
      valueStream1: backend.faceDetectionService.facesDetected,
      valueStream2: backend.ttsService.captions,
      builder: (context, facesDetected, captions) {
        final enabled =
            facesDetected && captions != null && captions.isNotEmpty;

        final child = !enabled
            ? emptyWidget
            : Card(
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Text(
                    captions,
                    style: Theme.of(context).textTheme.headline5,
                  ),
                ),
              );

        return AnimatedSwitcher(
          duration: const Duration(milliseconds: 200),
          child: SizedBox(
            key: !enabled
                ? const Key('captions-section-hidden')
                : Key('captions-section-with-content-"$captions"'),
            child: child,
          ),
        );
      },
    );
  }
}
