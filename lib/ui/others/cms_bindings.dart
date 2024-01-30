import 'package:get/get.dart';
import 'package:ohm_pad/ui/others/cms_controllers.dart';

class CMSBindings extends Bindings{
  @override
  void dependencies() {
    Get.lazyPut(() => CMSController());
  }
}