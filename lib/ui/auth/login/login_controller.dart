import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ohm_pad/custom_widget/dialogs.dart';
import 'package:ohm_pad/data/network/network_constants.dart';
import 'package:ohm_pad/data/preferences/preference_manager.dart';
import 'package:ohm_pad/model/login_model.dart';
import 'package:ohm_pad/routes/app_pages.dart';
import 'package:ohm_pad/utils/strings.dart';

class LoginController extends GetxController{

  RxBool isLoading = false.obs;
  AutovalidateMode autoValidate = AutovalidateMode.disabled;
  RxBool isPassObscure = true.obs;

  final formKey = GlobalKey<FormState>();
  FocusNode emailFocusNode = FocusNode();
  FocusNode passwordFocusNode = FocusNode();

  String email = "";
  String password = "";

  FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  FirebaseAnalytics analytics = FirebaseAnalytics();
  var dbRef = FirebaseFirestore.instance.collection(NetworkParams.TABLE_USER);

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

  void togglePass() async {
    isPassObscure.value = !isPassObscure.value;
  }

  void onLoginPress() {
    if (formKey.currentState!.validate()) {
      formKey.currentState!.save();
      loginUser();
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

  void loginUser() async{
    FocusManager.instance.primaryFocus!.unfocus();
    setLoading(true);
    firebaseAuth
        .signInWithEmailAndPassword(
        email: email,
        password: password
    ).then((result) {
      dbRef.doc(result.user!.uid).get().then((res) async{
        setLoading(false);

        User user = FirebaseAuth.instance.currentUser!;
        print("TAG Login emailVerified : ${user.emailVerified}");
        if(user.emailVerified){
          final map = {
            NetworkParams.EMAIL : res[NetworkParams.EMAIL],
            NetworkParams.FIRST_NAME : res[NetworkParams.FIRST_NAME],
            NetworkParams.LAST_NAME : res[NetworkParams.LAST_NAME],
            NetworkParams.MOBILE_NO : res[NetworkParams.MOBILE_NO]
          };
          await PreferenceManager.instance.setIsLogin(true);
          await PreferenceManager.instance.setLoginInfo(map);

          // Get.offAndToNamed(Routes.SCAN_DEVICES);
          bool showHowToUse = await PreferenceManager.instance.showHowToUse();
          if (FirebaseAuth.instance.currentUser != null) {
            analytics.setUserId(FirebaseAuth.instance.currentUser!.uid);
            analytics.setUserProperty(name: "UserId", value: FirebaseAuth.instance.currentUser!.uid);
          }
          if (showHowToUse)
            Get.offAndToNamed(Routes.HOW_TO_USE);
          else
            Get.offAndToNamed(Routes.SCAN_DEVICES);
        }else{
          Dialogs.showDialogWithTwoOptions(Get.context!, Strings.VERIFY_EMAIL_ERROR_MSG,Strings.CANCEL,negativeButtonText: Strings.RE_SEND_VERIFICATION_MAIL,negativeButtonCallBack: (){
            Get.back();
            sendVerificationMail(user);
          },positiveButtonCallBack: ()=>Get.back());
        }

      });
    }).catchError((error){
      setLoading(false);
      print("TAG Login Error : ${error.message}");
      Dialogs.showInfoDialog(Get.context!, error.message);
    });
  }

  setLoading(bool loading){
    isLoading.value = loading;
  }

  void sendVerificationMail(User user) async{
    await user.sendEmailVerification();
    Dialogs.showInfoDialog(Get.context!, Strings.VERIFY_EMAIL_MSG);
  }

}