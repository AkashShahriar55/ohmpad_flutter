import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ohm_pad/custom_widget/RoundedGradientButton.dart';
import 'package:ohm_pad/custom_widget/progress_view.dart';
import 'package:ohm_pad/ui/connection/scan_devices_controller.dart';
import 'package:ohm_pad/utils/common_utils.dart';
import 'package:ohm_pad/utils/constants/color_constants.dart';
import 'package:ohm_pad/utils/constants/font_constants.dart';
import 'package:ohm_pad/utils/constants/icon_constants.dart';
import 'package:ohm_pad/utils/constants/image_constants.dart';
import 'package:ohm_pad/utils/size_utils.dart';
import 'package:ohm_pad/utils/strings.dart';

class ScanDevicesPage extends StatelessWidget {
  final ScanDevicesController controller = Get.put(ScanDevicesController());

  // const ScanDevicesPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
              CommonUtils.showBottomSheet(bleConnected: false);
            },
          ),
          elevation: 0,
          backgroundColor: Colors.transparent,
          centerTitle: true,
          title: Container(
            height: 30,
            child: Image.asset(ImageConstants.TITLE_LOGO),
          ),
        ),
        body: GetX<ScanDevicesController>(
          builder: (_) {
            return ProgressWidget(
              isShow: controller.isLoading.value,
              child: _.screenStatus.value == ScreenStatus.SEARCH_BLE
                  ? buildSearchBody(_)
                  : buildList(_),
            );
          },
        ));
  }

  Widget buildSearchBody(ScanDevicesController controller) {
    var width = MediaQuery.of(Get.context!).size.width - 40;
    return Center(
        child: Padding(
      padding: EdgeInsets.all(SizeUtils.get(30)),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                  width: width / 1.5,
                  child: Image.asset(ImageConstants.SCAN_CENTER)),
              SizedBox(height: SizeUtils.get(20)),
              Text(
                controller.isBluetoothOn.value
                    ? Strings.CONNECTION_TEXT_SEARCH
                    : Strings.TURNBLUEONTEXT,
                style: Get.theme!.textTheme.subtitle2!.copyWith(
                    color: ColorConstants.SECONDARY_COLOR,
                    fontFamily: FontConstants.gauntlet,
                    fontSize: SizeUtils.getFontSize(18),
                    fontWeight: FontWeight.w600),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: SizeUtils.get(20)),
              !controller.isSearchingForBLEs.value
                  ? RoundedGradientButton(
                      buttonText: controller.isBluetoothOn.value
                          ? Strings.SEARCH_OHMPAD
                          : Strings.ENABLE_BLUETOOTH,
                      width: width,
                      onpressed: () {
                        if (controller.isBluetoothOn.value) {
                          controller.searchForTheBLEDevices();
                        } else {
                          controller.enableBluetooth();
                        }
                      })
                  : Text(
                      controller.isBluetoothOn.value
                          ? Strings.SEARCHING_OHMPAD
                          : Strings.ENABLE_BLUETOOTH,
                      style: Get.theme!.textTheme.subtitle2!.copyWith(
                          color: ColorConstants.SECONDARY_COLOR,
                          fontSize: 18,
                          fontWeight: FontWeight.w600),
                    ),
              SizedBox(height: SizeUtils.get(25)),
            ],
          ),
          Positioned(child: copyRightText(), bottom: 0,)
        ],
      ),
    ));
  }

  Text copyRightText() {
    return Text(Strings.COPY_RIGHT,
        style: Get.theme!.textTheme.subtitle1!.copyWith(
            color: ColorConstants.LIGHT_GREY,
            fontSize: SizeUtils.get(12),
            fontWeight: FontWeight.bold));
  }

  Widget buildList(ScanDevicesController controller) {
    return Padding(
      padding: EdgeInsets.all(SizeUtils.get(20)),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(Strings.AVAILABLE_OHMPADS,
                  style: Get.theme!.textTheme.headline6!.copyWith(
                      fontSize: SizeUtils.getFontSize(20),
                      fontWeight: FontWeight.bold)),
              IconButton(
                  onPressed: () {
                    controller.rescanTapped();
                  },
                  icon: Image.asset(
                    IconConstants.ICON_REFRESH,
                    width: 30,
                    height: 30,
                    fit: BoxFit.fitHeight,
                  ))
            ],
          ),
          SizedBox(height: 10),
          Expanded(
              child: controller.screenStatus.value == ScreenStatus.LIST_OF_BLES
                  ? buildInternalListView(controller)
                  : buildNoData() //,
              ),
          SizedBox(height: SizeUtils.get(25)),
          copyRightText()
        ],
      ),
    );
  }

  ListView buildInternalListView(ScanDevicesController controller) {
    return ListView.builder(
      itemCount: controller.listBles.length,
      shrinkWrap: true,
      itemBuilder: (context, row) {
        return buildListItem(row, controller);
      },
    );
  }

  Widget buildListItem(int index, ScanDevicesController controller) {
    return Padding(
      padding: EdgeInsets.only(top: 6.0, bottom: 6.0),
      child: Container(
        height: SizeUtils.get(100),
        decoration: BoxDecoration(
            color: ColorConstants.LIST_BG_COLOR,
            borderRadius: BorderRadius.all(Radius.circular(10))),
        child: Padding(
          padding: EdgeInsets.all(SizeUtils.get(16)),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Flexible(
                child: Text(
                  Platform.isIOS
                      ? '${controller.listBles.value[index]["name"]}\n${controller.listBles.value[index]["id"]}'
                      : controller.listBles.value[index].toString(),
                  style: Get.theme!.textTheme.subtitle1!.copyWith(
                    color: ColorConstants.BLACK_COLOR,
                    fontFamily: FontConstants.gauntlet,
                    fontSize: SizeUtils.getFontSize(18),
                    fontWeight: FontWeight.w300,
                  ),
                  maxLines: 2,
                  softWrap: false,
                  // overflow: TextOverflow.ellipsis,

                  // overflow: TextOverflow.fade,
                ),
              ),
              RoundedGradientButton(
                radius: 10,
                height: 40,
                width: 0,
                onpressed: () {
                  controller.isLoading.value = true;
                  Platform.isIOS
                      ? controller.connectToDeviceiOS(
                          controller.listBles.value[index]["id"])
                      : controller.connectToDevice(
                          controller.listBles.value[index].toString());
                },
                buttonText: Strings.CONNECT,
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget buildNoData() {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(20),
        child: Text(Strings.NO_DEVICES_FOUND,
            textAlign: TextAlign.center,
            style: Get.theme!.textTheme.headline6!
                .copyWith(color: ColorConstants.SECONDARY_COLOR)),
      ),
    );
  }
}
