import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ohm_pad/custom_widget/RoundedGradientButton.dart';
import 'package:ohm_pad/custom_widget/progress_view.dart';
import 'package:ohm_pad/routes/app_pages.dart';
import 'package:ohm_pad/ui/auth/login/login_controller.dart';
import 'package:ohm_pad/utils/constants/color_constants.dart';
import 'package:ohm_pad/utils/constants/icon_constants.dart';
import 'package:ohm_pad/utils/input_validator.dart';
import 'package:ohm_pad/utils/size_utils.dart';
import 'package:ohm_pad/utils/strings.dart';

class LoginScreen extends StatelessWidget {
  LoginController _loginController = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Obx(
      () => ProgressWidget(
          child: SingleChildScrollView(
            child: Container(
              padding: EdgeInsets.all(SizeUtils.get(20)),
              width: SizeUtils.screenWidth,
              child: SafeArea(child: loginBody()),
            ),
          ),
          isShow: _loginController.isLoading.value),
    ));
  }

  loginBody() {
    return Form(
        key: _loginController.formKey,
        autovalidateMode: _loginController.autoValidate,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              alignment: Alignment.center,
              padding: EdgeInsets.symmetric(horizontal: SizeUtils.get(5)),
              width: SizeUtils.screenWidth,
              child: Image.asset(IconConstants.LOGIN_LOGO,
                  width: SizeUtils.get(200), height: SizeUtils.get(200)),
            ),
            welcomeText(),
            SizedBox(height: SizeUtils.getHeightAsPerPercent(5)),
            emailTextField(),
            SizedBox(height: SizeUtils.getHeightAsPerPercent(2)),
            passTextField(),
            SizedBox(height: SizeUtils.getHeightAsPerPercent(2)),
            Align(
              alignment: Alignment.topRight,
              child: forgotPass(),
            ),
            SizedBox(height: SizeUtils.getHeightAsPerPercent(5)),
            RoundedGradientButton(
              width: 0,
              onpressed:(){
                _loginController.onLoginPress();
              },
              buttonText: 'Login',
            ),
            SizedBox(height: SizeUtils.getHeightAsPerPercent(3)),
            createAcc(),
            SizedBox(height: SizeUtils.getHeightAsPerPercent(5)),
            Align(
                child: Text(Strings.COPY_RIGHT,
                    style: Get.theme!.textTheme.subtitle1!.copyWith(
                      fontWeight: FontWeight.bold,
                        color: ColorConstants.LIGHT_GREY,
                        fontSize: SizeUtils.get(14))))
          ],
        ));
  }

  createAcc() {
    return RichText(
      textAlign: TextAlign.center,
      text: TextSpan(
          text: Strings.DON_T_HAVE_ACC,
          style: Get.textTheme!.subtitle2!
              .copyWith(color: ColorConstants.BLACK_COLOR,fontSize: 16),
          children: [
            TextSpan(
                text: Strings.SIGN_UP,
                style: Get.textTheme!.subtitle2!
                    .copyWith(color: ColorConstants.PRIMARY_COLOR,fontSize: 16),
                recognizer: TapGestureRecognizer()
                  ..onTap = () {
                    Get.toNamed(Routes.SIGNUP);
                  })
          ]),
    );
  }

  InkWell forgotPass() {
    return InkWell(
        onTap: () => Get.toNamed(Routes.FORGOT_PASSWORD),
        child: Text(Strings.FORGOT_PASS,
            style: Get.theme!.textTheme.bodyText1!
                .copyWith(color: ColorConstants.SECONDARY_COLOR)));
  }

  TextFormField emailTextField() {
    return TextFormField(

      style: TextStyle(color: Colors.black),
      keyboardType: TextInputType.emailAddress,
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(

        labelText: Strings.EMAIL,
        // hintText: Strings.EMAIL,
        // hintStyle: TextStyle(
        //     color: ColorConstants.CAPTION_TEXT_COLOR,
        //     fontSize: SizeUtils.getFontSize(16),
        //     fontWeight: FontWeight.w500),

      ),
      focusNode: _loginController.emailFocusNode,
      onFieldSubmitted: (value) {
        FocusScope.of(Get.context!)
            .requestFocus(_loginController.passwordFocusNode);
      },
      onSaved: (String? value) {
        _loginController.email = value!;
      },
      validator: (value) => InputValidator.validateEmail(value!),
    );
  }

  TextFormField passTextField() {
    return TextFormField(
      style: TextStyle(color: Colors.black),
      decoration: InputDecoration(
          labelText: Strings.PASSWORD,
          hintText: Strings.PASSWORD,
          suffixIcon: IconButton(
              icon: Image.asset(
                  _loginController.isPassObscure.value
                      ? IconConstants.ICN_LOGIN_VIEW
                      : IconConstants.ICN_LOGIN_HIDE,
                  height: SizeUtils.get(20),
                  width: SizeUtils.get(20)),
              onPressed: () => _loginController.togglePass())),
      onFieldSubmitted: (_) => _loginController.onLoginPress(),
      focusNode: _loginController.passwordFocusNode,
      onSaved: (String? value) {
        _loginController.password = value!;
      },
      obscureText: _loginController.isPassObscure.value,
      validator: (value) => InputValidator.validatePassword(value!),
    );
  }

  welcomeText() {
    return Column(
      children: [
        Text(
          Strings.WELCOME_BACK,
          style: Get.textTheme!.headline5!
              .copyWith(color: ColorConstants.SECONDARY_COLOR,fontWeight: FontWeight.bold,fontSize: 30),
          textAlign: TextAlign.center,
        ),
        SizedBox(height: SizeUtils.getHeightAsPerPercent(1)),
        Text(
          Strings.WELCOME_BACK_MSG,
          style: Get.theme!.textTheme.subtitle1!.copyWith(
              color: ColorConstants.SECONDARY_COLOR,
              fontWeight: FontWeight.w300,
              fontSize: SizeUtils.get(16)),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
