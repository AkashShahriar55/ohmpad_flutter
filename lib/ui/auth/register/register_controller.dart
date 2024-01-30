import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ohm_pad/custom_widget/dialogs.dart';
import 'package:ohm_pad/data/network/network_constants.dart';
import 'package:ohm_pad/utils/strings.dart';

class RegisterController extends GetxController {
  RxBool isLoading = false.obs;
  AutovalidateMode autoValidate = AutovalidateMode.disabled;
  RxBool isPassObscure = true.obs;
  RxBool isConfirmPassObscure = true.obs;

  final formKey = GlobalKey<FormState>();
  FocusNode emailFocusNode = FocusNode();
  FocusNode firstNameFocusNode = FocusNode();
  FocusNode lastNameFocusNode = FocusNode();
  FocusNode mobileFocusNode = FocusNode();
  FocusNode passwordFocusNode = FocusNode();
  FocusNode confirmPasswordFocusNode = FocusNode();

  String email = "";
  String firstName = "";
  String lastName = "";
  String mobileNo = "";
  String password = "";
  String confirmPassword = "";

  FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  var dbRef = FirebaseFirestore.instance.collection(NetworkParams.TABLE_USER);
  String url = 'https://www.privacypolicies.com/live/5c8933fd-5029-44c2-b1e9-ba50269e66ee';

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

  void onRegisterPress() {
    if (formKey.currentState!.validate()) {
      formKey.currentState!.save();
      createAccount();
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

  void createAccount() {
    FocusManager.instance.primaryFocus!.unfocus();
    setLoading(true);
    firebaseAuth
        .createUserWithEmailAndPassword(email: email, password: password)
        .then((result) {
      dbRef.doc(result.user!.uid).set({
        NetworkParams.EMAIL: email,
        NetworkParams.FIRST_NAME: firstName,
        NetworkParams.LAST_NAME: lastName,
        NetworkParams.MOBILE_NO: mobileNo
      }).then((res) async {
        User? user = FirebaseAuth.instance.currentUser;

        if (user != null && !user.emailVerified) {
          user.updateDisplayName(firstName + " " + lastName); //added this line
          await user.sendEmailVerification().onError((error, stackTrace) {
            setLoading(false);
            Dialogs.showInfoDialog(Get.context!, error.toString());
          });
          setLoading(false);
          Dialogs.showInfoDialog(Get.context!, Strings.VERIFY_EMAIL_MSG,
              isCancelable: false, onPressed: () {
            Get.back();
            Get.back();
          });
        } else
          setLoading(false);

        //Done Do Next
      });
    }).catchError((error) {
      setLoading(false);
      Dialogs.showInfoDialog(Get.context!, error.message);
      print("TAG Register Error : ${error.message}");
      if (error.code == 'weak-password') {
        print('The password provided is too weak.');
      } else if (error.code == 'email-already-in-use') {
        print('The account already exists for that email.');
      }
    });
  }

  setLoading(bool loading) {
    isLoading.value = loading;
  }

  void togglePass() async {
    isPassObscure.value = !isPassObscure.value;
  }

  void toggleConfirmPass() async {
    isConfirmPassObscure.value = !isConfirmPassObscure.value;
  }
}
