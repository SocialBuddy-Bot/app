import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:socialbuddybot/app/theme.dart';
import 'package:socialbuddybot/ux/main_container.dart';

class App extends StatelessWidget {
  const App({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Social Buddy Bot',
      theme: AppTheme.theme(),
      home: MainContainer(
        key: const ValueKey('root-main-container'),
      ),
    );
  }
}
