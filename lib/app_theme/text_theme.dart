import 'package:flutter/material.dart';
import 'package:ohm_pad/utils/constants/color_constants.dart';
import 'package:ohm_pad/utils/size_utils.dart';


textThemeLight() {
  return TextTheme(
      headline6: new TextStyle(fontWeight: FontWeight.w700),
      headline4: new TextStyle(fontWeight: FontWeight.w700, color: ColorConstants.APP_THEME_COLOR),
      headline5: new TextStyle(fontWeight: FontWeight.w600, color: ColorConstants.PRIMARY_COLOR),
      subtitle1: new TextStyle(color: ColorConstants.APP_THEME_COLOR),
      bodyText1:
          new TextStyle(color: ColorConstants.APP_THEME_COLOR, fontWeight: FontWeight.w600),
      bodyText2:
          new TextStyle(fontWeight: FontWeight.w600),
      caption:
          new TextStyle(fontWeight: FontWeight.w600),
      button: new TextStyle(
          color: Colors.black,
          fontWeight: FontWeight.w600,
          fontSize: SizeUtils.getFontSize(16)));
}
