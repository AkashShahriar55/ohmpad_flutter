import 'dart:async';
import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:ohm_pad/data/preferences/preference_manager.dart';
import 'package:ohm_pad/utils/constants/color_constants.dart';

Future<void> firebaseMessagingBackgroundHandler(
    RemoteMessage message) async {
  print('TAG onMessage4');
  if(message != null && message.data != null){
    PushNotificationsManager().showNotification(message.data['notification']['title'], message.data['notification']['body']);
  }
}

class PushNotificationsManager {
  PushNotificationsManager._();

  factory PushNotificationsManager() => _instance;

  static final PushNotificationsManager _instance =
      PushNotificationsManager._();

  AndroidNotificationChannel channel = AndroidNotificationChannel(
    'channel', // id
    'High Importance Notifications', // title
    'This channel is used for important notifications.', // description
    importance: Importance.high,
  );

  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      new FlutterLocalNotificationsPlugin();
  bool _initialized = false;

  Future<void> init() async {
    if (!_initialized) {

      String token = (await _firebaseMessaging.getToken())!;
      print("FirebaseMessaging token: $token");

      await PreferenceManager.instance.setDeviceToken(token);

      await flutterLocalNotificationsPlugin
          .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
          ?.createNotificationChannel(channel);

      await FirebaseMessaging.instance
          .setForegroundNotificationPresentationOptions(
        alert: true,
        badge: true,
        sound: true,
      );

      var initializationSettingsAndroid =
          new AndroidInitializationSettings('ic_notification');
      var initializationSettingsIOS = new IOSInitializationSettings();
      var initializationSettings = new InitializationSettings(
          android: initializationSettingsAndroid,
          iOS: initializationSettingsIOS);
      flutterLocalNotificationsPlugin.initialize(initializationSettings);

      handlePushNotification();
      _initialized = true;
    }
  }

  Future<void> retriveToken() async {
    String token = (await _firebaseMessaging.getToken())!;
    print("FirebaseMessaging token: $token");

    await PreferenceManager.instance.setDeviceToken(token);
  }

  void showNotification(String title, String body) {
    _demoNotification(title, body);
  }

  void _demoNotification(String title, String body){
    var androidPlatformChannelSpecifics = AndroidNotificationDetails(
        'channel_ID', 'channel name', 'channel description',
        importance: Importance.max,
        playSound: true,
        color: ColorConstants.APP_THEME_COLOR,
        priority: Priority.high,
        ticker: 'test ticker');

    var iOSChannelSpecifics = IOSNotificationDetails();
    var platformChannelSpecifics = NotificationDetails(
        android: androidPlatformChannelSpecifics, iOS: iOSChannelSpecifics);
    flutterLocalNotificationsPlugin
        .show(0, title, body, platformChannelSpecifics, payload: 'test');
  }

  void handlePushNotification() {


    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print('TAG onMessage2');
      if(message != null && message.notification != null){
        showNotification(message.notification!.title!, message.notification!.body!);
      }
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print('TAG onMessage3');
      if(message != null && message.data != null){
        showNotification(
            message.data['notification']['title'], message.data['notification']['body']);
      }
    });

  }
}

Future myBackgroundMessageHandler(Map<String, dynamic> message) async {
  print("onBackground: $message");
}
