import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ohm_pad/app_theme/button_theme.dart';
import 'package:ohm_pad/custom_widget/RoundedGradientButton.dart';
import 'package:ohm_pad/custom_widget/progress_view.dart';
import 'package:ohm_pad/routes/app_pages.dart';
import 'package:ohm_pad/utils/constants/color_constants.dart';
import 'package:ohm_pad/utils/constants/icon_constants.dart';
import 'package:ohm_pad/utils/constants/image_constants.dart';
import 'package:ohm_pad/utils/size_utils.dart';
import 'package:ohm_pad/utils/strings.dart';

class ClosingScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: SizeUtils.screenWidth,
        child: closingBody(),
      ),
    );
  }

  closingBody() {
    return Stack(fit: StackFit.expand, children: [
      Image.asset(ImageConstants.THANKYOU_BG, fit: BoxFit.fill),
      Padding(
        padding: EdgeInsets.all(SizeUtils.get(40)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(IconConstants.LOGO,
                height: SizeUtils.get(145), width: SizeUtils.get(145)),
            SizedBox(height: SizeUtils.get(28)),
            Text(Strings.CLOSING_SCREEN_MSG,
                style: Get.context!.textTheme.headline5!
                    .copyWith(color: Colors.white),
                textAlign: TextAlign.center),
            SizedBox(height: SizeUtils.get(28)),
            RoundedGradientButton(
              buttonText: "Back to Home",
              width: SizeUtils.screenWidth!,
              onpressed: () {
                Get.back();
              },
            )
          ],
        ),
      )
    ]);
  }
}
