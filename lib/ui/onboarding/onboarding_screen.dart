import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ohm_pad/custom_widget/src/introduction_screen.dart';
import 'package:ohm_pad/custom_widget/src/model/page_decoration.dart';
import 'package:ohm_pad/custom_widget/src/model/page_view_model.dart';
import 'package:ohm_pad/data/preferences/preference_manager.dart';
import 'package:ohm_pad/routes/app_pages.dart';
import 'package:ohm_pad/utils/constants/color_constants.dart';
import 'package:ohm_pad/utils/constants/font_constants.dart';
import 'package:ohm_pad/utils/constants/image_constants.dart';

class OnBoardingScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    TextStyle bodyStyle = Get.theme!.textTheme.subtitle2!.copyWith(
        color: ColorConstants.SECONDARY_COLOR,
        fontFamily: FontConstants.gauntlet,
        fontSize: 18.0);
    List<PageViewModel> listPagesViewModel = [
      PageViewModel(
        title: "",
        body:
            "Take a moment for yourself and relieve stress, block distractions, and go deeper with curated content & immersive sound",
        image: Image.asset(
          ImageConstants.ONBOARDING_1,
          fit: BoxFit.cover,
        ),
        decoration: PageDecoration(
            titleTextStyle: TextStyle(color: ColorConstants.SECONDARY_COLOR),
            // FontConstants.philosopher
            bodyTextStyle: bodyStyle
            //TextStyle(fontSize: 16.0, color: ColorConstants.SECONDARY_COLOR),
            ),
      ),
      PageViewModel(
        title: "Title of first page",
        body: "Soothing waves of vibration roll up and down the body",
        image: Image.asset(
          ImageConstants.ONBOARDING_2,
          fit: BoxFit.cover,
        ),
        decoration: PageDecoration(
            titleTextStyle: TextStyle(color: ColorConstants.SECONDARY_COLOR),
            bodyTextStyle: bodyStyle),
      ),
      PageViewModel(
        title: "Title of first page",
        body: "Portable--easy to fold, clean and store",
        image: Image.asset(
          ImageConstants.ONBOARDING_3,
          fit: BoxFit.cover,
        ),
        decoration: PageDecoration(
          titleTextStyle: TextStyle(color: ColorConstants.SECONDARY_COLOR),
          bodyTextStyle: bodyStyle,
        ),
      ),
      PageViewModel(
        title: "Title of first page",
        body:
            "Reinvigorate or transcend your existing yoga or meditation practice",
        image: Image.asset(
          ImageConstants.ONBOARDING_4,
          fit: BoxFit.cover,
        ),
        decoration: PageDecoration(
          titleTextStyle: TextStyle(color: ColorConstants.SECONDARY_COLOR),
          bodyTextStyle: bodyStyle,
        ),
      )
    ];
    return Scaffold(
      body: SafeArea(
        child: IntroductionScreen(
          dotsDecorator: DotsDecorator(
            size: const Size.square(10.0),
            activeSize: const Size(20.0, 10.0),
            activeColor: ColorConstants.SECONDARY_COLOR,
            color: Colors.black26,
            spacing: const EdgeInsets.symmetric(horizontal: 3.0),
            activeShape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(25.0)),
          ),
          pages: listPagesViewModel,
          // done: Padding(
          //   padding: EdgeInsets.only(right: 16),
          //   child: Text("Done",
          //       style: Get.theme!.textTheme.subtitle1!.copyWith(
          //           color: ColorConstants.SECONDARY_COLOR,
          //           fontWeight: FontWeight.bold,
          //           fontSize: 16.0)),
          // ),
          onDone: () async {
            skipDoneAction();
            // When done button is press
          },
          showSkipButton: true,
          // skip: Padding(
          //   padding: EdgeInsets.only(right: 16),
          //   child: Text(
          //     "Skip",
          //     style: Get.theme!.textTheme.subtitle1!.copyWith(
          //         color: ColorConstants.SECONDARY_COLOR,
          //         fontWeight: FontWeight.bold,
          //         fontSize: 16.0),
          //   ),
          // ),
          onSkip: () async {
            skipDoneAction();
          },
        ),
      ),
    );
  }

  skipDoneAction() async {
    PreferenceManager.instance.setOnBoardingShown(true);
    if (await PreferenceManager.instance.getIsLogin()) {
      if (await PreferenceManager.instance.showHowToUse())
        Get.toNamed(Routes.HOW_TO_USE);
      else
        Get.offAndToNamed(Routes.SCAN_DEVICES);
    } else {
      Get.offAndToNamed(Routes.LOGIN);
    }
  }
}
