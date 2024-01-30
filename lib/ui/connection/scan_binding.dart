import 'package:get/get.dart';
import 'package:ohm_pad/ui/connection/scan_devices_controller.dart';

class ScanBinding extends Bindings{
  @override
  void dependencies() {
    Get.lazyPut(() => ScanDevicesController());
  }

}