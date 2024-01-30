import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';

class SizeUtils {
  static double? _widthMultiplier;
  static double? _heightMultiplier;
  static double? screenWidth;
  static double? screenHeight;
  static bool? isTablet;

  static void init(BoxConstraints boxConstraints, Orientation orientation) {
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    screenWidth = boxConstraints.maxWidth;
    screenHeight = boxConstraints.maxHeight;
    if (orientation == Orientation.portrait) {
      _widthMultiplier = boxConstraints.maxWidth / 100;
      _heightMultiplier = boxConstraints.maxHeight / 100;
    } else {
      _widthMultiplier = boxConstraints.maxHeight / 100;
      _heightMultiplier = boxConstraints.maxWidth / 100;
    }
    isTablet = screenWidth! > 600.0;
  }

  static double get(double size) {
    if (screenWidth! < 600) {
      return size;
    } else {
      return size * 1.5;
    }
  }

  static double getFontSize(double size) {
    if (screenWidth! < 600) {
      return size;
    } else {
      return size * 1.5;
    }
  }

  static double getHeightAsPerPercent(double percent) {
    // print("screenHeight : $screenHeight");
    // print("screenWidth : $screenWidth");

    bool isSmallDevice = SizeUtils.screenHeight! < 600;
    bool isTablet = SizeUtils.screenWidth! > 600;

    // print('percent before');
    // print(percent);
    if (isSmallDevice) {
      // This will minus 30% from percent which is for large device.
      percent = percent - (percent * 0.3);
    }
    // print('percent after');
    // print(percent);
    return screenHeight! * (percent / 100);
  }

  static double getWidthAsPerPercent(double percent) {
    return screenWidth! * (percent / 100);
  }
}
