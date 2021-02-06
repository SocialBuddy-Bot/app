import 'package:flutter/material.dart';

import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:socialbuddybot/app/theme.dart';
import 'package:socialbuddybot/backend/backend.dart';
import 'package:socialbuddybot/backend/models/calendar_models.dart';
import 'package:socialbuddybot/ux/widgets/value_stream_builder.dart';
import 'package:socialbuddybot/ux/widgets/widget_utils.dart';

class EventButtonSection extends StatelessWidget with WidgetUtils {
  const EventButtonSection();

  static const _eventDismissDelayDuration = Duration(seconds: 10);

  void onHandleEvent(
    BuildContext context,
    Event event,
    EventDecision decision,
  ) {
    print('onHandleEvent - ${event.format()}, $decision');

    backend.calendarRepository.handleEvent(event, decision);

    if (!decision.isDismiss) {
      showSnackBar(
        context: context,
        message: decision.isPostpone
            ? 'Afspraak toegevoegd aan herinneringen.'
            : 'Afspraak afgevinkt.',
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return ValueStreamBuilder3<bool, Event, HandledEvent>(
      valueStream1: backend.faceDetectionService.facesDetected,
      valueStream2: backend.calendarRepository.latestQueuedEvent,
      valueStream3: backend.calendarRepository.currentHandledEvent,
      builder: (context, facesDetected, event, currentHandledEvent) {
        final eventIsBeingHandled = currentHandledEvent != null;
        final shouldBeEnabled =
            facesDetected && event != null && !eventIsBeingHandled;
        final shouldShowCountdown = eventIsBeingHandled ||
            (shouldBeEnabled &&
                (event.type.isAnnouncement || event.type.isReminder));

        final shouldBeVisible = shouldBeEnabled || shouldShowCountdown;

        Widget child;

        if (!shouldBeVisible) {
          child = const SizedBox();
        } else if (shouldShowCountdown) {
          child = _CountdownCircle(
            key: Key(
              'event-buttons-section-countdown-circle-'
              'event-${event.eventId}-'
              'with-handling-event-$eventIsBeingHandled',
            ),
            duration: eventIsBeingHandled
                ? CalendarRepository
                    .getHandledEventConfirmationDurationForDecision(
                    currentHandledEvent.data.decision,
                  )
                : _eventDismissDelayDuration,
            onComplete: eventIsBeingHandled
                ? null
                : () {
                    onHandleEvent(
                      context,
                      event,
                      EventDecision.dismiss,
                    );
                  },
          );
        } else {
          child = Column(
            key: Key(
              'event-buttons-section-buttons-enabled-$shouldBeEnabled',
            ),
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Expanded(
                child: SizedBox(
                  width: double.infinity,
                  child: FloatingActionButton.extended(
                    elevation: 2.0,
                    backgroundColor: AppTheme.colorPostpone,
                    onPressed: () {
                      onHandleEvent(
                        context,
                        event,
                        event.type.isAction
                            ? EventDecision.abort
                            : EventDecision.postpone,
                      );
                    },
                    icon: Icon(
                      event.type.isAction
                          ? FontAwesomeIcons.times
                          : FontAwesomeIcons.clock,
                    ),
                    label: Text(
                      event.type.isAction ? 'Nee, doe niets' : 'Herinneren',
                    ),
                  ),
                ),
              ),
              verticalMargin8,
              Expanded(
                child: SizedBox(
                  width: double.infinity,
                  child: FloatingActionButton.extended(
                    elevation: 2.0,
                    backgroundColor: !shouldBeEnabled
                        ? AppTheme.colorGrey
                        : AppTheme.colorCheckOff,
                    onPressed: !shouldBeEnabled
                        ? null
                        : () {
                            onHandleEvent(
                              context,
                              event,
                              event.type.isAction
                                  ? EventDecision.execute
                                  : EventDecision.checkOff,
                            );
                          },
                    icon: const Icon(FontAwesomeIcons.check),
                    label: Text(
                      event.type.isAction ? 'Ja, voer uit' : 'Afvinken',
                    ),
                  ),
                ),
              ),
            ],
          );
        }

        return AnimatedSwitcher(
          duration: const Duration(milliseconds: 200),
          child: child,
        );
      },
    );
  }
}

class _CountdownCircle extends StatefulWidget {
  const _CountdownCircle({
    Key key,
    @required this.duration,
    @required this.onComplete,
  }) : super(key: key);

  final Duration duration;
  final VoidCallback onComplete;

  @override
  __CountdownCircleState createState() => __CountdownCircleState();
}

class __CountdownCircleState extends State<_CountdownCircle>
    with SingleTickerProviderStateMixin {
  AnimationController animation;

  @override
  void initState() {
    super.initState();
    animation = AnimationController(
      vsync: this,
      duration: widget.duration,
    )
      ..forward()
      ..addListener(onTick);
  }

  void onTick() {
    if (animation.value == 1.0) {
      widget.onComplete?.call();
    }

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return CircularProgressIndicator(
      value: 1 - animation.value,
      valueColor: const AlwaysStoppedAnimation(Colors.white),
    );
  }
}
