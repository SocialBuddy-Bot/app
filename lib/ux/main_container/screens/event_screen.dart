import 'package:flutter/material.dart';

import 'package:socialbuddybot/ux/main_container/screens/event_screen/animation_section.dart';
import 'package:socialbuddybot/ux/main_container/screens/event_screen/captions_section.dart';
import 'package:socialbuddybot/ux/main_container/screens/event_screen/event_buttons_section.dart';
import 'package:socialbuddybot/ux/main_container/screens/event_screen/event_icon_section.dart';

class EventScreen extends StatelessWidget {
  const EventScreen();

  static const _bottomChildrenHeight = 124.0;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Spacer(flex: 2),
        Expanded(
          flex: 5,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: const [
              Expanded(
                child: AnimationSection(),
              ),
              SizedBox(
                height: _bottomChildrenHeight,
                child: Center(
                  child: CaptionsSection(),
                ),
              ),
            ],
          ),
        ),
        Expanded(
          flex: 2,
          child: Column(
            children: const [
              Expanded(
                child: EventIconSection(),
              ),
              SizedBox(
                height: _bottomChildrenHeight,
                child: Center(
                  child: EventButtonSection(),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
