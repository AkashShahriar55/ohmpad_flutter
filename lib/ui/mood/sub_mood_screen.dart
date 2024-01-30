import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ohm_pad/ui/mood/sub_mood_controller.dart';
import 'package:ohm_pad/utils/constants/color_constants.dart';
import 'package:ohm_pad/utils/size_utils.dart';

class SubMoodScreen extends StatelessWidget {
  SubMoodController _submoodController = Get.find();

  // const SubMoodScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetX<SubMoodController>(
      builder: (_) {
        return Scaffold(
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
                Get.back();
              },
            ),
            elevation: 0,
            backgroundColor: Colors.transparent,
            centerTitle: true,
            title: Text(_.moodName.value,
                style: Get.theme!.textTheme.subtitle2!.copyWith(
                    color: ColorConstants.SECONDARY_COLOR,
                    fontWeight: FontWeight.bold,
                    fontSize: 22)),
          ),
          body: Container(
            padding: EdgeInsets.all(SizeUtils.get(20)),
            width: SizeUtils.screenWidth,
            child: SafeArea(child: moodBody(_)),
          ),
        );
      },
    );
  }

  moodBody(SubMoodController controller) {
    return ListView.builder(
      itemBuilder: (context, index) {
        return Padding(
          padding: EdgeInsets.all(SizeUtils.get(8)),
          child: buildListItem(controller, index),
        );
      },
      itemCount: controller.items.value.length,
      shrinkWrap: true,
    );
  }

  buildListItem(SubMoodController controller, int index) {
    return InkWell(
      onTap: () => controller.moveToNextScreen(controller.items.value[index]),
      child: Container(
        height: SizeUtils.get(50),
        decoration: BoxDecoration(
          color: ColorConstants.SECONDARY_COLOR.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
        ),
        padding: EdgeInsets.all(SizeUtils.get(16)),
        child: Align(
            alignment: Alignment.centerLeft,
            child: Text(
              controller.items.value[index],
              textAlign: TextAlign.left,
            )),
      ),
    );
  }
}
