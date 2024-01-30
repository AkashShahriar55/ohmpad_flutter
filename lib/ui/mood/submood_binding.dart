import 'package:get/get.dart';
import 'package:ohm_pad/ui/mood/sub_mood_controller.dart';


class SubMoodBinding extends Bindings{
  @override
  void dependencies() {
    Get.lazyPut(() => SubMoodController());
  }
}