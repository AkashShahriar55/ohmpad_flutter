

import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:get/get.dart';

class BluetoothController extends GetxController{


  // handle bluetooth on & off
// note: for iOS the initial state is typically BluetoothAdapterState.unknown
// note: if you have permissions issues you will get stuck at BluetoothAdapterState.unauthorized
  StreamSubscription<BluetoothAdapterState>? subscription;


  Future<void> _tryToTurnOnBluetooth() async {
    // show an error to the user, etc
    // turn on bluetooth ourself if we can
    // for iOS, the user controls bluetooth enable/disable
    if (Platform.isAndroid) {
      try{
        await FlutterBluePlus.turnOn();
      }catch(e){
        if(e is FlutterBluePlusException){
          showBluetoothDialog();
        }
      }

    }
  }

  Future<void>  showBluetoothDialog() async {
    Get.defaultDialog(
      title: "Bluetooth Required",
      middleText: "Please turn on bluetooth or exit app",
      textConfirm: "Accept",
      confirmTextColor: Colors.white,
      textCancel: "Deny",
      cancelTextColor: Colors.white,
      onConfirm: () async {
        await _tryToTurnOnBluetooth();
        Get.back();
      },
      onCancel: () {
        Get.back(); // Dismiss the dialog
        // Exit the application
        WidgetsBinding.instance.addPostFrameCallback((_) => SystemNavigator.pop());
      },
    );


  }

  @override
  Future<void> onInit() async {
    super.onInit();
    subscription = FlutterBluePlus.adapterState.listen((BluetoothAdapterState state) async {
      print(state);
      if (state == BluetoothAdapterState.on) {
        // usually start scanning, connecting, etc
      } else if(state == BluetoothAdapterState.off || state == BluetoothAdapterState.unknown) {
        await _tryToTurnOnBluetooth();
      }
    });
  }



  @override
  void onClose() {
    super.onClose();
    // cancel to prevent duplicate listeners
    subscription?.cancel();
  }

  @override
  void onReady() {
    print("ready");
    super.onReady();
  }



}