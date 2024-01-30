import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ohm_pad/custom_widget/src/introduction_screen.dart';
import 'package:ohm_pad/custom_widget/src/model/page_decoration.dart';
import 'package:ohm_pad/custom_widget/src/model/page_view_model.dart';
import 'package:ohm_pad/routes/app_pages.dart';
import 'package:ohm_pad/ui/how_to_use/how_to_use_controller.dart';
import 'package:ohm_pad/utils/constants/color_constants.dart';
import 'package:ohm_pad/utils/constants/font_constants.dart';
import 'package:ohm_pad/utils/constants/image_constants.dart';
import 'package:ohm_pad/utils/strings.dart';

class HowToUseScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    TextStyle bodyStyle = Get.theme!.textTheme.subtitle2!.copyWith(
        color: ColorConstants.BLACK_COLOR,
        fontFamily: FontConstants.gauntlet,
        fontSize: 16.0);
    List<PageViewModel> listPagesViewModel = [
      PageViewModel(
        title: "",
        body: Strings.HOW_TO_USE_1,
        image: Image.asset(
          ImageConstants.HOW_TO_USE_1,
          fit: BoxFit.cover,
        ),
        decoration: PageDecoration(
            isHowToUse: true,
            titleTextStyle: TextStyle(color: ColorConstants.SECONDARY_COLOR),
            // FontConstants.philosopher
            bodyTextStyle: bodyStyle
            //TextStyle(fontSize: 16.0, color: ColorConstants.SECONDARY_COLOR),
            ),
      ),
      PageViewModel(
        title: "",
        body: Strings.HOW_TO_USE_2,
        image: Image.asset(
          ImageConstants.HOW_TO_USE_2,
          fit: BoxFit.cover,
        ),
        decoration: PageDecoration(
            isHowToUse: true,
            titleTextStyle: TextStyle(color: ColorConstants.SECONDARY_COLOR),
            bodyTextStyle: bodyStyle),
      ),
      PageViewModel(
        title: "",
        body: Strings.HOW_TO_USE_3,
        image: Image.asset(
          ImageConstants.HOW_TO_USE_3,
          fit: BoxFit.cover,
        ),
        decoration: PageDecoration(
          isHowToUse: true,
          titleTextStyle: TextStyle(color: ColorConstants.SECONDARY_COLOR),
          bodyTextStyle: bodyStyle,
        ),
      ),
      PageViewModel(
        title: "",
        body: Strings.HOW_TO_USE_4,
        image: Image.asset(
          ImageConstants.HOW_TO_USE_4,
          fit: BoxFit.cover,
        ),
        decoration: PageDecoration(
          isHowToUse: true,
          titleTextStyle: TextStyle(color: ColorConstants.SECONDARY_COLOR),
          bodyTextStyle: bodyStyle,
        ),
      ),
      PageViewModel(
        title: "",
        body: Strings.HOW_TO_USE_5,
        image: Image.asset(
          ImageConstants.HOW_TO_USE_5,
          fit: BoxFit.cover,
        ),
        decoration: PageDecoration(
          isHowToUse: true,
          titleTextStyle: TextStyle(color: ColorConstants.SECONDARY_COLOR),
          bodyTextStyle: bodyStyle,
        ),
      )
    ];
    return Scaffold(
        appBar: AppBar(

          elevation: 0,
          backgroundColor: Colors.transparent,
          centerTitle: true,
          title: Text("How to use your OhmPad?",
              style: Get.theme!.textTheme.subtitle2!.copyWith(
                  color: ColorConstants.SECONDARY_COLOR,
                  fontWeight: FontWeight.bold,
                  fontSize: 22)),
        ),
        body: GetX<HowToUseController>(builder: (_) {
          return SafeArea(
            child: Column(
              children: [
                Expanded(child: buildIntroductionScreen(listPagesViewModel, _)),
                _.showDoNotShowOption.value ? buildDoNotShowUI(_) : Container(height: 0,),
              ],
            ),
          );
        }));
  }

  IntroductionScreen buildIntroductionScreen(
      List<PageViewModel> listPagesViewModel, HowToUseController controller) {
    return IntroductionScreen(
      dotsDecorator: DotsDecorator(
        size: const Size.square(10.0),
        activeSize: const Size(20.0, 10.0),
        activeColor: ColorConstants.SECONDARY_COLOR,
        color: Colors.black26,
        spacing: const EdgeInsets.symmetric(horizontal: 3.0),
        activeShape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(25.0)),
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
        // Get.offAndToNamed(Routes.MAIN_PAGE);
        controller.skipDoneAction();
      },
      showSkipButton: true,
      // skip: Padding(
      //   padding: EdgeInsets.only(right: 16),
      //   child: Text("Skip",
      //       style: Get.theme!.textTheme.subtitle1!.copyWith(
      //           color: ColorConstants.SECONDARY_COLOR,
      //           fontWeight: FontWeight.bold,
      //           fontSize: 16.0)),
      // ),
      onSkip: ()
      {
        // Get.offAndToNamed(Routes.SCAN_DEVICES);
        controller.skipDoneAction();
      },
      onChange: (pageNo) {
        controller.changedPage(pageNo);
      },
    );
  }

  buildDoNotShowUI(HowToUseController controller) {
    return Container(
      width: MediaQuery.of(Get.context!).size.width,
      color: ColorConstants.SECONDARY_COLOR.withOpacity(0.7),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        // mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: EdgeInsets.only(bottom: 8),
            child: IconButton(
              onPressed: () {
                controller.clickedDoNotShow.value = !controller.clickedDoNotShow.value;
                controller.clickedDoNotShow.refresh();
              },
              icon: Icon(
                controller.clickedDoNotShow.value ? Icons.check_box : Icons.check_box_outline_blank,
                size: 40,
                color: Colors.white,
              ),
            ),
          ),
          SizedBox(
            width: 8,
          ),
          Text(
            Strings.DONT_SHOW,
            style: Get.theme!.textTheme.subtitle2!.copyWith(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 18),
          ),
        ],
      ),
    );
  }
}
