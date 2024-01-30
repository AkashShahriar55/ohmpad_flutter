import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ohm_pad/utils/constants/color_constants.dart';
import 'package:ohm_pad/utils/size_utils.dart';

buttonThemeLight() {
  return ButtonThemeData(
      padding: const EdgeInsets.all(25.0),
      buttonColor: ColorConstants.PRIMARY_COLOR,
      shape: RoundedRectangleBorder(
          borderRadius: new BorderRadius.circular(10.0)));
}

class ButtonUtils {
  static Widget btnFillGrey(String title, onTap) {
    return ElevatedButton(
      child: Text(title,
          textAlign: TextAlign.center,
          style: TextStyle(color: ColorConstants.PRIMARY_COLOR)),
      onPressed: onTap,
      style: ElevatedButton.styleFrom(
        shape: RoundedRectangleBorder(
            borderRadius: new BorderRadius.circular(10.0)),
        primary: ColorConstants.BTN_GREY_COLOR,
        minimumSize: Size(SizeUtils.get(20), SizeUtils.get(50)),
      ),
    );
  }

  static Widget btnFill({String? title, onTap}) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(30)),
        // color: ColorConstants.SECONDARY_COLOR,
        gradient: LinearGradient(
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          colors: [
            ColorConstants.SECONDARY_COLOR,
            ColorConstants.THEME_PINK_COLOR,
          ],
        ),
      ),
      child: ElevatedButton(
        child: Text(title!,
            textAlign: TextAlign.center, style: TextStyle(color: Colors.white)),
        onPressed: onTap,
        style: ElevatedButton.styleFrom(
          shape: RoundedRectangleBorder(
              borderRadius: new BorderRadius.circular(10.0)),
          primary: ColorConstants.PRIMARY_COLOR,
          minimumSize: Size(SizeUtils.get(20), SizeUtils.get(50)),
        ),
      ),
    );
  }

  static Widget btnFillSimple({String? title, onTap}) {
    return ElevatedButton(
      child: Text(title!,
          textAlign: TextAlign.center, style: TextStyle(color: Colors.white)),
      onPressed: onTap,
      style: ElevatedButton.styleFrom(
        shape: RoundedRectangleBorder(
            borderRadius: new BorderRadius.circular(5.0)),
        primary: ColorConstants.PRIMARY_COLOR,
      ),
    );
  }

  static Widget btnFillGreen({required String title, onTap}) {
    return ElevatedButton(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: SizeUtils.get(28), vertical: SizeUtils.get(10)),
        child: Text(title,
            textAlign: TextAlign.center, style: TextStyle(color: Colors.white)),
      ),
      onPressed: onTap,
      style: ElevatedButton.styleFrom(
        shape: RoundedRectangleBorder(
            borderRadius: new BorderRadius.circular(10)),
        primary: ColorConstants.APP_THEME_COLOR,
      ),
    );
  }
}
