import 'dart:async';
import 'dart:convert';
import 'dart:io' show Platform;

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
// import 'package:flutter_ble_lib/flutter_ble_lib.dart' as ble_lib;
import 'package:flutter_blue/flutter_blue.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart'
    as serial;
import 'package:get/get.dart';
import 'package:ohm_pad/custom_widget/dialogs.dart';
import 'package:ohm_pad/data/network/network_constants.dart';
import 'package:ohm_pad/data/preferences/preference_manager.dart';
import 'package:ohm_pad/model/music_list_model.dart';
import 'package:ohm_pad/model/music_model.dart';
import 'package:ohm_pad/routes/app_pages.dart';
import 'package:ohm_pad/ui/home/general_player_controller.dart';
import 'package:ohm_pad/utils/common_utils.dart';
import 'package:ohm_pad/utils/strings.dart';
import 'package:path/path.dart' as path;
import 'package:permission_handler/permission_handler.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class HomeController extends GetxController with WidgetsBindingObserver {
  StreamSubscription? _timerSubscription;

  //Method channel
  MethodChannel _methodChanneliOS = MethodChannel('flutter/ohmPadiOS');

  RxBool isLoading = true.obs;
  RxBool isBluetoothConnected = false.obs;
  RxBool isDeviceConnected = false.obs;
  RefreshController refreshController =
      RefreshController(initialRefresh: false);

  serial.BluetoothState _bluetoothState = serial.BluetoothState.UNKNOWN;
  late serial.FlutterBluetoothSerial _bluetooth;

  //Ble
  FlutterBlue flutterBlue = FlutterBlue.instance;
  BluetoothState state = BluetoothState.unknown;
  late StreamSubscription<ScanResult>? scanSubScription;
  RxList<MusicModel> musicList = <MusicModel>[].obs;

  //flutter_ble_lib
  // ble_lib.BleManager bleManager = ble_lib.BleManager();

  static const streamiOS = const EventChannel('com.ohmPadiOS/stream');
  static const stream_connectioniOS =
      const EventChannel('com.ohmPadiOS/stream_connect_request');

  //Event channel
  static const stream =
      const EventChannel('com.test.eventchannelsample/stream');
  static const stream_connection =
      const EventChannel('com.test.eventchannelsample/stream_connect_request');

  StreamSubscription? _subscriptionConnection;

  //Method channel
  MethodChannel _methodChannel = MethodChannel('flutter/MethodChannelDemo');

  RxList<dynamic> listBles = RxList<dynamic>([]);
  RxBool isScanRunning = false.obs;
  var musicRef = FirebaseFirestore.instance.collection(NetworkParams.MUSIC);
  List<MusicListModel> music = [];

  @override
  void onInit() async {
    WidgetsBinding.instance!.addObserver(this);
    super.onInit();
    // if (Platform.isIOS) {
    //   startDiscoveryiOS();
    // } else {
    //   startDiscovery();
    // }

    // _enableTimer();
    // initBluetoothSerial();
    // checkBluetooth();
    // getDataFromStorage(isLoading: true);
    getDataFromFirestore(isLoading: true);
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void onClose() {
    WidgetsBinding.instance!.removeObserver(this);
    // bleManager.destroyClient();
    super.onClose();
  }

  @override
  void onReady() {
    super.onReady();
  }

  refreshData() async {
    getDataFromStorage(isLoading: false);
  }

  void startDiscoveryiOS() {
    if (Platform.isIOS) {
      try {
        isScanRunning.value = true;
        _methodChanneliOS.invokeMethod("Discovery");
        Future.delayed(
            Duration(seconds: 1), () => enableListentDeviceiOSStream());
      } on PlatformException catch (e) {
        print("exceptiong");
      }
    }
  }

  void connectToDeviceiOS(String item) {
    try {
      _methodChanneliOS.invokeMethod("ConnectToDevice", {"uuid": item});
      print("connect to $item");
      enableConnectioniOSStream();
    } on PlatformException catch (e) {
      print("exceptiong");
    }
  }

  void _enableTimer() {
    if (Platform.isIOS) {
      if (_timerSubscription == null) {
        _timerSubscription =
            streamiOS.receiveBroadcastStream().listen(_updateTimer);
      }
    } else {
      _timerSubscription = stream.receiveBroadcastStream().listen(_updateTimer);
    }
  }

  Future<void> getDataFromStorage({bool isLoading = true}) async {
    if (!await CommonUtils.checkInternetConnection()) {
      if (refreshController.isRefresh)
        refreshController.refreshCompleted(resetFooterState: true);
      Dialogs.showInfoDialog(Get.context!, Strings.ERROR_MESSAGE_NETWORK);
      return;
    }

    setLoading(isLoading);

    List<MusicModel> musicList = <MusicModel>[];
    List<String> thumbList = <String>[];

    firebase_storage.ListResult result =
        await firebase_storage.FirebaseStorage.instance.ref().listAll();
    result.prefixes.forEach((firebase_storage.Reference ref) {
      print('Found directory: $ref');
    });

    firebase_storage.ListResult result1 =
        await firebase_storage.FirebaseStorage.instance.ref("Music").listAll();
    final List<firebase_storage.Reference> allFiles = result1.items;

    await Future.forEach<firebase_storage.Reference>(allFiles, (file) async {
      final String fileUrl = await file.getDownloadURL();
      var fileMeta = await file.getMetadata();
      musicList.add(MusicModel(
        name: getName(fileMeta.fullPath),
        url: fileUrl,
      ));
    });

    firebase_storage.ListResult result2 =
        await firebase_storage.FirebaseStorage.instance.ref("Thumb").listAll();
    final List<firebase_storage.Reference> allFiles1 = result2.items;

    await Future.forEach<firebase_storage.Reference>(allFiles1, (file) async {
      final String fileUrl = await file.getDownloadURL();
      thumbList.add(fileUrl);
    });

    for (int i = 0; i < musicList.length; i++) {
      musicList[i].thumbUrl = thumbList[i];
    }

    this.musicList.clear();
    this.musicList.addAll(musicList);

    if (refreshController.isRefresh)
      refreshController.refreshCompleted(resetFooterState: true);

    if (isLoading) setLoading(false);
  }

  Future<void> getDataFromFirestore({bool isLoading = true}) async {
    if (!await CommonUtils.checkInternetConnection()) {
      if (refreshController.isRefresh)
        refreshController.refreshCompleted(resetFooterState: true);
      Dialogs.showInfoDialog(Get.context!, Strings.ERROR_MESSAGE_NETWORK);
      return;
    }
    setLoading(isLoading);
    var querySnapshot = await musicRef.get();
    querySnapshot.docs.forEach((element) {
      var musicModel = MusicListModel.fromJson(element.data());
      if(musicModel.name == 'Guided Introduction') {
        music.insert(0, musicModel);
      } else {
        music.add(musicModel);
      }
    });
    if (isLoading) setLoading(false);
  }

  void _updateTimer(timer) {
    debugPrint("Timer :: $timer");
  }

  openBluetoothSetting() {
    performStartStopAndEnable();
    //Get.toNamed(Routes.PROFILE_SCREEN);
    //AppSettings.openBluetoothSettings();
    isBluetoothConnected.value
        ? isScanRunning.value
            ? stopDiscovery()
            : startDiscovery()
        : false ;
  }

  performStartStopAndEnable() {
    //Get.toNamed(Routes.PROFILE_SCREEN);
    //AppSettings.openBluetoothSettings();
    if (Platform.isIOS) {
      isBluetoothConnected.value
          ? isScanRunning.value
              ? stopDiscovery()
              : startDiscovery()
          : false ;
    } else {
      isBluetoothConnected.value
          ? isScanRunning.value
              ? stopDiscovery()
              : startDiscovery()
          : false ;
    }
  }

  // Request Bluetooth permission from the user
  /*Future<void> enableBluetooth() async {
    // Retrieving the current Bluetooth state
    _bluetoothState = await serial.FlutterBluetoothSerial.instance.state;

    // If the bluetooth is off, then turn it on first
    // and then retrieve the devices that are paired.
    if (_bluetoothState == serial.BluetoothState.STATE_OFF) {
      await serial.FlutterBluetoothSerial.instance.requestEnable();
      await getPairedDevices();
    } else {
      await getPairedDevices();
    }
  }*/

  // For retrieving and storing the paired devices
  // in a list.
  Future<void> getPairedDevices() async {
    //List<BluetoothDevice> devices = [];
    var devices = [];
    // bleManager.enableRadio();

    // To get the list of paired devices
    if (Platform.isAndroid) {
      try {
        devices = await _bluetooth.getBondedDevices();
        print("TAG devices : ${devices.length}");
        isDeviceConnected.value = false;
        devices.forEach((element) {
          if (element.isConnected) {
            isDeviceConnected.value = true;
            print("TAG connected devices : ${element.name}");
          }
        });
      } on PlatformException {
        setLoading(false);
        print("Error");
      }
    } else {
      isDeviceConnected.value = true;
    }

    if (isBluetoothConnected.value && isDeviceConnected.value)
      getDataFromStorage();
    else
      setLoading(false);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    print('state = $state');
    if (state == AppLifecycleState.resumed) {
      checkBluetooth();
    }
  }

  checkBluetooth() async {
    print('TAG isAvailable ${await flutterBlue.isAvailable}');
    print('TAG isOn ${await flutterBlue.isOn}');
    if (await flutterBlue.isAvailable && await flutterBlue.isOn) {
      isBluetoothConnected.value = true;
      // setLoading(false);
      //getPairedDevices();
      print("falseee");
    } else {
      setLoading(false);
      print("trueee");
      isBluetoothConnected.value = false;
    }
  }

  gotoMoodScreen(MusicListModel musicList) {
    if (GeneralPlayerController.of.isPlaying.value) {
      showAlertBeforeStart(musicList);
    } else {
      navigate(musicList);
    }
  }

  void showAlertBeforeStart(MusicListModel musicList) {
    Dialogs.showDialogWithTwoOptions(Get.context!,
        'Are you sure you want to terminate the current session?', 'Yes',
        negativeButtonText: 'No', positiveButtonCallBack: () {
      Get.back();
      navigate(musicList);
      GeneralPlayerController.of.isPlaying.value = false;
    });
  }

  void navigate(MusicListModel musicList) {
    GeneralPlayerController.of.setListeners(musicList);
    final map = {"data": musicList, "isSong": true};
    Get.toNamed(Routes.MOOD_SELECTION_SCREEN, arguments: map);
  }

  setLoading(bool loading) {
    isLoading.value = loading;
  }

  String getName(String fullName) {
    fullName = path.basename(fullName);
    final parts = fullName.split('.');
    return parts[0];
  }

  void initBluetoothSerial() {
    if (Platform.isAndroid) _bluetooth = serial.FlutterBluetoothSerial.instance;

    flutterBlue.state.listen((event) {
      if (event == BluetoothState.on) {
        setLoading(true);
        isBluetoothConnected.value = true;
        Future.delayed(Duration(seconds: 5), () => getPairedDevices());
      } else
        isBluetoothConnected.value = false;
    });
  }

  void callLogOut() {
    Dialogs.showDialogWithTwoOptions(
        Get.context!, Strings.LOGOUT_MSG, Strings.YES,
        positiveButtonCallBack: () {
      Get.back();
      PreferenceManager.instance.clearAll();
      Get.offNamedUntil(Routes.LOGIN, (route) => false);
    }, negativeButtonText: Strings.NO);
  }

  void scanBLE() {
    /*flutterBlue.stopScan().then((value) {
      scanSubScription?.cancel();
      scanSubScription = null;
    });*/

    flutterBlue.isScanning.listen((event) {
      print("TAG isScanning : $event");
      if (!event) {
        scanSubScription = flutterBlue
            .scan(allowDuplicates: false, scanMode: ScanMode.lowLatency)
            .listen((event) {
          print("TAG found device : $event");

          scanSubScription?.cancel();
          scanSubScription = null;
        });
      }
    });
    /*flutterBlue.connectedDevices.asStream().listen((paired) async {
      print('paired device: $paired');
      for (var device in paired) {
        if (device != null) {
          device.services.listen((data) {
            print('HERE $data');
          });
        }}});

    List<BluetoothDevice> connectedDevices = await flutterBlue.connectedDevices;
    flutterBlue.connectedDevices.then((value) {
      print('paired device 1 : $value');
    });*/
  }

  /*----------------*/
  void stopDiscovery() {
    try {
      isScanRunning.value = false;
      if (Platform.isIOS) {
        _methodChanneliOS.invokeMethod("StopDiscovery");
        disableListentDeviceStream();
      } else {
        _methodChannel.invokeMethod("StopDiscovery");
        disableListentDeviceStream();
      }
    } on PlatformException catch (e) {
      print("exceptiong");
    }
  }

  void startDiscovery() async {
    if ((Platform.isAndroid && await checkLocationPermissions())) {
      try {
        isScanRunning.value = true;
        _methodChannel.invokeMethod("Discovery");
        Future.delayed(Duration(seconds: 1), () => enableListentDeviceStream());
      } on PlatformException catch (e) {
        print("exceptiong");
      }
    }
  }

  void enableListentDeviceStream() {
    if (_timerSubscription == null) {
      _timerSubscription = stream.receiveBroadcastStream().listen((timer) {
        debugPrint("Timer $timer");
        if (timer == "Discovery stop") {
          isScanRunning.value = false;
          disableListentDeviceStream();
          return;
        }
        listBles.value.clear();
        listBles.value.addAll(timer as List<dynamic>);
        listBles.refresh();
      });
    }
  }

  void enableConnectionStream() {
    if (_subscriptionConnection == null) {
      _subscriptionConnection =
          stream_connection.receiveBroadcastStream().listen((timer) {
        debugPrint("enableConnectionStream $timer");
        if (timer) {
          //device connected
          disableConnectionStream();
          isDeviceConnected.value = true;

          resetDeviceList();

          if (isBluetoothConnected.value && isDeviceConnected.value)
            getDataFromStorage();
        }
      });
    }
  }

  void enableListentDeviceiOSStream() {
    if (_timerSubscription == null) {
      _timerSubscription = streamiOS.receiveBroadcastStream().listen((timer) {
        debugPrint("Timer $timer");

        if (timer == "Discovery stop") {
          isScanRunning.value = false;
          disableListentDeviceStream();
          return;
        }
        // list.value.clear();
        listBles.value.addAll(timer as List<dynamic>);
        print(listBles.value.length);
        listBles.refresh();
        update();
        if (isBluetoothConnected.value && isDeviceConnected.value)
          getDataFromStorage();
      });
    }
  }

  void enableConnectioniOSStream() {
    if (_subscriptionConnection == null) {
      print("null _subscriptionConnection");
      _subscriptionConnection =
          stream_connectioniOS.receiveBroadcastStream().listen((timer) {
        debugPrint("enableConnectionStream $timer");
        if (timer) {
          //device connected
          disableConnectionStream();
          isDeviceConnected.value = true;

          resetDeviceList();

          if (isBluetoothConnected.value && isDeviceConnected.value)
            getDataFromStorage();
        }
      });
    }
  }

  resetDeviceList() {
    listBles.value.clear();
    listBles.refresh();
  }

  void disableConnectionStream() {
    if (_subscriptionConnection != null) {
      _subscriptionConnection?.cancel();
      _subscriptionConnection = null;
    }
  }

  void disableListentDeviceStream() {
    if (_timerSubscription != null) {
      try {
        _timerSubscription?.cancel();
      } catch (e) {}
      _timerSubscription = null;
    }
  }

  void connectToDevice(String item) {
    try {
      _methodChannel.invokeMethod("ConnectToDevice", {"text": item});
      enableConnectionStream();
    } on PlatformException catch (e) {
      print("exceptiong");
    }
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
    return locGranted;
  }
}
