import 'package:get/get.dart';
import 'package:ohm_pad/ui/home/general_player_controller.dart';
import 'package:ohm_pad/ui/home/home_controller.dart';

class HomeBinding extends Bindings{
  @override
  void dependencies() {
    Get.lazyPut(() => HomeController());
  }
}