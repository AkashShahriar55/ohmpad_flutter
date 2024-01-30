import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ohm_pad/ui/connection/scan_devices_controller.dart';
import 'package:ohm_pad/utils/common_utils.dart';
import 'package:ohm_pad/utils/constants/color_constants.dart';
import 'package:ohm_pad/utils/constants/font_constants.dart';
import 'package:ohm_pad/utils/constants/image_constants.dart';
import 'package:ohm_pad/utils/size_utils.dart';
import 'package:ohm_pad/utils/strings.dart';

class CMSPage extends StatelessWidget {
  const CMSPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        leading: IconButton(
          icon: Padding(
            padding: EdgeInsets.only(left: 8, right: 8),
            child: Icon(
              Icons.menu,
              color: ColorConstants.SECONDARY_COLOR,
              size: 46,
            ),
          ),
          onPressed: () {
            CommonUtils.showBottomSheet(bleConnected: Get.arguments);
          },
        ),
        elevation: 0,
        backgroundColor: Colors.transparent,
        title: Container(
          height: 30,
          child: Image.asset(ImageConstants.TITLE_LOGO),
        ),
      ),
      body: buildBody()
    );
  }
  buildBody(){
    return Center(
      child: Column(
        // mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(height: SizeUtils.get(20),),
          Text(
            "About Us",
            style: Get.context!.textTheme.subtitle1!.copyWith(
                color: ColorConstants.SECONDARY_COLOR,
                fontSize: SizeUtils.get(30),
                fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,

          ),
          SizedBox(height: SizeUtils.get(20),),
          Padding(
            padding: EdgeInsets.all(20.0),
            child: Text(
              Strings.ABOUT_US_CONTENT,
              style: Get.context!.textTheme.subtitle1!.copyWith(
                  color: ColorConstants.ABOUT_TEXT_COLOR,
                  fontSize: SizeUtils.get(16),
                  fontFamily: FontConstants.gauntlet,
                  fontWeight: FontWeight.bold),
              textAlign: TextAlign.left,

            ),
          )
        ],
      ),
    );
  }
}
