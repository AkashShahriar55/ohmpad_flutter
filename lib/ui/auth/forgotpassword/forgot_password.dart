import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ohm_pad/app_theme/button_theme.dart';
import 'package:ohm_pad/custom_widget/RoundedGradientButton.dart';
import 'package:ohm_pad/custom_widget/progress_view.dart';
import 'package:ohm_pad/ui/auth/forgotpassword/forgot_password_controller.dart';
import 'package:ohm_pad/utils/constants/color_constants.dart';
import 'package:ohm_pad/utils/constants/font_constants.dart';
import 'package:ohm_pad/utils/constants/icon_constants.dart';
import 'package:ohm_pad/utils/input_validator.dart';
import 'package:ohm_pad/utils/size_utils.dart';
import 'package:ohm_pad/utils/strings.dart';

class ForgotPasswordScreen extends StatelessWidget {

  ForgotPasswordController _forgotPasswordController = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(Strings.FORGOT_PASS,style:  Get.theme!.textTheme.headline6!.copyWith(color: ColorConstants.SECONDARY_COLOR,fontWeight: FontWeight.bold,fontSize: 30),),
          leading: Padding(
            padding: EdgeInsets.only(left: 16),
            child: IconButton(
                icon: Image.asset(IconConstants.ICN_BACK),
                onPressed: () => Get.back()),
          ),
          elevation: 0,
          backgroundColor: ColorConstants.BG_LIGHT_WHITE,
        ),
        body: Obx(()=>ProgressWidget(child: Container(
          //height: Get.height,
          padding: EdgeInsets.all(SizeUtils.get(20)),
          child: forgotPassBody(),
        ), isShow: _forgotPasswordController.isLoading.value),
        )
    );
  }

  Widget forgotPassBody() {
    return Form(
      key: _forgotPasswordController.formKey,
      autovalidateMode: _forgotPasswordController.autoValidate,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(Strings.PASS_RESET_INSTRUCTION,
              style: Get.theme!.textTheme.caption!.copyWith(color: ColorConstants.SECONDARY_COLOR,fontFamily: FontConstants.gauntlet,fontWeight: FontWeight.w300,fontSize: 16), textAlign: TextAlign.center),
          SizedBox(height: SizeUtils.getHeightAsPerPercent(5)),
          TextFormField(
            style: TextStyle(color: Colors.black),
            onFieldSubmitted: (value) => _forgotPasswordController.onSavePressed(),
            decoration: InputDecoration(
              labelText: Strings.EMAIL_ADD,
            ),
            keyboardType: TextInputType.emailAddress,
            onSaved: (value) => _forgotPasswordController.email = value!,
            validator: (value) => InputValidator.validateEmail(value!),
          ),
          SizedBox(height: SizeUtils.getHeightAsPerPercent(5)),
          RoundedGradientButton(
            buttonText: Strings.SUBMIT,
              onpressed:  () => _forgotPasswordController.onSavePressed(), width: 0,),
          SizedBox(height: SizeUtils.getHeightAsPerPercent(2)),
          Expanded(child: Align(alignment: Alignment.bottomCenter,child: Text(Strings.COPY_RIGHT, style: Get.theme!.textTheme.subtitle1!.copyWith(color: ColorConstants.LIGHT_GREY,fontSize: SizeUtils.get(12))))),
        ],
      ),
    );
  }
}
