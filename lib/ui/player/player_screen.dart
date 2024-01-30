import 'dart:async';
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart';
import 'package:ohm_pad/app_theme/button_theme.dart';
import 'package:ohm_pad/custom_widget/dialogs.dart';
import 'package:ohm_pad/custom_widget/seekbar.dart';
import 'package:ohm_pad/ui/home/general_player_controller.dart';
import 'package:ohm_pad/ui/player/player_controller.dart';
import 'package:ohm_pad/utils/constants/color_constants.dart';
import 'package:ohm_pad/utils/constants/icon_constants.dart';
import 'package:ohm_pad/utils/size_utils.dart';
import 'package:ohm_pad/utils/strings.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:volume_control/volume_control.dart';

class PlayerScreen extends StatelessWidget {
  GeneralPlayerController _playerController = Get.find();
  PlayerController player = Get.find();
  ThemeData themeData = Theme.of(Get.context!);
  SliderThemeData _sliderThemeData = SliderTheme.of(Get.context!).copyWith(
    trackHeight: 2.0,
  );

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        // showAlertOnBack(context);
        // return false;
        return true;
      },
      child: Scaffold(
        body: Stack(
          alignment: Alignment.center,
          children: [
            Container(
              decoration: new BoxDecoration(
                  image: new DecorationImage(
                      fit: BoxFit.cover,
                      image: NetworkImage(_playerController.music!.thumb!))),
              child: new BackdropFilter(
                filter: new ImageFilter.blur(sigmaX: 6.0, sigmaY: 6.0),
                child: new Container(
                  decoration:
                      new BoxDecoration(color: Colors.white.withOpacity(0.0)),
                ),
              ),
            ),
            playerBody(),
          ],
        ),
      ),
    );
  }

  void showAlertOnBack(BuildContext context) {
    Dialogs.showDialogWithTwoOptions(
        context, 'Do you want to end the session?', "Yes",
        negativeButtonText: 'No', positiveButtonCallBack: () {
      Get.back();
      Get.back();
    });
  }

  playerBody() {
    return SafeArea(
      child: Container(
        width: SizeUtils.screenWidth,
        padding: EdgeInsets.all(SizeUtils.get(20)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: SizeUtils.get(10)),
            IconButton(
              icon: Image.asset(IconConstants.ICN_BACK, fit: BoxFit.fill),
              onPressed: () {
                Get.back();
                // showAlertOnBack(Get.context!);
              },
            ),
            Expanded(
                child: Container(
              margin: EdgeInsets.all(SizeUtils.get(35)),
              width: SizeUtils.screenWidth,
              decoration: new BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                      color: Colors.white,
                      width: SizeUtils.get(5),
                      style: BorderStyle.solid),
                  image: new DecorationImage(
                      fit: BoxFit.fill,
                      image: NetworkImage(_playerController.music!.thumb!))),
            )),
            SizedBox(height: SizeUtils.get(40)),
            Text(_playerController.music!.name!,
                style: themeData.textTheme.headline5!
                    .copyWith(color: Colors.white)),
            SizedBox(height: SizeUtils.get(6)),
            Text('Theta Binaural beats, 528 Hz',
                style: themeData.textTheme.button!.copyWith(
                    color: Colors.white, fontWeight: FontWeight.w200)),
            SizedBox(height: SizeUtils.get(20)),
            Obx(() => SeekBar(
                  duration: _playerController.duration.value,
                  position: _playerController.position.value,
                  bufferedPosition: _playerController.bufferedPosition.value,
                  onChangeEnd: _playerController.player.value.seek,
                )),
            SizedBox(height: SizeUtils.get(32)),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Obx(() => !(_playerController.processingState.value ==
                            ProcessingState.completed ||
                        (_playerController.processingState.value ==
                                ProcessingState.ready &&
                            _playerController.playing.value == false))
                    ? containerVolume()
                    : ButtonUtils.btnFillGreen(
                        title: 'Finish', onTap: () => player.gotoMoodScreen())),
                Spacer(),
                Container(
                    decoration: BoxDecoration(
                      color: ColorConstants.YELLOW,
                      shape: BoxShape.circle,
                    ),
                    child: Obx(() => getStateWiseWidget()))
              ],
            ),
          ],
        ),
      ),
    );
  }

  Container containerVolume() {
    return Container(
      width: SizeUtils.get(100),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Image.asset(
            IconConstants.ICN_VOLUME,
            height: SizeUtils.get(25),
            width: SizeUtils.get(25),
          ),
          Container(
            height: 20,
            child: SliderTheme(
              data: _sliderThemeData.copyWith(
                  activeTrackColor: ColorConstants.YELLOW,
                  inactiveTrackColor: Colors.white54,
                  thumbColor: Colors.white,
                  trackShape: CustomTrackShape(),
                  trackHeight: 3),
              child: Slider(
                min: 0.0,
                max: 1.0,
                // onChangeEnd: (val) async {
                //   print('changed e $val');
                //   player.volume.value = val;
                //   await VolumeControl.setVolume(val.toDouble());
                // },
                // onChangeStart: (val) {
                //   print('changed s $val');
                //   player.volume.value = val;
                //   VolumeControl.setVolume(val.toDouble());
                // },
                divisions: 100,
                value: player.volume.value,
                onChanged: (val) async {
                  print('changed $val');
                  player.volume.value = val;
                  Timer(Duration(milliseconds: 500), () {
                    VolumeControl.setVolume(val);
                  });
                  // await VolumeControl.setVolume(val.toDouble());
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  getStateWiseWidget() {
    if (_playerController.processingState.value == ProcessingState.loading ||
        _playerController.processingState.value == ProcessingState.buffering) {
      return Container(
        margin: EdgeInsets.all(SizeUtils.get(8)),
        width: SizeUtils.get(35),
        height: SizeUtils.get(35),
        child: CircularProgressIndicator(
          color: Colors.white,
        ),
      );
    } else if (_playerController.playing.value != true) {
      return IconButton(
        icon: Icon(Icons.play_arrow, color: ColorConstants.WHITE),
        iconSize: SizeUtils.get(35),
        onPressed: _playerController.player.value.play,
      );
    } else if (_playerController.processingState.value !=
        ProcessingState.completed) {
      return IconButton(
        icon: Icon(Icons.pause, color: ColorConstants.WHITE),
        iconSize: SizeUtils.get(35),
        onPressed: _playerController.player.value.pause,
      );
    } else {
      return IconButton(
        icon: Icon(
          Icons.replay,
          color: ColorConstants.WHITE,
        ),
        iconSize: SizeUtils.get(35),
        onPressed: () => _playerController.player.value.seek(Duration.zero,
            index: _playerController.player.value.effectiveIndices!.first),
      );
    }
  }
}

class ControlButtons extends StatelessWidget {
  PlayerController _playerController = Get.find();

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.max,
      children: [
        Obx(() => true
            ? OutlinedButton(
                onPressed: () {
                  _playerController.gotoMoodScreen();
                },
                style: ButtonStyle(
                  backgroundColor:
                      MaterialStateProperty.all(Colors.black.withOpacity(0.5)),
                  side: MaterialStateProperty.all(
                    BorderSide.lerp(
                        BorderSide(
                          style: BorderStyle.solid,
                          color: ColorConstants.WHITE,
                          width: SizeUtils.get(2),
                        ),
                        BorderSide(
                          style: BorderStyle.solid,
                          color: ColorConstants.WHITE,
                          width: SizeUtils.get(2),
                        ),
                        10.0),
                  ),
                ),
                child: Text(
                  Strings.FINISHED,
                  style: Get.textTheme!.subtitle1!
                      .copyWith(color: ColorConstants.WHITE),
                ))
            : Container()),
      ],
    );
  }
}
