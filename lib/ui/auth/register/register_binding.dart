import 'package:get/get.dart';
import 'package:ohm_pad/ui/auth/register/register_controller.dart';

class RegisterBinding extends Bindings{
  @override
  void dependencies() {
    Get.lazyPut(() => RegisterController());
  }

}