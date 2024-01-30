import 'dart:io' as platform;

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ohm_pad/app_theme/button_theme.dart';
import 'package:ohm_pad/custom_widget/progress_view.dart';
import 'package:ohm_pad/model/music_list_model.dart';
import 'package:ohm_pad/model/music_model.dart';
import 'package:ohm_pad/ui/home/general_player_controller.dart';
import 'package:ohm_pad/ui/home/home_controller.dart';
import 'package:ohm_pad/utils/common_utils.dart';
import 'package:ohm_pad/utils/constants/color_constants.dart';
import 'package:ohm_pad/utils/size_utils.dart';
import 'package:ohm_pad/utils/strings.dart';

class HomeScreen extends StatelessWidget {
  HomeController _homeController = Get.find();
  GeneralPlayerController playerController = Get.put(GeneralPlayerController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        floatingActionButton: buildDraggableView(),
        appBar: AppBar(
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
                CommonUtils.showBottomSheet(bleConnected: true);
              },
            ),
            elevation: 0,
            backgroundColor: Colors.transparent,
            centerTitle: true,
            title: Padding(
              padding: EdgeInsets.only(top: 10),
              child: Text(
                'Select Track',
                style: Get.theme!.textTheme.subtitle2!.copyWith(
                    color: ColorConstants.SECONDARY_COLOR,
                    fontWeight: FontWeight.bold,
                    fontSize: 22),
              ),
            )),
        body: Obx(
          () {
            print("Called first :: ${_homeController.isLoading.value}");
            return ProgressWidget(
                child: Container(
                  padding: EdgeInsets.only(
                      top: SizeUtils.get(16),
                      right: SizeUtils.get(20),
                      left: SizeUtils.get(20)),
                  width: SizeUtils.screenWidth,
                  child: SafeArea(child: homeBody()),
                ),
                //opacity: 1,
                isShow: _homeController.isLoading.value);
          },
        ));
  }

  Widget buildDraggableView() {
    return Obx(() {
      return playerController.isPlaying.value ? FloatingActionButton(
        elevation: 50,
        hoverColor: ColorConstants.APP_THEME_COLOR,
        onPressed: () {
          playerController.navigateToPlayer();
        },
        child: Icon(Icons.music_note_outlined, color: Colors.white),
        tooltip: 'Goto music',
      ): Container();
    });
  }

  homeBody() {
    return Container(
      child: gridView(),
    );
    // return (!_homeController.isBluetoothConnected.value ||
    //         !_homeController.isDeviceConnected.value)
    //     ? bildListOfBLEs()
    //     : Container(
    //         child: SmartRefresher(
    //           onRefresh: () => _homeController.refreshData(),
    //           controller: _homeController.refreshController,
    //           child: gridView(),
    //         ),
    //       );
  }

  Container bildListOfBLEs() {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            Strings.CONNECT_ACC_TO_OHM_PAD,
            style: Get.theme!.textTheme.subtitle1!.copyWith(
              color: ColorConstants.BLACK_COLOR,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: SizeUtils.getHeightAsPerPercent(5)),
          ButtonUtils.btnFill(
              onTap: () => _homeController.performStartStopAndEnable(),
              title: _homeController.isBluetoothConnected.value
                  ? _homeController.isScanRunning.value
                      ? Strings.STOP_SCAN
                      : Strings.START_SCAN
                  : Strings.ENABLE_BLUETOOTH),
          SizedBox(height: SizeUtils.getHeightAsPerPercent(2)),
          Obx(() => Expanded(
              child: _homeController.listBles.value.length == 0
                  ? Container(
                      alignment: Alignment.center,
                      child: Text(_homeController.isLoading.value
                          ? ''
                          : Strings.NO_DEVICES_FOUND))
                  : ListView.builder(
                      shrinkWrap: true,
                      itemCount: _homeController.listBles.value.length,
                      itemBuilder: (context, pos) {
                        if (platform.Platform.isIOS) {
                          return listItemIos(
                              _homeController.listBles.value[pos]["name"],
                              _homeController.listBles.value[pos]["id"]);
                        } else {
                          return listItem(
                              _homeController.listBles.value[pos].toString());
                        }
                      }))),
        ],
      ),
    );
  }

  gridView() {
    return _homeController.music.length == 0
        ? Container(
            alignment: Alignment.center,
            child: Text(
                _homeController.isLoading.value ? '' : Strings.NO_MEDIA_FOUND))
        : GridView.builder(
            shrinkWrap: false,
            physics: BouncingScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 20,
                mainAxisSpacing: 20,
                childAspectRatio: 0.6),
            itemCount: _homeController.music.length,
            itemBuilder: (context, pos) =>
                itemLayout(_homeController.music[pos]));
  }

  itemLayout(MusicListModel musicList) {
    return Container(
      clipBehavior: Clip.hardEdge,
      decoration: BoxDecoration(
          color: ColorConstants.LIGHT_GREY.withOpacity(0.3),
          borderRadius: BorderRadius.all(Radius.circular(SizeUtils.get(15)))),
      child: InkWell(
        onTap: () {
          if(playerController.isPlaying.value) {
            playerController.navigateToPlayer(musicList: musicList);
          } else {
            _homeController.gotoMoodScreen(musicList);
          }
        },
        child: Stack(
          children: [
            Image.network(
              musicList.thumb!,
              fit: BoxFit.cover,
              height: double.infinity,
              width: double.infinity,
              loadingBuilder: (context, child, loadingProgress) {
                if (loadingProgress == null) {
                  return child;
                }
                return Center(
                  child: Container(
                    height: SizeUtils.get(50),
                    width: SizeUtils.get(50),
                    padding: EdgeInsets.all(SizeUtils.get(10)),
                    child: CircularProgressIndicator(
                      value: loadingProgress.expectedTotalBytes != null
                          ? loadingProgress.cumulativeBytesLoaded /
                              loadingProgress.expectedTotalBytes!
                          : null,
                    ),
                  ),
                );
              },
            ),
            Positioned.fill(
              child: Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  color: Colors.black.withOpacity(0.5),
                  width: double.infinity,
                  child: Padding(
                    padding: EdgeInsets.all(SizeUtils.get(16)),
                    child: Text(
                      musicList.name!,
                      style: Get.context!.textTheme.subtitle1!.copyWith(
                          color: ColorConstants.WHITE,
                          fontWeight: FontWeight.bold,
                          fontSize: SizeUtils.get(16)),
                      textAlign: TextAlign.left,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  listItem(String item) {
    return Container(
      margin: EdgeInsets.only(bottom: SizeUtils.get(10)),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(SizeUtils.get(5))),
      ),
      child: Padding(
        padding: EdgeInsets.all(SizeUtils.get(10)),
        child: Row(
          children: [
            Icon(Icons.bluetooth),
            SizedBox(
              width: SizeUtils.get(10),
            ),
            Expanded(
              child: Container(
                child: Text(item.toString()),
              ),
            ),
            ButtonUtils.btnFillSimple(
                onTap: () {
                  if (platform.Platform.isIOS) {
                    print("device to get connected :: $item");
                    _homeController.connectToDeviceiOS(item);
                  } else {
                    _homeController.connectToDevice(item);
                  }
                },
                title: Strings.CONNECT),
          ],
        ),
      ),
    );
  }

  listItemIos(String name, String id) {
    return Container(
      margin: EdgeInsets.only(bottom: SizeUtils.get(10)),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(SizeUtils.get(5))),
      ),
      child: Padding(
        padding: EdgeInsets.all(SizeUtils.get(10)),
        child: Row(
          children: [
            Icon(Icons.bluetooth),
            SizedBox(
              width: SizeUtils.get(10),
            ),
            Expanded(
              child: Container(
                child: Text("Name : $name \n ID:$id"),
              ),
            ),
            ButtonUtils.btnFillSimple(
                onTap: () {
                  if (platform.Platform.isIOS) {
                    _homeController.connectToDeviceiOS(id);
                  } else {
                    _homeController.connectToDevice(id);
                  }
                },
                title: Strings.CONNECT),
          ],
        ),
      ),
    );
  }
}
