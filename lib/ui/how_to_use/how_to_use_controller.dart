import 'package:get/get.dart';
import 'package:ohm_pad/data/preferences/preference_manager.dart';
import 'package:ohm_pad/routes/app_pages.dart';

class HowToUseController extends GetxController
{
  RxBool showDoNotShowOption = RxBool(false);
  RxBool clickedDoNotShow = RxBool(false);

  @override
  void onInit() {
    super.onInit();
  }
  goToScanScreen()
  {
      Get.offAndToNamed(Routes.MAIN_PAGE);
  }
  changedPage(int pageNo){
    this.showDoNotShowOption.value = pageNo == 4;
    this.showDoNotShowOption.refresh();
  }
  skipDoneAction()
  {
     if (clickedDoNotShow.value)
        PreferenceManager.instance.setShowHowToUse(!clickedDoNotShow.value);
        Get.offAndToNamed(Routes.SCAN_DEVICES);
  }
}