import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:socialbuddybot/app/app.dart';
import 'package:socialbuddybot/backend/backend.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Backend.init();
  await SystemChrome.setEnabledSystemUIOverlays([]);
  runApp(const App());
}
