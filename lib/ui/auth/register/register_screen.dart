import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:ohm_pad/app_theme/button_theme.dart';
import 'package:ohm_pad/custom_widget/RoundedGradientButton.dart';
import 'package:ohm_pad/custom_widget/progress_view.dart';
import 'package:ohm_pad/ui/auth/register/register_controller.dart';
import 'package:ohm_pad/utils/constants/color_constants.dart';
import 'package:ohm_pad/utils/constants/icon_constants.dart';
import 'package:ohm_pad/utils/input_validator.dart';
import 'package:ohm_pad/utils/size_utils.dart';
import 'package:ohm_pad/utils/strings.dart';
import 'package:url_launcher/url_launcher.dart';

class RegisterScreen extends StatelessWidget {
  RegisterController _registerController = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Obx(
      () => ProgressWidget(
          child: Container(
            padding: EdgeInsets.only(
                left: SizeUtils.get(20), right: SizeUtils.get(20)),
            width: SizeUtils.screenWidth,
            child: SafeArea(child: registerBody()),
          ),
          isShow: _registerController.isLoading.value),
    ));
  }

  registerBody() {
    return SingleChildScrollView(
      physics: BouncingScrollPhysics(),
      child: Form(
          key: _registerController.formKey,
          autovalidateMode: _registerController.autoValidate,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(height: SizeUtils.getHeightAsPerPercent(2)),
              Text(
                Strings.CREATE_ACCOUNT,
                style: Get.textTheme!.headline5!.copyWith(
                    color: ColorConstants.SECONDARY_COLOR,
                    fontWeight: FontWeight.bold,
                    fontSize: 30),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: SizeUtils.getHeightAsPerPercent(5)),
              firstNameTextField(),
              SizedBox(height: SizeUtils.getHeightAsPerPercent(2)),
              lastNameTextField(),
              SizedBox(height: SizeUtils.getHeightAsPerPercent(2)),
              emailTextField(),
              SizedBox(height: SizeUtils.getHeightAsPerPercent(2)),
              mobileTextField(),
              SizedBox(height: SizeUtils.getHeightAsPerPercent(2)),
              passTextField(),
              SizedBox(height: SizeUtils.getHeightAsPerPercent(2)),
              confirmPassTextField(),
              SizedBox(height: SizeUtils.getHeightAsPerPercent(5)),
              privacyPolicyText(),
              SizedBox(height: SizeUtils.getHeightAsPerPercent(5)),
              RoundedGradientButton(
                width: 0,
                onpressed: () => _registerController.onRegisterPress(),
                buttonText: Strings.SIGN_UP,
              ),
              SizedBox(height: SizeUtils.getHeightAsPerPercent(2)),
              haveAccountText(),
              SizedBox(height: SizeUtils.getHeightAsPerPercent(5)),
              Align(
                  child: Text(Strings.COPY_RIGHT,
                      style: Get.theme!.textTheme.subtitle1!.copyWith(
                          color: ColorConstants.LIGHT_GREY,
                          fontSize: SizeUtils.get(12))))
            ],
          )),
    );
  }

  TextFormField emailTextField() {
    return TextFormField(
      style: TextStyle(color: Colors.black),
      keyboardType: TextInputType.emailAddress,
      decoration: InputDecoration(labelText: Strings.EMAIL_ADD),
      focusNode: _registerController.emailFocusNode,
      onFieldSubmitted: (value) {
        FocusScope.of(Get.context!)
            .requestFocus(_registerController.mobileFocusNode);
      },
      textInputAction: TextInputAction.next,
      onSaved: (String? value) {
        _registerController.email = value!;
      },
      validator: (value) => InputValidator.validateEmail(value!),
    );
  }

  TextFormField firstNameTextField() {
    return TextFormField(
      style: TextStyle(color: Colors.black),
      keyboardType: TextInputType.text,
      decoration: InputDecoration(labelText: Strings.FIRST_NAME),
      focusNode: _registerController.firstNameFocusNode,
      onFieldSubmitted: (value) {
        FocusScope.of(Get.context!)
            .requestFocus(_registerController.lastNameFocusNode);
      },
      textInputAction: TextInputAction.next,
      onSaved: (String? value) {
        _registerController.firstName = value!;
      },
      validator: (value) => InputValidator.validateFirstName(value!),
    );
  }

  TextFormField lastNameTextField() {
    return TextFormField(
      style: TextStyle(color: Colors.black),
      keyboardType: TextInputType.text,
      decoration: InputDecoration(labelText: Strings.LAST_NAME),
      focusNode: _registerController.lastNameFocusNode,
      onFieldSubmitted: (value) {
        FocusScope.of(Get.context!)
            .requestFocus(_registerController.emailFocusNode);
      },
      textInputAction: TextInputAction.next,
      onSaved: (String? value) {
        _registerController.lastName = value!;
      },
      validator: (value) => InputValidator.validateLastName(value!),
    );
  }

  TextFormField mobileTextField() {
    return TextFormField(
      style: TextStyle(color: Colors.black),
      maxLength: 10,
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
        labelText: Strings.MOBILE_NO,
        counterText: "",
      ),
      textInputAction: TextInputAction.next,
      focusNode: _registerController.mobileFocusNode,
      onFieldSubmitted: (value) {
        FocusScope.of(Get.context!)
            .requestFocus(_registerController.passwordFocusNode);
      },
      onSaved: (String? value) {
        _registerController.mobileNo = value!;
      },
      validator: (value) => InputValidator.validateMobileNumber(value!),
    );
  }

  TextFormField passTextField() {
    return TextFormField(
      style: TextStyle(color: Colors.black),
      decoration: InputDecoration(
          labelText: Strings.PASSWORD,
          suffixIcon: IconButton(
              icon: Image.asset(
                  _registerController.isPassObscure.value
                      ? IconConstants.ICN_LOGIN_VIEW
                      : IconConstants.ICN_LOGIN_HIDE,
                  height: SizeUtils.get(20),
                  width: SizeUtils.get(20)),
              onPressed: () => _registerController.togglePass())),
      onChanged: (val) {
        _registerController.password = val;
      },
      textInputAction: TextInputAction.next,
      onFieldSubmitted: (value) {
        FocusScope.of(Get.context!)
            .requestFocus(_registerController.confirmPasswordFocusNode);
      },
      focusNode: _registerController.passwordFocusNode,
      onSaved: (String? value) {
        _registerController.password = value!;
      },
      obscureText: _registerController.isPassObscure.value,
      validator: (value) => InputValidator.validatePassword(value!),
    );
  }

  TextFormField confirmPassTextField() {
    return TextFormField(
      style: TextStyle(color: Colors.black),
      textInputAction: TextInputAction.done,
      decoration: InputDecoration(
          labelText: Strings.CONFIRM_PASSWORD,
          suffixIcon: IconButton(
              icon: Image.asset(
                  _registerController.isConfirmPassObscure.value
                      ? IconConstants.ICN_LOGIN_VIEW
                      : IconConstants.ICN_LOGIN_HIDE,
                  height: SizeUtils.get(20),
                  width: SizeUtils.get(20)),
              onPressed: () => _registerController.toggleConfirmPass())),
      onFieldSubmitted: (_) => _registerController.onRegisterPress(),
      focusNode: _registerController.confirmPasswordFocusNode,
      onSaved: (String? value) {
        _registerController.confirmPassword = value!;
      },
      obscureText: _registerController.isConfirmPassObscure.value,
      validator: (value) => InputValidator.validateConfirmPassword(
          value!, _registerController.password),
    );
  }

  privacyPolicyText() {
    return RichText(
      textAlign: TextAlign.center,
      text: TextSpan(
          text: Strings.PRIVACY_POLICY_MSG,
          style: Get.textTheme!.subtitle2!
              .copyWith(color: ColorConstants.BLACK_COLOR, fontSize: 16),
          children: [
            TextSpan(
                text: Strings.PRIVACY_POLICY,
                style: Get.textTheme!.subtitle2!.copyWith(
                    color: ColorConstants.SECONDARY_COLOR,
                    decoration: TextDecoration.underline,
                    fontSize: 16),
                recognizer: TapGestureRecognizer()
                  ..onTap = () async {
                    await canLaunch(_registerController.url)
                        ? await launch(_registerController.url)
                        : throw 'Could not launch $_registerController.url';
                  })
          ]),
    );
  }

  haveAccountText() {
    return RichText(
      textAlign: TextAlign.center,
      text: TextSpan(
          text: Strings.ALREADY_HAVE_ACC,
          style: Get.textTheme!.subtitle2!
              .copyWith(color: ColorConstants.BLACK_COLOR, fontSize: 16),
          children: [
            TextSpan(
                text: Strings.LOGIN,
                style: Get.textTheme!.subtitle2!.copyWith(
                    color: ColorConstants.PRIMARY_COLOR, fontSize: 16),
                recognizer: TapGestureRecognizer()
                  ..onTap = () {
                    Get.back();
                  })
          ]),
    );
  }
}
