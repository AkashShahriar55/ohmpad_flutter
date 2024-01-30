import 'package:get/get.dart';
import 'package:ohm_pad/ui/profile/profile_controller.dart';

class ProfileBinding extends Bindings{
  @override
  void dependencies() {
    Get.lazyPut(() => ProfileController());
  }

}