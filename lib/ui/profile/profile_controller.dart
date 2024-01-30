import 'package:get/get.dart';
import 'package:ohm_pad/data/preferences/preference_manager.dart';

class ProfileController extends GetxController{

  RxString firstName = ''.obs;
  RxString lastName = ''.obs;
  RxString email = ''.obs;
  RxString mobile = ''.obs;

  @override
  void onReady() async{
    super.onReady();
    var userData = await PreferenceManager.instance.getLoginInfo();
    email.value = userData.email!;
    firstName.value = userData.first_name!;
    lastName.value = userData.last_name!;
    mobile.value = userData.mobile_no!;
  }

  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onClose() {
    super.onClose();
  }
}