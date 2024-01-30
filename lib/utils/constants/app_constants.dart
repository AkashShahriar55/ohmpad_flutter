import 'dart:io';

abstract class AppConstants {
  static const String APP_NAME = "OhmPad";
  static const String EMAIL_PATTERN =
      r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';

  static final deviceType = Platform.isAndroid ? "A" : "I";
  static const int USER_TYPE_ADMIN = 1;
  static const int USER_TYPE_SUB_ADMIN = 2;
}
