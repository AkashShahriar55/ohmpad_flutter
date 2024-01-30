import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ohm_pad/custom_widget/RoundedGradientButton.dart';
import 'package:ohm_pad/custom_widget/progress_view.dart';
import 'package:ohm_pad/ui/account/edit_profile/edit_profile_controller.dart';
import 'package:ohm_pad/utils/constants/color_constants.dart';
import 'package:ohm_pad/utils/constants/icon_constants.dart';
import 'package:ohm_pad/utils/input_validator.dart';
import 'package:ohm_pad/utils/size_utils.dart';
import 'package:ohm_pad/utils/strings.dart';

class EditProfileScreen extends StatelessWidget {
  const EditProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          Strings.EDIT_PROFILE,
          style: Get.theme!.textTheme.subtitle2!.copyWith(
              color: ColorConstants.SECONDARY_COLOR,
              fontWeight: FontWeight.bold,
              fontSize: 22),
        ),
        elevation: 0,
        backgroundColor: Colors.transparent,
        centerTitle: true,
        leading: Container(
          margin: EdgeInsets.only(left: 10),
          child: IconButton(
              icon: Image.asset(IconConstants.ICN_BACK,
                  height: SizeUtils.get(50), width: SizeUtils.get(50)),
              onPressed: () => Get.back()),
        ),
      ),
      body: buildUI(),
    );
  }

  buildUI() {
    return GetX<EditProfileController>(builder: (_) {
      return ProgressWidget(
          child: Container(
            padding: EdgeInsets.only(
                left: SizeUtils.get(20), right: SizeUtils.get(20)),
            width: SizeUtils.screenWidth,
            child: SafeArea(child: editProfileBody(_)),
          ),
          isShow: _.isLoading.value);
    });
  }

  Widget editProfileBody(EditProfileController editProfileController) {
    return Container(
      child: Form(
        key: editProfileController.formKey,
        autovalidateMode: editProfileController.autoValidate,
        child: Column(
          children: [
            SizedBox(height: SizeUtils.get(15)),
            TextFormField(
              controller: editProfileController.firstNameCont,
              style: TextStyle(color: Colors.black),
              focusNode: editProfileController.firstNameFocusNode,
              keyboardType: TextInputType.text,
              textInputAction: TextInputAction.next,
              decoration: InputDecoration(labelText: Strings.FIRST_NAME),
              onFieldSubmitted: (value) {
                FocusScope.of(Get.context!)
                    .requestFocus(editProfileController.lastNameFocusNode);
              },
              validator: (value) => InputValidator.validateFirstName(value!),
            ),
            SizedBox(height: SizeUtils.get(15)),
            TextFormField(
                controller: editProfileController.lastNameCont,
                style: TextStyle(color: Colors.black),
                focusNode: editProfileController.lastNameFocusNode,
                textInputAction: TextInputAction.next,
                keyboardType: TextInputType.text,
                decoration: InputDecoration(labelText: Strings.LAST_NAME),
                onFieldSubmitted: (value) {
                  FocusScope.of(Get.context!)
                      .requestFocus(editProfileController.mobileFocusNode);
                },
                validator: (value) => InputValidator.validateLastName(value!)),
            SizedBox(height: SizeUtils.get(15)),
            TextFormField(
              controller: editProfileController.emailCont,
              enabled: false,
              focusNode: editProfileController.emailFocusNode,
              style: TextStyle(color: ColorConstants.LIGHT_BLACK.withOpacity(0.6)),
              keyboardType: TextInputType.text,
              decoration: InputDecoration(
                labelText: Strings.EMAIL,
              ),
            ),
            SizedBox(height: SizeUtils.get(15)),
            TextFormField(
              controller: editProfileController.mobileNoCont,
              style: TextStyle(color: Colors.black),
              maxLength: 10,
              focusNode: editProfileController.mobileFocusNode,
              keyboardType: TextInputType.number,
              validator: (value) => InputValidator.validateMobileNumber(value!),
              decoration: InputDecoration(
                labelText: Strings.MOBILE_NO,
                counterText: "",
              ),
            ),
            SizedBox(height: SizeUtils.get(20)),
            RoundedGradientButton(
                buttonText: Strings.SUBMIT,
                width: double.infinity,
                onpressed: () {
                  editProfileController.onUpdatePress();
                })
          ],
        ),
      ),
    );
  }
}
