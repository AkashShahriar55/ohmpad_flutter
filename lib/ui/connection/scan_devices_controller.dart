import 'dart:async';
import 'dart:io';
import 'package:app_settings/app_settings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart'
    as serial;

import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:ohm_pad/custom_widget/dialogs.dart';
import 'package:ohm_pad/routes/app_pages.dart';
import 'package:ohm_pad/utils/strings.dart';
import 'package:permission_handler/permission_handler.dart';

enum ScreenStatus { SEARCH_BLE, DEVICE_NOT_FOUND, LIST_OF_BLES }

class ScanDevicesController extends GetxController with WidgetsBindingObserver {
  // channel and events iOS
  MethodChannel _methodChanneliOS = MethodChannel('flutter/ohmPadiOS');
  static const streamScaniOS = EventChannel('com.ohmPadiOS/stream');
  static const streamConnectioniOS =
      EventChannel('com.ohmPadiOS/stream_connect_request');

  // channel and events Android
  MethodChannel _methodChannelAndroid =
      MethodChannel('com.ohmPad/OhmPadChannel');
  static const streamAndroid = const EventChannel('com.ohmPad/stream');
  static const streamConnectAndroid =
      const EventChannel('com.ohmPad/stream_connect_request');

  StreamSubscription? _broadCastSubscription;
  StreamSubscription? _subscriptionConnection;
  FlutterBlue flutterBlue = FlutterBlue.instance;

  //Bluetooth Vars
  serial.BluetoothState _bluetoothState = serial.BluetoothState.UNKNOWN;

  //inner vars
  Rx<ScreenStatus> screenStatus = Rx<ScreenStatus>(ScreenStatus.SEARCH_BLE);
  Rx<bool> isSearchingForBLEs = Rx<bool>(false);
  RxList<dynamic> listBles = RxList<dynamic>([]);
  RxBool isLoading = false.obs;

  static ScanDevicesController get of => Get.find();

  RxBool isBluetoothOn = false.obs;
  RxBool isBluetoothConnected = false.obs;

  searchForTheBLEDevices() {
    screenStatus.value = ScreenStatus.SEARCH_BLE;
    isSearchingForBLEs.value = true;
    isSearchingForBLEs.refresh();
    this.startDiscoveryiOS();

    Future.delayed(Duration(seconds: 5), () {
      this.stopDiscovery();
      // disableListentDeviceStream();
    });
  }

  Future<void> enableBluetooth() async {
    _jumpToSetting();
  }

  _jumpToSetting() {
    AppSettings.openBluetoothSettings();
  }

  void stopDiscovery() {
    try {
      if (Platform.isIOS) {
        _methodChanneliOS.invokeMethod("StopDiscovery");
        // disableListentDeviceStream();
      } else {}
    } on PlatformException catch (e) {
      print("exceptiong");
    }
  }

  checkBluetooth() async {
    print('TAG isAvailable ${await flutterBlue.isAvailable}');
    print('TAG isOn ${await flutterBlue.isOn}');
    if (await flutterBlue.isAvailable && await flutterBlue.isOn) {
      isBluetoothOn.value = true;
    } else {
      isBluetoothOn.value = false;
    }
    isBluetoothOn.refresh();
  }

  void connectToDeviceiOS(String item) {
    disableListentDeviceStream();
    try {
      _methodChanneliOS.invokeMethod("ConnectToDevice", {"uuid": item});
      print("connect to $item");
      enableConnectionStream();
    } on PlatformException catch (e) {
      print("exceptiong");
    }
  }

  void connectToDevice(String item) {
    try {
      _methodChannelAndroid.invokeMethod("ConnectToDevice", {"text": item});
      enableConnectionStream();
    } on PlatformException catch (e) {
      print("exceptiong");
    }
  }

  void enableConnectionStream() {
    hideLoaderAfter10s();
    if (_subscriptionConnection == null) {
      if (Platform.isIOS) {
        _subscriptionConnection =
            streamConnectioniOS.receiveBroadcastStream().listen((timer) {
          navigateToTrackScreen(timer);
        });
      } else {
        _subscriptionConnection =
            streamConnectAndroid.receiveBroadcastStream().listen((timer) {
          navigateToTrackScreen(timer);
        });
      }
    }
  }

  void hideLoaderAfter10s() {
    Timer(Duration(seconds: 10), () {
      if(Get.currentRoute == Routes.SCAN_DEVICES) {
        Dialogs.showInfoDialog(Get.context!, Strings.FAILED_CONNECTION);
      }
      isLoading.value = false;
    });
  }

  void navigateToTrackScreen(timer) {
    print("enableConnectionStream $timer");
    if (timer as bool && timer) {
      isBluetoothConnected.value = true;
      if (_subscriptionConnection != null) {
        _subscriptionConnection?.cancel();
        _subscriptionConnection = null;
      }
      Get.offAndToNamed(Routes.MAIN_PAGE);
    }
  }

  void startDiscoveryiOS() async {
    disableConnectionDeviceStream();
    try {
      if (Platform.isIOS) {
        _methodChanneliOS.invokeMethod("Discovery");
        Future.delayed(
            Duration(seconds: 1), () => enableListentDeviceiOSStream());
      } else {
        if (await checkLocationPermissions()) {
          // isScanRunning.value = true;
          _methodChannelAndroid.invokeMethod("Discovery");
          Future.delayed(
              Duration(seconds: 1), () => enableListenDeviceAndroidStream());
        }
      }
    } on PlatformException catch (e) {
      print("exceptiong");
    }
  }

  void enableListentDeviceiOSStream() {
    if (_broadCastSubscription == null) {
      _broadCastSubscription =
          streamScaniOS.receiveBroadcastStream().listen((data) {
        print("received data :: $data");

        validateData(data);
        // if (isBluetoothConnected.value && isDeviceConnected.value)
        //   getDataFromStorage();
      });
    }
  }

  void enableListenDeviceAndroidStream() async {
    if (_broadCastSubscription == null) {
      _broadCastSubscription =
          streamAndroid.receiveBroadcastStream().listen((data) {
        print("received data :: $data");

        validateData(data);
        // if (isBluetoothConnected.value && isDeviceConnected.value)
        //   getDataFromStorage();
      });
      var result = await _methodChannelAndroid.invokeMethod("CheckConnected", {});
      if(result) {
        navigateToTrackScreen(result);
      }
    }
  }

  void validateData(data) {
    if (data == "Stop Scanning") {
      screenStatus.value = ScreenStatus.LIST_OF_BLES;
      print("Stop discovery");
      this.disableListentDeviceStream();
      this.changesAfterDeviceDetected();
      return;
    }
    List<dynamic> bleArr = data as List<dynamic>;
    if (bleArr.length > 0) {
      listBles.value = bleArr;
      print("listBles.value.length");
      print(listBles.value.length);
      listBles.refresh();
      update();
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    print('state = $state');
    if (state == AppLifecycleState.resumed) {
      checkBluetooth();
    }
  }

  void disableListentDeviceStream() {
    if (_broadCastSubscription != null) {
      try {
        _broadCastSubscription?.cancel();
      } catch (e) {}
      _broadCastSubscription = null;
    }
  }

// _subscriptionConnection
  void disableConnectionDeviceStream() {
    if (_subscriptionConnection != null) {
      try {
        _subscriptionConnection?.cancel();
      } catch (e) {}
      _broadCastSubscription = null;
    }
  }

  changesAfterDeviceDetected() {
    if (listBles.length > 0) {
      screenStatus.value = ScreenStatus.LIST_OF_BLES;
    } else {
      screenStatus.value = ScreenStatus.DEVICE_NOT_FOUND;
    }
    screenStatus.refresh();
    print("LIST :: ${listBles.value.length}");
    update();
  }

  Future<bool> checkLocationPermissions() async {
    var locGranted = await Permission.location.isGranted;
    if (locGranted == false) {
      final status = await Permission.location.request();
      locGranted = status.isGranted;
      if (PermissionStatus.permanentlyDenied == status) {
        Dialogs.showInfoDialog(Get.context!, Strings.LOCATION_PERMISSION_MSG);
      }
    }
    print("is granted $locGranted");
    return locGranted;
  }

  rescanTapped() async {
    if(Platform.isAndroid) {
      bool result =
          await _methodChannelAndroid.invokeMethod("CheckConnected", {});
      if (result) {
        navigateToTrackScreen(result);
      }
    }
    searchForTheBLEDevices();
  }

  @override
  void onInit() {
    // TODO: implement onInit
    checkBluetooth();
    WidgetsBinding.instance!.addObserver(this);
    super.onInit();
  }

  @override
  void onClose() {
    WidgetsBinding.instance!.removeObserver(this);
    super.onClose();
  }
}
