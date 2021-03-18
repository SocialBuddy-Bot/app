import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:socialbuddybot/app/theme.dart';
import 'package:socialbuddybot/ux/main_container/calendar_select_drawer.dart';
import 'package:socialbuddybot/ux/main_container/debug_drawer.dart';
import 'package:socialbuddybot/ux/main_container/screens/event_screen.dart';
import 'package:socialbuddybot/ux/widgets/face_detection_camera.dart';

class MainContainer extends StatelessWidget {
  MainContainer({Key key}) : super(key: key);

  final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Material(
      type: MaterialType.transparency,
      child: Stack(
        children: <Widget>[
          ScaffoldMessenger(
            child: Scaffold(
              backgroundColor: AppTheme.colorBackgroundDark,
              key: _scaffoldKey,
              drawer: CalendarSelectDrawer(),
              endDrawer: DebugDrawer(),
              body: const Padding(
                padding: EdgeInsets.all(8.0),
                child: EventScreen(),
              ),
            ),
          ),
          Align(
            alignment: Alignment.topLeft,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: IconButton(
                icon: const Icon(Icons.menu),
                onPressed: () => _scaffoldKey.currentState.openDrawer(),
              ),
            ),
          ),
          Align(
            alignment: Alignment.topRight,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: IconButton(
                icon: const Icon(Icons.bug_report),
                onPressed: () => _scaffoldKey.currentState.openEndDrawer(),
              ),
            ),
          ),
          const Align(
            alignment: Alignment.bottomLeft,
            child: Offstage(
              child: FaceDetectionCamera(),
            ),
          ),
        ],
      ),
    );
  }
}
