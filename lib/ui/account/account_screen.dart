import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:ohm_pad/custom_widget/RoundedGradientButton.dart';
import 'package:ohm_pad/routes/app_pages.dart';
import 'package:ohm_pad/ui/account/account_controller.dart';
import 'package:ohm_pad/ui/connection/scan_devices_controller.dart';
import 'package:ohm_pad/utils/common_utils.dart';
import 'package:ohm_pad/utils/constants/color_constants.dart';
import 'package:ohm_pad/utils/constants/font_constants.dart';
import 'package:ohm_pad/utils/constants/icon_constants.dart';
import 'package:ohm_pad/utils/constants/image_constants.dart';
import 'package:ohm_pad/utils/size_utils.dart';

class AccountScreen extends StatelessWidget {
  AccountScreen({Key? key}) : super(key: key);
  bool isConnected = Get.arguments;

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
            CommonUtils.showBottomSheet(bleConnected: isConnected);
          },
        ),
        elevation: 0,
        backgroundColor: Colors.transparent,
        title: Container(
          height: 30,
          child: Image.asset(ImageConstants.TITLE_LOGO),
        ),
      ),
      body: buildBody(),
    );
  }

  buildBody() {
    return SingleChildScrollView(
      child: Center(
        child: GetX<AccountController>(builder: (_) {
          String displayText = "";
          if (_.userInfo.value.first_name!.length > 0) {
            displayText = _.userInfo.value.first_name![0].toUpperCase() +
                " " +
                _.userInfo.value.last_name![0].toUpperCase();
          }
          return Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(
                height: SizeUtils.get(40),
              ),
              buildProfileName(displayText),
              SizedBox(
                height: SizeUtils.get(10),
              ),
              buildName(_.userInfo.value.first_name! +
                  " " +
                  _.userInfo.value.last_name!),
              SizedBox(
                height: SizeUtils.get(40),
              ),
              buildTile(
                  "Name",
                  _.userInfo.value.first_name! +
                      " " +
                      _.userInfo.value.last_name!),
              buildTile("Email Address", _.userInfo.value.email!),
              buildTile("Mobile Number", _.userInfo.value.mobile_no!),
              buildSeparator(),
              buildSecondaryTile(
                  "Change Password", Routes.CHANGE_PASSWORD_SCREEN, _),
              buildSecondaryTile("Edit Profile", Routes.EDIT_PROFILE, _)
            ],
          );
        }),
      ),
    );
  }

  SvgPicture imageForName(String name) {
    String imageName = "";
    switch (name) {
      case "Name":
        imageName = IconConstants.PROFILE_NAME;

        break;
      case "Email Address":
        imageName = IconConstants.PROFILE_EMAIL;
        break;
      case "Mobile Number":
        imageName = IconConstants.PROFILE_MOBILE;
        break;
      case "Change password":
        imageName = IconConstants.PROFILE_PASSWORD;

        break;
      case "Edit Profile":
        imageName = IconConstants.PROFILE_EDIT;
        break;
    }
    return SvgPicture.asset(
      imageName,
    );
  }

  Widget imageForPNG(String name) {
    String imageName = "";
    switch (name) {
      case "Name":
        imageName = IconConstants.PROFILE_NAME;

        break;
      case "Email Address":
        imageName = IconConstants.PROFILE_EMAIL;
        break;
      case "Mobile Number":
        imageName = IconConstants.PROFILE_MOBILE;
        break;
      case "Change Password":
        imageName = IconConstants.ICN_PSWD;

        break;
      case "Edit Profile":
        imageName = IconConstants.ICN_EDIT;
        break;
    }
    return Image.asset(imageName,
        height: SizeUtils.get(22), width: SizeUtils.get(22));
  }

  buildProfileName(String initials) {
    return RoundedGradientButton(
        buttonText: initials,
        width: SizeUtils.get(100),
        height: SizeUtils.get(100),
        isAcc: true,
        onpressed: () {});
  }

  buildName(String displayName) {
    return Text(
      displayName,
      textAlign: TextAlign.center,
      style: Get.theme!.textTheme.subtitle2!.copyWith(
          color: ColorConstants.SECONDARY_COLOR,
          fontWeight: FontWeight.bold,
          fontSize: 22),
    );
  }

  buildTile(String name, String info) {
    return Padding(
      padding: EdgeInsets.only(
          left: SizeUtils.get(16),
          right: SizeUtils.get(16),
          top: SizeUtils.get(8),
          bottom: SizeUtils.get(8)),
      child: Container(
        width: MediaQuery.of(Get.context!).size.width,
        clipBehavior: Clip.hardEdge,
        decoration: BoxDecoration(
            color: ColorConstants.THEME_PINK_COLOR.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12.0)),
        padding: EdgeInsets.all(16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: Get.theme!.textTheme.subtitle2!.copyWith(
                        color: ColorConstants.BLACK_COLOR,
                        fontFamily: FontConstants.gauntlet,
                        fontWeight: FontWeight.w300,
                        fontSize: 16),
                  ),
                  SizedBox(height: SizeUtils.get(8)),
                  Text(
                    info,
                    style: Get.theme!.textTheme.subtitle2!.copyWith(
                        color: ColorConstants.THEME_PINK_COLOR,
                        fontWeight: FontWeight.bold,
                        fontSize: 18),
                  )
                ],
              ),
            ),
            imageForName(name)
          ],
        ),
      ),
    );
  }

  buildSecondaryTile(
      String name, String routeName, AccountController accountController) {
    return Padding(
      padding: EdgeInsets.only(
          left: SizeUtils.get(16),
          right: SizeUtils.get(16),
          top: SizeUtils.get(8),
          bottom: SizeUtils.get(8)),
      child: InkWell(
        onTap: () async {
          await Get.toNamed(routeName);
          accountController.getUSer();
        },
        child: Container(
          width: MediaQuery.of(Get.context!).size.width,
          clipBehavior: Clip.hardEdge,
          decoration: BoxDecoration(
              color: ColorConstants.THEME_PINK_COLOR.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12.0)),
          padding: EdgeInsets.all(16),
          child: Row(
            children: [
              imageForPNG(name),
              SizedBox(width: 8),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: Get.theme!.textTheme.subtitle2!.copyWith(
                        color: ColorConstants.THEME_PINK_COLOR,
                        fontWeight: FontWeight.bold,
                        fontSize: 18),
                  ),
                ],
              ),
              Spacer(),
              Icon(
                Icons.chevron_right,
                color: ColorConstants.LIGHT_GREY.withOpacity(0.5),
              )
            ],
          ),
        ),
      ),
    );
  }

  buildSeparator() {
    return Container(
      width: MediaQuery.of(Get.context!).size.width,
      padding: EdgeInsets.all(SizeUtils.get(16)),
      child: Container(
        color: ColorConstants.LIGHT_GREY.withOpacity(0.2),
        height: 1,
      ),
    );
  }
}
