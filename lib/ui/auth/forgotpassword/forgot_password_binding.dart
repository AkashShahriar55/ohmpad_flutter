import 'package:get/get.dart';
import 'package:ohm_pad/ui/auth/forgotpassword/forgot_password_controller.dart';

class ForgotPasswordBinding extends Bindings{
  @override
  void dependencies() {
    Get.lazyPut(() => ForgotPasswordController());
  }

}