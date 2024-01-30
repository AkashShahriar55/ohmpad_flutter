import 'package:get/get.dart';
import 'package:ohm_pad/ui/mood/mood_controller.dart';

class MoodBinding extends Bindings{
  @override
  void dependencies() {
    Get.lazyPut(() => MoodController());
  }
}