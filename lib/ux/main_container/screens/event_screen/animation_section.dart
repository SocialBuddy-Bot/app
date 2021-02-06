import 'dart:async';

import 'package:flutter/material.dart';

import 'package:flare_flutter/flare_actor.dart';
import 'package:flare_flutter/flare_controls.dart';

import 'package:socialbuddybot/backend/backend.dart';
import 'package:socialbuddybot/backend/models/animation_models.dart';
import 'package:socialbuddybot/ux/widgets/value_stream_builder.dart';

class AnimationSection extends StatefulWidget {
  const AnimationSection();

  @override
  _AnimationSectionState createState() => _AnimationSectionState();
}

class _AnimationSectionState extends State<AnimationSection> {
  StreamSubscription<AnimationState> _subscription;

  final _controller = FlareControls();

  @override
  void initState() {
    super.initState();
    final stateStream = backend.animationService.state;

    _controller.play('${stateStream.value}');

    _subscription = stateStream.listen((state) {
      _controller.play('$state');
    });
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ValueStreamBuilder(
      valueStream: backend.animationService.state,
      builder: (context, state) {
        return FlareActor(
          'assets/images/flare/eyes.flr',
          alignment: Alignment.center,
          controller: _controller,
        );
      },
    );
  }
}
