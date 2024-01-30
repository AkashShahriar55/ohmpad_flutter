import 'package:get/get.dart';
import 'package:ohm_pad/ui/how_to_use/how_to_use_controller.dart';


class HowToUseBinding extends Bindings{
  @override
  void dependencies() {
    Get.lazyPut(() => HowToUseController());
  }
}