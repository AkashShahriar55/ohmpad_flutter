import 'package:flutter/material.dart';
import 'package:ohm_pad/utils/constants/color_constants.dart';
import 'package:ohm_pad/utils/size_utils.dart';

inputDecorationThemeLight() {
  return InputDecorationTheme(
    fillColor: ColorConstants.TEXTFIELD_BACKGROUND_COLOR,
    filled: true,
    errorMaxLines: 2,

    // hintStyle: TextStyle(
    //     color: ColorConstants.CAPTION_TEXT_COLOR,
    //     fontSize: SizeUtils.getFontSize(16),
    //     fontWeight: FontWeight.w500),
    labelStyle: TextStyle(
        color: ColorConstants.CAPTION_TEXT_COLOR,
        fontSize: SizeUtils.getFontSize(16),
        fontWeight: FontWeight.w500),
    // border: InputBorder.none
    border: OutlineInputBorder(

      borderSide: BorderSide(width: 0,color: Colors.transparent),
      borderRadius: BorderRadius.all(Radius.circular(8.0)),
    ),
    disabledBorder: OutlineInputBorder(
      borderSide: BorderSide(width: 0,color: Colors.transparent),
      borderRadius: BorderRadius.all(Radius.circular(8.0)),
    ),
    enabledBorder: OutlineInputBorder(
      borderSide: BorderSide(width: 0, color: Colors.transparent),
      borderRadius: BorderRadius.all(Radius.circular(8.0)),
    ),
    focusedBorder: OutlineInputBorder(
      borderSide: BorderSide(width: 2, color: ColorConstants.SECONDARY_COLOR),
      borderRadius: BorderRadius.all(Radius.circular(8.0)),
    ),
  );
}
