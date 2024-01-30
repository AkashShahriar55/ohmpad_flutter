import 'package:flutter/material.dart';
import 'package:ohm_pad/utils/constants/color_constants.dart';
import 'package:ohm_pad/utils/constants/font_constants.dart';

import 'button_theme.dart';
import 'input_decoration_theme.dart';
import 'text_theme.dart';

class MyAppTheme {
  static final ThemeData lightTheme = ThemeData(
    fontFamily: FontConstants.philosopher,
    focusColor: ColorConstants.SECONDARY_COLOR,
    hintColor: ColorConstants.SECONDARY_COLOR,
    primaryColor: ColorConstants.SECONDARY_COLOR,
    // buttonColor: ColorConstants.PRIMARY_COLOR,
    // accentColor: ColorConstants.APP_THEME_COLOR,
    scaffoldBackgroundColor: ColorConstants.BG_LIGHT_WHITE,
    brightness: Brightness.light,
    buttonTheme: buttonThemeLight(),
    textTheme: textThemeLight(),
    inputDecorationTheme: inputDecorationThemeLight(),
  );
}
