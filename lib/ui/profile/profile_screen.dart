import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ohm_pad/ui/profile/profile_controller.dart';
import 'package:ohm_pad/utils/input_validator.dart';
import 'package:ohm_pad/utils/size_utils.dart';
import 'package:ohm_pad/utils/strings.dart';

class ProfileScreen extends StatelessWidget {

  ProfileController _profileController = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:Container(
        padding: EdgeInsets.symmetric(horizontal: SizeUtils.get(10)),
        child: SingleChildScrollView(
          child: Obx(()=>profileBody()),
          physics: BouncingScrollPhysics(),
        ),
      ),
    );
  }

  profileBody() {
    return Column(
      children: [
        SizedBox(height: SizeUtils.get(50)),
        TextFormField(
          enabled: false,
          controller: TextEditingController()
            ..text = _profileController.email.value,
          style: TextStyle(color: Colors.grey),
          decoration: InputDecoration(labelText: Strings.EMAIL_ADD),
          keyboardType: TextInputType.emailAddress,
          onSaved: (String? value) {
            _profileController.email.value = value!;
          },
          validator: (value) => InputValidator.validateEmail(value!),
        ),
        SizedBox(height: SizeUtils.get(10)),
        TextFormField(
          enabled: false,
          controller: TextEditingController()
            ..text = _profileController.firstName.value,
          style: TextStyle(color: Colors.grey),
          decoration: InputDecoration(labelText: Strings.FIRST_NAME),
          onSaved: (String? value) {
            _profileController.firstName.value = value!;
          },
          validator: (value) => InputValidator.validateEmail(value!),
        ),
        SizedBox(height: SizeUtils.get(10)),
        TextFormField(
          enabled: false,
          controller: TextEditingController()
            ..text = _profileController.lastName.value,
          style: TextStyle(color: Colors.grey),
          decoration: InputDecoration(labelText: Strings.LAST_NAME),
          onSaved: (String? value) {
            _profileController.lastName.value = value!;
          },
          validator: (value) => InputValidator.validateEmail(value!),
        ),
        SizedBox(height: SizeUtils.get(10)),
        TextFormField(
          enabled: false,
          controller: TextEditingController()
            ..text = _profileController.mobile.value,
          style: TextStyle(color: Colors.grey),
          decoration: InputDecoration(labelText: Strings.MOBILE_NO),
          onSaved: (String? value) {
            _profileController.mobile.value = value!;
          },
          validator: (value) => InputValidator.validateEmail(value!),
        ),
        SizedBox(height: SizeUtils.get(10)),
      ],
    );
  }
}
