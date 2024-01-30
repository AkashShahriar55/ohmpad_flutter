// import 'package:device_preview/device_preview.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:ohm_pad/ui/others/cms_bindings.dart';

import 'app_theme/app_theme.dart';
import 'notification/push_notification.dart';
import 'routes/app_pages.dart';
import 'utils/constants/app_constants.dart';
import 'utils/constants/color_constants.dart';
import 'utils/size_utils.dart';

Future<void> main() async {
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: ColorConstants.BG_LIGHT_WHITE,
      statusBarIconBrightness: Brightness.dark));
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);
  runApp(
    MyApp()
  );
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  FirebaseAnalytics analytics = FirebaseAnalytics();

  @override
  Widget build(BuildContext context) {
    if (FirebaseAuth.instance.currentUser != null) {
      analytics.setUserId(FirebaseAuth.instance.currentUser!.uid);
      analytics.setUserProperty(name: "UserId", value: FirebaseAuth.instance.currentUser!.uid);
    }

    return LayoutBuilder(builder: (context, constraints) {
      return OrientationBuilder(builder: (context, orientation) {
        SizeUtils.init(constraints, orientation);
        return GestureDetector(
          onTap: () {
            FocusManager.instance.primaryFocus?.unfocus();
          },
          child: GetMaterialApp(
            // locale: DevicePreview.locale(context),
            // builder: DevicePreview.appBuilder,
            debugShowCheckedModeBanner: false,
            title: AppConstants.APP_NAME,
            navigatorObservers: [
              FirebaseAnalyticsObserver(analytics: analytics),
            ],
            theme: MyAppTheme.lightTheme,
            initialRoute: AppPages.INITIAL,
            getPages: AppPages.routes,
          ),
        );
      });
    });
  }
}
