import 'package:get/get.dart';
import 'package:ohm_pad/ui/close/closing_controller.dart';

class ClosingBinding extends Bindings{
  @override
  void dependencies() {
    Get.lazyPut(() => ClosingController());
  }

}