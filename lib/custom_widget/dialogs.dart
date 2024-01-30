import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ohm_pad/utils/constants/app_constants.dart';
import 'package:ohm_pad/utils/strings.dart';

class Dialogs {
  /// Show info dialogs with OK button
  static showInfoDialog(BuildContext context, String message,
      {VoidCallback? onPressed,
      bool isCancelable = true,
      String? buttonName}) async {
    String btnText = buttonName ?? Strings.OK;
    String title = AppConstants.APP_NAME;

    Widget alert = WillPopScope(
        onWillPop: () async {
          return isCancelable;
        },
        child: CupertinoAlertDialog(
          title: Text(title),
          content: Text(message),
          actions: [
            CupertinoDialogAction(
                onPressed: onPressed ??
                    () {
                      Get.back();
                    },
                child: Text(btnText)),
          ],
        ));

    showDialog(
      context: context,
      barrierDismissible: isCancelable,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  /// Show dialogs with three option buttons
  static showDialogWithTwoOptions(
      BuildContext context, String message, String positiveButtonText,
      {VoidCallback? positiveButtonCallBack,
      VoidCallback? negativeButtonCallBack,
        String? negativeButtonText,
      bool isCancelable = true}) async {
    String btnText = negativeButtonText ?? Strings.CANCEL;
    String title = AppConstants.APP_NAME;

    CupertinoAlertDialog alert = CupertinoAlertDialog(
      title: Text(title),
      content: Text(message),
      actions: [
        CupertinoDialogAction(
            onPressed: positiveButtonCallBack, child: Text(positiveButtonText)),
        CupertinoDialogAction(
            onPressed: negativeButtonCallBack ??
                () {
                  Get.back();
                },
            child: Text(btnText)),
      ],
    );

    showDialog(
      context: context,
      barrierDismissible: isCancelable,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  /// Show dialogs with two option buttons
  static showDialogWithTwoOptionsAndClicks(BuildContext context, String message,
      String positiveButtonText, String negativeButtonText,
      {VoidCallback? positiveButtonCallBack,
      VoidCallback? negativeButtonCallBack,
      bool isCancelable = true}) async {
    String title = AppConstants.APP_NAME;

    CupertinoAlertDialog alert = CupertinoAlertDialog(
      title: Text(title),
      content: Text(message),
      actions: [
        CupertinoDialogAction(
            onPressed: positiveButtonCallBack, child: Text(positiveButtonText)),
        CupertinoDialogAction(
            onPressed: negativeButtonCallBack, child: Text(negativeButtonText)),
      ],
    );

    showDialog(
      context: context,
      barrierDismissible: isCancelable,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
}
