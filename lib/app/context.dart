import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:socialbuddybot/backend/backend.dart';
import 'package:socialbuddybot/backend/repositories/repositories.dart';

extension WidgetContext<T extends StatefulWidget> on State<T> {
  MediaQueryData get mediaQuery => MediaQuery.of(context);
  ThemeData get theme => Theme.of(context);
  TextTheme get textTheme => theme.textTheme;
  TextStyle get defaultTextStyle => DefaultTextStyle.of(context).style;
  NavigatorState get navigator => Navigator.of(context);

  CalendarRepository get calendarRepository => backend.calendarRepository;
}
