import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ohm_pad/custom_widget/dialogs.dart';
import 'package:ohm_pad/data/preferences/preference_manager.dart';
import 'package:ohm_pad/routes/app_pages.dart';

class ChangePasswordController extends GetxController {
  var oldPasswordController = TextEditingController();
  var newPasswordController = TextEditingController();
  var confirmPasswordController = TextEditingController();

  RxBool isOldPassObscure = true.obs;
  RxBool isPassObscure = true.obs;
  RxBool isConfirmPassObscure = true.obs;

  RxBool isLoading = false.obs;

  final formKey = GlobalKey<FormState>();
  FocusNode oldPasswordFocusNode = FocusNode();
  FocusNode newPasswordFocusNode = FocusNode();
  FocusNode confirmPasswordFocusNode = FocusNode();

  togglePass(RxBool paaField) {
    paaField.value = !paaField.value;
    paaField.refresh();
    update();
  }

  onChangePasswordPress() {
    if (formKey.currentState!.validate()) {
      formKey.currentState!.save();
      _changePassword();
    }
    print(oldPasswordController.value.text);
    print(newPasswordController.value.text);
    print(confirmPasswordController.value.text);
  }

  Future<void> changePassword() async {
    isLoading.value = true;
    final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
    User? currentUser = firebaseAuth.currentUser;
    if (currentUser != null) {
      try {
        UserCredential userCredential =
            await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: currentUser.email!,
          password: oldPasswordController.text,
        );

        currentUser
            .updatePassword(confirmPasswordController.value.text)
            .then((_) {
          Dialogs.showInfoDialog(Get.context!, "Successfully changed password",
              onPressed: () {
            Get.back();
            Get.back();
          });
        }).catchError((error) {
          Dialogs.showInfoDialog(
              Get.context!, "Password can't be changed" + error.toString(),
              onPressed: () {
            Get.back();
          });

          //This might happen, when the wrong password is in, the user isn't found, or if the user hasn't logged in recently.
        });
      } on FirebaseAuthException catch (e) {
        if (e.code == 'user-not-found') {
          print('No user found for that email.');
        } else if (e.code == 'wrong-password') {
          print('Wrong password provided for that user.');
        }
      }
    }

    // currentUser!.updatePassword(confirmPasswordController.value.text).then((value) => (){
    //     isLoading.value = false;
    //     Get.back();
    // }).catchError((onError){
    //   isLoading.value = false;
    //     Dialogs.showInfoDialog(Get.context!, onError.toString(),onPressed: (){
    //       Get.back();
    //       PreferenceManager.instance.clearAll();
    //       FirebaseAuth.instance.signOut();
    //       Get.offNamedUntil(Routes.LOGIN, (route) => false);
    //     });
    // }).timeout(Duration(seconds: 10),onTimeout: ()=> Dialogs.showInfoDialog(Get.context!, "Time out"));
  }

  void _changePassword() async {
    isLoading.value = true;
    final user = FirebaseAuth.instance.currentUser;
    final cred = EmailAuthProvider.credential(
        email: user!.email!, password: oldPasswordController.value.text);

    user.reauthenticateWithCredential(cred).then((value) {
      user.updatePassword(newPasswordController.value.text).then((_) {
        isLoading.value = false;
        Dialogs.showInfoDialog(Get.context!, "Password changed successfully.",
            onPressed: () {
          Get.back();
          Get.back();
        }, isCancelable: false);
      }).catchError((error) {});
    }).catchError((err) {
      print(err.message);
      isLoading.value = false;
      Dialogs.showInfoDialog(Get.context!, "Old password is incorrect.",
          onPressed: () {
            Get.back();
          });
    });
  }
}
