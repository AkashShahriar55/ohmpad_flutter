import 'package:get/get.dart';
import 'package:ohm_pad/ui/account/edit_profile/edit_profile_controller.dart';

class EditProfileBinding extends Bindings{
  @override
  void dependencies() {
    Get.lazyPut(() => EditProfileController());
  }
}