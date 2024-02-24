import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:ohm_pad/ui/splash/splash_controller.dart';
import 'package:ohm_pad/utils/constants/icon_constants.dart';
import 'package:ohm_pad/utils/size_utils.dart';



class SplashScreen extends StatelessWidget with WidgetsBindingObserver {

  SplashController _splashController = Get.find();

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(statusBarColor: Colors.transparent));
    return Scaffold(
      body: Container(
        width: Get.width,
        height: Get.height,
        child: Stack(
          fit: StackFit.expand,
          children: [

            Image.asset(IconConstants.SPLASH_BG,fit: BoxFit.cover),
            Column(

              children: [
                Spacer(),
                Padding(
                  padding: EdgeInsets.only(bottom: MediaQuery.of(context).size.height/2),
                  child: Image.asset(IconConstants.LOGO,width: SizeUtils.get(200),height: SizeUtils.get(200),),
                ),
                Spacer(),
              ],
            ),
            // Center(
            //   child:
            // )
          ],
        ),
      ),
    );
  }










}
