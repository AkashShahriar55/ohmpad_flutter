import 'dart:io';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ohm_pad/custom_widget/bottom_sheet_drawer.dart';
import 'package:ohm_pad/custom_widget/dialogs.dart';
import 'package:ohm_pad/data/network/network_check.dart';
import 'package:ohm_pad/routes/app_pages.dart';
import 'package:ohm_pad/utils/size_utils.dart';
import 'package:url_launcher/url_launcher.dart';

import 'strings.dart';


class CommonUtils {
  static bool isAndroidPlatform() {
    return Platform.isAndroid ? true : false;
  }

  static closeKeyboard(context) {
    FocusScope.of(context).requestFocus(FocusNode());
  }

  static String formatBytes(int bytes, int decimals) {
    if (bytes <= 0) return "0 B";
    const suffixes = ["B", "KB", "MB", "GB", "TB", "PB", "EB", "ZB", "YB"];
    var i = (log(bytes) / log(1024)).floor();
    return ((bytes / pow(1024, i)).toStringAsFixed(decimals)) +
        ' ' +
        suffixes[i];
  }

  static void printWrapped(String text) {
    final pattern = new RegExp('.{1,800}'); // 800 is the size of each chunk
    pattern.allMatches(text).forEach((match) => print(match.group(0)));
  }

  static BoxDecoration commDecoration() {
    return BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(SizeUtils.get(8)),
      boxShadow: [
        BoxShadow(
          color: Colors.grey,
          offset: Offset(0.5, 0.5),
          blurRadius: 0.0,
        )
      ],
    );
  }

  static Future<void> openMail(String mail) async {
    if (await canLaunch(mail)) {
      print("Enter mail");
      await launch(mail);
      print("Finish mail");
    } else {
      print("Not enter mail");
      throw 'Could not launch $mail';
    }
  }

  static Future<void> makePhoneCall(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  static Offset getOffset() {
    return SizeUtils.isTablet!
        ? Offset(0, SizeUtils.get(45))
        : GetPlatform.isIOS
            ? Offset(0, SizeUtils.get(20))
            : Offset(0, SizeUtils.get(35));
  }

  static String roundWithTwoDigit(String value){
    if(value.toLowerCase() == "null" || value.trim().isEmpty){
      return "-";
    }
    return double.parse(value).toStringAsFixed(2);
  }

  static Future<bool> checkInternetConnection() async{
    NetworkCheck networkCheck = new NetworkCheck();
    final bool isConnect = await networkCheck.check();
    return isConnect;
  }
  static void showBottomSheet({bleConnected = false}) {

    showModalBottomSheet<void>(
      context: Get.context!,
      backgroundColor: Colors.transparent,
      enableDrag: true,
      routeSettings: RouteSettings(name: Routes.MAIN_PAGE),
      useRootNavigator: true,
      // barrierColor: Colors.green,
      builder: (BuildContext context) {

        return BottomSheetDrawer(isConnected: bleConnected);
      },
    );

  }
}