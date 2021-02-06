import 'package:flutter/material.dart';

import 'package:socialbuddybot/ux/main_container/screens/event_screen/animation_section.dart';

class IdleScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.all(16.0),
      child: AnimationSection(),
    );
  }
}
