import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:get/get.dart';
import 'package:ohm_pad/data/preferences/preference_manager.dart';
import 'dart:async';

import 'package:ohm_pad/routes/app_pages.dart';
import 'package:permission_handler/permission_handler.dart';

class SplashController extends GetxController {

  @override
  Future<void> onInit() async {
    super.onInit();
    checkPermissionAndNavigate();
  }


  Future<void> checkPermissionAndNavigate() async {
    if( await _checkPermission() ){
      goToNext();
    }else{
      await showPermissionDialog();
    }
  }



  Future<bool> _checkPermission() async {
    Map<Permission, PermissionStatus> statuses = await [
    Permission.bluetoothAdvertise, Permission.bluetoothConnect, Permission.bluetoothScan
    ].request();

    print( statuses[Permission.bluetoothAdvertise]);
    print( statuses[Permission.bluetoothConnect]);
    print( statuses[Permission.bluetoothScan]);

    return statuses[Permission.bluetoothAdvertise]?.isGranted == true &&
        statuses[Permission.bluetoothConnect]?.isGranted == true &&
        statuses[Permission.bluetoothScan]?.isGranted == true;
  }


  Future<void>  showPermissionDialog() async {
     Get.defaultDialog(
      title: "Permission Required",
      middleText: "Please grant nearby devices permission to continue.",
      textConfirm: "Open Settings",
      confirmTextColor: Colors.white,
      textCancel: "Exit",
      cancelTextColor: Colors.white,
      onConfirm: () async {
        await openAppSettings();
        Get.back();
        checkPermissionAndNavigate();
      },
      onCancel: () {
        Get.back(); // Dismiss the dialog
        // Exit the application
        WidgetsBinding.instance.addPostFrameCallback((_) => SystemNavigator.pop());
      },
    );


  }


  @override
  void onClose() {
    super.onClose();
  }

  @override
  void onReady() {
    print("ready");
    super.onReady();
  }




  goToNext() async
  {
    bool onBoardingTag = await PreferenceManager.instance.getOnBoardingShown();
    bool showHowToUse = await PreferenceManager.instance.showHowToUse();
    print("onBoardingTag");
    print(onBoardingTag);
    if (onBoardingTag) {
      //login or howto use
      if (await PreferenceManager.instance.getIsLogin())
        // Get.offAndToNamed(Routes.SCAN_DEVICES);
        if (showHowToUse) {
          Get.offAndToNamed(Routes.HOW_TO_USE);
        }else{
          Get.offAndToNamed(Routes.SCAN_DEVICES);
        }

      else
        Get.offAndToNamed(Routes.LOGIN);
    }else{
      Get.offAndToNamed(Routes.ON_BOARDING);
    }


  }

}