import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class AppTheme {
  const AppTheme._();

  static const fontWeightExtraLight = FontWeight.w200;
  static const fontWeightLight = FontWeight.w300;
  static const fontWeightNormal = FontWeight.w400;
  static const fontWeightMedium = FontWeight.w500;
  static const fontWeightSemiBold = FontWeight.w600;
  static const fontWeightBold = FontWeight.w700;

  static const iconHeart = FontAwesomeIcons.solidHeart;

  static const colorWhite = Colors.white;
  static const colorBlack = Colors.black;
  static const colorLightGrey = Color(0xFFF4F4F4);
  static const colorGrey = Color(0xFFC3C3C3);
  static const colorDarkGrey = Color(0xFF303030);
  static const colorDarkerGrey = Color(0xFF202020);
  static const colorBlackAlmostTransparent = Color(0x50000000);
  static const colorOrange = Color(0xFFFFA726);
  static const colorPink = Color(0xFFED6696);
  static const colorDarkPink = Color(0xFFC34271);
  static const colorDarkerPink = Color(0xFF8E2F52);
  static const colorDarkestPink = Color(0xFF49182A);
  static const colorNeonGreen = Color(0xFF16FFBD);
  static const colorGreen = Color(0xFF12C998);
  static const colorDarkerGreen = Color(0xFF439F76);
  static const colorLightRed = Color(0xFFB71C1C);
  static const colorRed = Color(0xFFD32F2F);
  static const colorDarkRed = Color(0xFFB71C1C);
  static const colorBlue = Color(0xFF2287DD);
  static const colorBlueGreen = Color(0xFF12C6C9);

  static const colorMain = colorOrange;

  static const colorBackgroundLight = Color(0xFFF8F9FA);
  static const colorBackgroundDark = Color(0xFF74706F);

  static const colorCheckOff = colorGreen;
  static const colorPostpone = colorOrange;

  static const curve = Curves.easeOutQuad;

  static const durationSwitchingAnimation = Duration(milliseconds: 300);

  static ThemeData theme() {
    return ThemeData.light().copyWith(
      primaryColor: colorMain,
      iconTheme: ThemeData.dark().iconTheme,
    );
  }
}

extension LightDark on Brightness {
  bool get isDark => onValue(dark: true, orElse: false);
  bool get isLight => onValue(light: true, orElse: false);

  T onValue<T>({
    T light,
    T dark,
    T orElse,
  }) {
    T result;

    switch (this) {
      case Brightness.light:
        result = light;
        break;
      case Brightness.dark:
        result = dark;
        break;
      default:
        if (orElse == null) {
          throw UnsupportedError('Invalid value');
        }
    }

    return result ?? orElse;
  }
}
