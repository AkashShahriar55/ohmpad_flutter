import 'dart:async';
import 'dart:convert';

import 'package:ohm_pad/model/login_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'preference_constants.dart';

class PreferenceManager {
  //Singleton instance
  PreferenceManager._internal();

  static PreferenceManager instance = new PreferenceManager._internal();
  static SharedPreferences? _prefs;

  factory PreferenceManager() {
    return instance;
  }

  Future<void> clearAll() async {
    if (_prefs == null) _prefs = await SharedPreferences.getInstance();
    _prefs!.clear();
  }

  /// ------------------( IS LOGIN )------------------
  Future<bool> getIsLogin() async {
    if (_prefs == null) _prefs = await SharedPreferences.getInstance();

    return _prefs!.getBool(PreferenceConstants.IS_LOGIN) ?? false;
  }

  Future<void> setIsLogin(bool isLogin) async {
    if (_prefs == null) _prefs = await SharedPreferences.getInstance();
    _prefs!.setBool(PreferenceConstants.IS_LOGIN, isLogin);
  }



  ///AUTH TOKEN
  Future<String> getAuthToken() async {
    if (_prefs == null) _prefs = await SharedPreferences.getInstance();

    return _prefs!.getString(PreferenceConstants.AUTH_TOKEN) ?? "";
  }

  Future<void> setAuthToken(String authToken) async {
    if (_prefs == null) _prefs = await SharedPreferences.getInstance();
    _prefs!.setString(PreferenceConstants.AUTH_TOKEN, authToken);
  }
  

  ///Device TOKEN
  Future<String> getDeviceToken() async {
    if (_prefs == null) _prefs = await SharedPreferences.getInstance();
    return _prefs!.getString(PreferenceConstants.DEVICE_TOKEN) ?? "";
  }

  Future<void> setDeviceToken(String authToken) async {
    if (_prefs == null) _prefs = await SharedPreferences.getInstance();
    _prefs!.setString(PreferenceConstants.DEVICE_TOKEN, authToken);
  }

  Future<void> setLoginInfo(Map<String, dynamic> map) async{
    if (_prefs == null) _prefs = await SharedPreferences.getInstance();
    final strLoginInfo = json.encode(map);
    _prefs!.setString(PreferenceConstants.LOGIN_INFO, strLoginInfo);
  }

  Future<LoginData> getLoginInfo() async {
    if (_prefs == null) _prefs = await SharedPreferences.getInstance();
    String strLoginInfo = _prefs!.getString(PreferenceConstants.LOGIN_INFO) ?? "";
    final objLoginInfo = strLoginInfo.isEmpty
        ? null
        : LoginData.fromJson(json.decode(strLoginInfo));
    return objLoginInfo!;
  }


  Future<bool> getOnBoardingShown() async {
    if (_prefs == null) _prefs = await SharedPreferences.getInstance();

    return _prefs!.getBool(PreferenceConstants.ON_BOARDING_SHOWN) ?? false;
  }

  Future<void> setOnBoardingShown(bool shownOnBoarding) async {
    if (_prefs == null) _prefs = await SharedPreferences.getInstance();
    _prefs!.setBool(PreferenceConstants.ON_BOARDING_SHOWN, shownOnBoarding);
  }

  Future<bool> showHowToUse() async {
    if (_prefs == null) _prefs = await SharedPreferences.getInstance();

    return _prefs!.getBool(PreferenceConstants.SHOW_HOW_TO_USE) ?? true;
  }

  Future<void> setShowHowToUse(bool showHowToUse) async {
    if (_prefs == null) _prefs = await SharedPreferences.getInstance();
    _prefs!.setBool(PreferenceConstants.SHOW_HOW_TO_USE, showHowToUse);
  }



}
