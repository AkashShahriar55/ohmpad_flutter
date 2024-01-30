import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ohm_pad/custom_widget/dialogs.dart';
import 'package:ohm_pad/routes/app_pages.dart';
import 'package:ohm_pad/utils/strings.dart';

class ForgotPasswordController extends GetxController{

  RxBool isLoading = false.obs;
  AutovalidateMode autoValidate = AutovalidateMode.disabled;

  final formKey = GlobalKey<FormState>();
  String email = "";

  FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onClose() {
    super.onClose();
  }

  @override
  void onReady() {
    super.onReady();
  }

  void onSavePressed() {
    if (formKey.currentState!.validate()) {
      formKey.currentState!.save();
      sendRestLink();
    } else {
      toggleAutoValidate();
    }
  }

  void toggleAutoValidate() {
    if(autoValidate == AutovalidateMode.always){
      autoValidate = AutovalidateMode.disabled;
    }else{
      autoValidate = AutovalidateMode.always;
    }
  }

  void sendRestLink() async{
    FocusManager.instance.primaryFocus!.unfocus();
    setLoading(true);
    await firebaseAuth.sendPasswordResetEmail(email: email).then((value) {
      setLoading(false);
      Dialogs.showInfoDialog(Get.context!, Strings.RESET_EMAIL_LINK_SENT,isCancelable :false,onPressed: (){
        Get.back();
        Get.back();
      });
    }).catchError((onError){
      setLoading(false);
      Dialogs.showInfoDialog(Get.context!, onError.message);
    });

  }

  setLoading(bool loading){
    isLoading.value = loading;
  }

  void signOut() async{
    await firebaseAuth.signOut().then((value) => Get.offAllNamed(Routes.LOGIN));
  }
}