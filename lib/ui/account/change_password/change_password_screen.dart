import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ohm_pad/custom_widget/RoundedGradientButton.dart';
import 'package:ohm_pad/custom_widget/progress_view.dart';
import 'package:ohm_pad/ui/account/change_password/change_password_controller.dart';
import 'package:ohm_pad/utils/constants/color_constants.dart';
import 'package:ohm_pad/utils/constants/icon_constants.dart';
import 'package:ohm_pad/utils/input_validator.dart';
import 'package:ohm_pad/utils/size_utils.dart';
import 'package:ohm_pad/utils/strings.dart';

class ChangePasswordScreen extends StatelessWidget {
  const ChangePasswordScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
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
        title: Text('Change Password',
            style: Get.theme!.textTheme.subtitle2!.copyWith(
                color: ColorConstants.SECONDARY_COLOR,
                fontWeight: FontWeight.bold,
                fontSize: 22)),
      ),
      body: buildUI(),
    );
  }

  buildUI() {
    return GetX<ChangePasswordController>(builder: (_) {
      return ProgressWidget(
          child: Container(
            padding: EdgeInsets.only(
                left: SizeUtils.get(15), right: SizeUtils.get(15)),
            width: SizeUtils.screenWidth,
            child: SafeArea(child: changePasswordBody(_)),
          ),
          isShow: _.isLoading.value);
    });
  }

  changePasswordBody(ChangePasswordController _) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: SizeUtils.get(16)),
      child: Form(
        key: _.formKey,
        child: Column(children: [
          Padding(
            padding: EdgeInsets.all(8.0),
            child: TextFormField(
              controller: _.oldPasswordController,
              style: TextStyle(color: Colors.black),
              keyboardType: TextInputType.text,
              textInputAction: TextInputAction.next,
              decoration: InputDecoration(
                  labelText: Strings.OLD_PASSWORD,
                  suffixIcon: IconButton(
                      icon: Image.asset(
                          _.isOldPassObscure.value
                              ? IconConstants.ICN_LOGIN_VIEW
                              : IconConstants.ICN_LOGIN_HIDE,
                          height: SizeUtils.get(20),
                          width: SizeUtils.get(20)),
                      onPressed: () => _.togglePass(_.isOldPassObscure))),
              focusNode: _.oldPasswordFocusNode,
              obscureText: _.isOldPassObscure.value,
              onFieldSubmitted: (value) {
                FocusScope.of(Get.context!)
                    .requestFocus(_.newPasswordFocusNode);
              },
              validator: (value) => InputValidator.validateOldPassword(value!),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(8.0),
            child: TextFormField(
              controller: _.newPasswordController,
              style: TextStyle(color: Colors.black),
              keyboardType: TextInputType.text,
              textInputAction: TextInputAction.next,
              decoration: InputDecoration(
                  labelText: Strings.NEW_PASSWORD,
                  suffixIcon: IconButton(
                      icon: Image.asset(
                          _.isPassObscure.value
                              ? IconConstants.ICN_LOGIN_VIEW
                              : IconConstants.ICN_LOGIN_HIDE,
                          height: SizeUtils.get(20),
                          width: SizeUtils.get(20)),
                      onPressed: () => _.togglePass(_.isPassObscure))),
              focusNode: _.newPasswordFocusNode,
              obscureText: _.isPassObscure.value,
              onFieldSubmitted: (value) {
                FocusScope.of(Get.context!)
                    .requestFocus(_.confirmPasswordFocusNode);
              },
              validator: (value) => InputValidator.validateNewPassword(value!),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(8.0),
            child: TextFormField(
              controller: _.confirmPasswordController,
              style: TextStyle(color: Colors.black),
              decoration: InputDecoration(
                  labelText: Strings.CONFIRM_PASSWORD,
                  suffixIcon: IconButton(
                      icon: Image.asset(
                          _.isConfirmPassObscure.value
                              ? IconConstants.ICN_LOGIN_VIEW
                              : IconConstants.ICN_LOGIN_HIDE,
                          height: SizeUtils.get(20),
                          width: SizeUtils.get(20)),
                      onPressed: () => _.togglePass(_.isConfirmPassObscure))),
              onFieldSubmitted: (a) => _.onChangePasswordPress(),
              focusNode: _.confirmPasswordFocusNode,
              obscureText: _.isConfirmPassObscure.value,
              validator: (value) => InputValidator.validateConfirmPassword(
                  value!, _.newPasswordController.text),
            ),
          ),
          SizedBox(
            height: SizeUtils.get(20),
          ),
          RoundedGradientButton(
              buttonText: Strings.SUBMIT,
              width: double.infinity,
              onpressed: () {
                _.onChangePasswordPress();
              })
        ]),
      ),
    );
  }
}
