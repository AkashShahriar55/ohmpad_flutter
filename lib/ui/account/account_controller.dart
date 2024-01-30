import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:ohm_pad/data/network/network_constants.dart';
import 'package:ohm_pad/model/login_model.dart';

class AccountController extends GetxController {

  var dbRef = FirebaseFirestore.instance.collection(NetworkParams.TABLE_USER);
  RxInt intTag = RxInt(0);
  late Rx<LoginData> userInfo = Rx<LoginData>(LoginData(email: "",first_name: "",last_name: "",mobile_no: ""));
  getUSer(){
    User? user = FirebaseAuth.instance.currentUser;
    print('user.uid');
    if (user != null) {
      print('user.uid');
      print(user.uid);
       dbRef.doc(user.uid).get().then((DocumentSnapshot documentSnapshot) {
        var fbUser = documentSnapshot.data();
        userInfo.value = LoginData.fromJson(fbUser as Map<String, dynamic>);
        userInfo.refresh();
      });

    }


  }
@override
  void onInit() {
    print("checking checking call ${intTag.value}");
    this.getUSer();
    super.onInit();
  }

}