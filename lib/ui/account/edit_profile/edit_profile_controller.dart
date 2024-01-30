import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ohm_pad/custom_widget/dialogs.dart';
import 'package:ohm_pad/data/network/network_constants.dart';
import 'package:ohm_pad/data/preferences/preference_manager.dart';
import 'package:ohm_pad/model/login_model.dart';

class EditProfileController extends GetxController {
  RxBool isLoading = false.obs;
  AutovalidateMode autoValidate = AutovalidateMode.disabled;

  final formKey = GlobalKey<FormState>();
  FocusNode emailFocusNode = FocusNode();
  FocusNode firstNameFocusNode = FocusNode();
  FocusNode lastNameFocusNode = FocusNode();
  FocusNode mobileFocusNode = FocusNode();

  RxString email = "".obs;
  RxString firstName = "".obs;
  RxString lastName = "".obs;
  RxString mobileNo = "".obs;

  TextEditingController emailCont = TextEditingController();
  TextEditingController firstNameCont = TextEditingController();
  TextEditingController lastNameCont = TextEditingController();
  TextEditingController mobileNoCont = TextEditingController();

  var dbRef = FirebaseFirestore.instance.collection(NetworkParams.TABLE_USER);
  late Rx<LoginData> userInfo = Rx<LoginData>(
      LoginData(email: "", first_name: "", last_name: "", mobile_no: ""));

  getUSer() {
    User? user = FirebaseAuth.instance.currentUser;
    print('user.uid');
    if (user != null) {
      print('user.uid');
      print(user.uid);
      dbRef.doc(user.uid).get().then((DocumentSnapshot documentSnapshot) {
        var fbUser = documentSnapshot.data();
        userInfo.value = LoginData.fromJson(fbUser as Map<String, dynamic>);
        email.value = userInfo.value.email!;
        mobileNo.value = userInfo.value.mobile_no!;
        firstName.value = userInfo.value.first_name!;
        lastName.value = userInfo.value.last_name!;

        emailCont.text = email.value;
        mobileNoCont.text = mobileNo.value;
        firstNameCont.text = firstName.value;
        lastNameCont.text = lastName.value;
        userInfo.refresh();
      });
    }
  }

  @override
  void onInit() {
    super.onInit();
    getUSer();
  }

  void onUpdatePress() {
    if (formKey.currentState!.validate()) {
      formKey.currentState!.save();
      updateData();
    } else {
      toggleAutoValidate();
    }
  }

  void toggleAutoValidate() async {
    if(autoValidate == AutovalidateMode.always){
      autoValidate = AutovalidateMode.disabled;
    }else{
      autoValidate = AutovalidateMode.always;
    }
  }

  void updateData() async {
    isLoading.value = true;
    userInfo.value.first_name = firstNameCont.text;
    userInfo.value.last_name = lastNameCont.text;
    userInfo.value.mobile_no = mobileNoCont.text;
    userInfo.value.email = email.value;
    await dbRef
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .update(userInfo.toJson());
    await PreferenceManager.instance.setLoginInfo(userInfo.toJson());
    isLoading.value = false;

    Dialogs.showInfoDialog(Get.context!, 'User profile updated successfully.',
        onPressed: () {
      Get.back();
      Get.back();
    }, isCancelable: false);
  }
}
