import 'package:get/get.dart';
import 'package:ohm_pad/ui/player/player_controller.dart';

class PlayerBinding extends Bindings{
  @override
  void dependencies() {
    Get.lazyPut(() => PlayerController());
  }
}