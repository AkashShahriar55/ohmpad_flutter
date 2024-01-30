import 'package:get/get.dart';
import 'package:ohm_pad/ui/account/account_controller.dart';
import 'package:ohm_pad/ui/close/closing_controller.dart';

class AcccountBinding extends Bindings{
  @override
  void dependencies() {
    Get.lazyPut(() => AccountController());
  }

}