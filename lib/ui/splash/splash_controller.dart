import 'package:get/get.dart';
import 'package:ohm_pad/data/preferences/preference_manager.dart';
import 'dart:async';

import 'package:ohm_pad/routes/app_pages.dart';

class SplashController extends GetxController{

  @override
  void onInit() {
    super.onInit();
    Timer(Duration(seconds: 3), () => goToNext());
  }

  @override
  void onClose() {
    super.onClose();
  }

  @override
  void onReady() {
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