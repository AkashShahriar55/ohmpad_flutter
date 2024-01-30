import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_mailer/flutter_mailer.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:ohm_pad/data/preferences/preference_manager.dart';
import 'package:ohm_pad/routes/app_pages.dart';
import 'package:ohm_pad/utils/constants/color_constants.dart';
import 'package:ohm_pad/utils/constants/icon_constants.dart';
import 'package:ohm_pad/utils/size_utils.dart';
import 'package:ohm_pad/utils/strings.dart';
import 'package:url_launcher/url_launcher.dart';

import 'dialogs.dart';

class BottomSheetDrawer extends StatelessWidget {
  bool isConnected;

  BottomSheetDrawer({Key? key, this.isConnected = false}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      // height: SizeUtils.get(320),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      // child: Text("dfss\ndfsf\ndfsf\ndfsf\ndfsf"),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          buildGrabHandle(),
          buildList(),
        ],
      ),
    );
  }

  logoutAction() {
    Dialogs.showDialogWithTwoOptions(
        Get.context!, Strings.LOGOUT_MSG, Strings.YES,
        positiveButtonCallBack: () async {
      bool getOnboarding =
          await PreferenceManager.instance.getOnBoardingShown();
      bool getHowtoUser = await PreferenceManager.instance.showHowToUse();
      Get.back();
      PreferenceManager.instance.clearAll();
      FirebaseAuth.instance.signOut();
      PreferenceManager.instance.setOnBoardingShown(getOnboarding);
      PreferenceManager.instance.setShowHowToUse(getHowtoUser);
      Get.offNamedUntil(Routes.LOGIN, (route) => false);
    }, negativeButtonText: Strings.NO);
  }

  aboutUsAction() {
    navigateToRoute(Routes.CMS_SCREEN);
  }

  void navigateToRoute(String route) {
    Get.back();
    if (Get.currentRoute == Routes.SCAN_DEVICES ||
        Get.currentRoute == Routes.MAIN_PAGE) {
      Get.toNamed(route, arguments: isConnected);
    } else {
      Get.offAndToNamed(route, arguments: isConnected);
    }
  }

  _launchURL(String toMailId) async {
    var url = 'mailto:$toMailId';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  contactUsAction() {
    _launchURL('support@ohmpad.com');
    // send(Get.context!);
  }

  Future<void> send(BuildContext context) async {
    if (Platform.isIOS) {
      final bool canSend = await FlutterMailer.canSendMail();
      if (!canSend) {
        const SnackBar snackbar =
            const SnackBar(content: Text('no Email App Available'));
        ScaffoldMessenger.of(context).showSnackBar(snackbar);
        return;
      }
    }

    // Platform messages may fail, so we use a try/catch PlatformException.

    final MailOptions mailOptions = MailOptions(
      body: "",
      subject: "OhmPad App Support",
      recipients: <String>['support@ohmpad.com'],
      isHTML: true,
      // bccRecipients: ['other@example.com'],
      // ccRecipients: <String>['third@example.com'],
    );

    String platformResponse;

    try {
      final MailerResponse response = await FlutterMailer.send(mailOptions);
      switch (response) {
        case MailerResponse.saved:
          platformResponse = 'mail was saved to draft';
          break;
        case MailerResponse.sent:
          platformResponse = 'mail was sent';
          break;
        case MailerResponse.cancelled:
          platformResponse = 'mail was cancelled';
          break;
        case MailerResponse.android:
          platformResponse = 'intent was success';
          break;
        default:
          platformResponse = 'unknown';
          break;
      }
    } on PlatformException catch (error) {
      platformResponse = error.toString();
      print(error);

      await showDialog<void>(
        context: context,
        builder: (BuildContext context) => AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
          content: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text(
                'Message',
                style: Theme.of(context).textTheme.subtitle1,
              ),
              Text(error.message ?? 'unknown error'),
            ],
          ),
          contentPadding: const EdgeInsets.all(26),
          title: Text(error.code),
        ),
      );
    } catch (error) {
      platformResponse = error.toString();
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(platformResponse),
    ));
  }

  accountAction() {
    navigateToRoute(Routes.ACCOUNT_SCREEN);
  }

  homeAction() {
    Get.back();
    if (Get.currentRoute != Routes.SCAN_DEVICES &&
        Get.currentRoute != Routes.MAIN_PAGE) {
      print('Getting back');
      Get.back();
    }
    // navigateToRoute(Routes.MAIN_PAGE);
  }

  Function() actionBasedOnIndex(int ind) {
    switch (ind) {
      case 0:
        return homeAction;
      case 1:
        return accountAction;
      case 2:
        return aboutUsAction;
      case 3:
        return contactUsAction;
      case 4:
        return logoutAction;
      default:
        return logoutAction;
    }
  }

  buildList() {
    var iconArr = [
      IconConstants.HOME_ICON,
      IconConstants.USER_ICON,
      IconConstants.ABOUT_US_ICON,
      IconConstants.CONTACT_US_ICON,
      IconConstants.LOGOUT_ICON
    ];
    var nameArr = [
      Strings.MENU_HOME,
      Strings.MENU_ACCOUNT,
      Strings.MENU_ABOUTUS,
      Strings.MENU_CONTACTUS,
      Strings.MENU_LOGOUT
    ];

    return ListView.builder(
      itemBuilder: (context, index) {
        // if (isConnected) {
        return buildItem(
            iconArr[index], nameArr[index], actionBasedOnIndex(index));
        // } else {
        //   return nameArr[index] == Strings.MENU_HOME
        //       ? Container()
        //       : buildItem(
        //           iconArr[index], nameArr[index], actionBasedOnIndex(index));
        // }
      },
      itemCount: 5,
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(), //Optional
    );
  }

  buildItem(String itemImage, String itemName, Function() action) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: action,
      child: Container(
        padding: EdgeInsets.only(
            left: SizeUtils.get(30),
            right: SizeUtils.get(16),
            bottom: SizeUtils.get(16),
            top: SizeUtils.get(16)),
        // height: SizeUtils.get(50),
        child: Row(
          children: [
            SvgPicture.asset(
              itemImage,
              color: ColorConstants.PRIMARY_COLOR,
            ),
            SizedBox(
              width: 16,
            ),
            Text(
              itemName,
              style: Get.theme!.textTheme.subtitle2!.copyWith(
                  color: ColorConstants.SECONDARY_COLOR,
                  fontSize: 20,
                  fontWeight: FontWeight.bold),
            ),
            Spacer(),
            Icon(
              Icons.chevron_right,
              color: ColorConstants.SECONDARY_COLOR,
            )
          ],
        ),
      ),
    );
  }

  buildGrabHandle() {
    return Container(
      height: 30,
      child: Center(
        child: Container(
          height: 5,
          width: 40,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.all(
                Radius.circular(2.5),
              ),
              color: Colors.grey),
        ),
      ),
    );
  }
}
