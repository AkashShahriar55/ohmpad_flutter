import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:ohm_pad/custom_widget/dialogs.dart';
import 'package:ohm_pad/custom_widget/progress_view.dart';
import 'package:ohm_pad/model/mood_model.dart';
import 'package:ohm_pad/ui/mood/mood_controller.dart';
import 'package:ohm_pad/utils/constants/color_constants.dart';
import 'package:ohm_pad/utils/constants/image_constants.dart';
import 'package:ohm_pad/utils/size_utils.dart';
import 'package:ohm_pad/utils/strings.dart';

class MoodSelectionScreen extends StatelessWidget {
  MoodController _moodController = Get.find();

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (_moodController.isSong.value) {
          return true;
        } else {
          showAlertOnBack(context);
          return false;
        }
      },
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: Padding(
              padding: EdgeInsets.only(left: 8, right: 8),
              child: Icon(
                Icons.arrow_back,
                color: ColorConstants.SECONDARY_COLOR,
                size: 30,
              ),
            ),
            onPressed: () {
              if (!_moodController.isSong.value) {
                showAlertOnBack(context);
              } else {
                Get.back();
              }
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
        body: Obx(
          () => ProgressWidget(
              child: Container(
                padding: EdgeInsets.all(SizeUtils.get(20)),
                width: SizeUtils.screenWidth,
                child: SafeArea(child: moodBody()),
              ),
              isShow: _moodController.isLoading.value),
        ),
      ),
    );
  }

  moodBody() {
    return Container(
      child: Column(
        children: [
          descLabel(),
          SizedBox(
            height: SizeUtils.get(30),
          ),
          gridView(),
        ],
      ),
    );
  }

  descLabel() {
    return Text(
      "Hi ${_moodController.name.value}, ${_moodController.isSong.value ? Strings.HOW_FEELING_TODAY : Strings.HOW_FEELING_NOW}",
      style: Get.theme!.textTheme.subtitle2!.copyWith(
          color: ColorConstants.SECONDARY_COLOR,
          fontWeight: FontWeight.bold,
          fontSize: 22),
    );
  }

  Widget gridView() {
    return _moodController.moodList.length == 0
        ? Container(
            alignment: Alignment.center,
            child: Text(
                _moodController.isLoading.value ? '' : Strings.NO_MOOD_FOUND))
        : Expanded(
            child: GridView.builder(
                shrinkWrap: false,
                physics: BouncingScrollPhysics(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    crossAxisSpacing: 20,
                    mainAxisSpacing: 20),
                itemCount: _moodController.moodList.length,
                itemBuilder: (context, pos) =>
                    itemLayout(_moodController.moodList[pos], pos)),
          );
  }

  itemLayout(MoodModel mood, int position) {
    return Container(
      decoration: BoxDecoration(
          color: ColorConstants.SECONDARY_COLOR.withOpacity(0.1),
          borderRadius: BorderRadius.all(Radius.circular(10))),

      // height: SizeUtils.get(200),
      child: InkWell(
        onTap: () => _moodController.gotoNextScreen(position),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(height: SizeUtils.get(10)),
            mood.isPNG!
                ? Expanded(
                  child: Image.asset(mood.imageUrl!,
                      height: SizeUtils.get(60), width: SizeUtils.get(60)),
                )
                : Expanded(child: SvgPicture.asset(mood.imageUrl!)),
            // Image.network(
            //   moodList.imageUrl!,
            //   fit: BoxFit.contain,
            //   height: SizeUtils.get(60),
            //   width:SizeUtils.get(60),
            //   // height: double.infinity,
            //   // width: double.infinity,
            //   loadingBuilder: (context, child, loadingProgress) {
            //     if (loadingProgress == null) {
            //       return child;
            //     }
            //     return Center(
            //       child: Container(
            //         height: SizeUtils.get(50),
            //         width: SizeUtils.get(50),
            //         padding: EdgeInsets.all(SizeUtils.get(10)),
            //         child: CircularProgressIndicator(
            //           value: loadingProgress.expectedTotalBytes != null
            //               ? loadingProgress.cumulativeBytesLoaded /
            //               loadingProgress.expectedTotalBytes!
            //               : null,
            //         ),
            //       ),
            //     );
            //   },
            // ),
            Padding(
              padding: EdgeInsets.all(SizeUtils.get(8)),
              child: Text(
                mood.name!,
                style: Get.context!.textTheme.subtitle1!.copyWith(
                    color: ColorConstants.SECONDARY_COLOR,
                    fontSize: SizeUtils.get(14),
                    fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            )
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
}
