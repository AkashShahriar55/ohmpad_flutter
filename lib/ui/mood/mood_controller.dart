import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:get/get.dart';
import 'package:ohm_pad/custom_widget/dialogs.dart';
import 'package:ohm_pad/data/preferences/preference_manager.dart';
import 'package:ohm_pad/model/mood_model.dart';
import 'package:ohm_pad/model/music_list_model.dart';
import 'package:ohm_pad/model/music_model.dart';
import 'package:ohm_pad/routes/app_pages.dart';
import 'package:ohm_pad/utils/common_utils.dart';
import 'package:ohm_pad/utils/constants/icon_constants.dart';
import 'package:ohm_pad/utils/strings.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class MoodController extends GetxController {
  RxBool isLoading = false.obs;
  RefreshController refreshController =
      RefreshController(initialRefresh: false);
  RxList<MoodModel> moodList = <MoodModel>[].obs;
  MusicListModel? music;
  RxBool isSong = false.obs;
  RxString name = ''.obs;

  @override
  void onInit() {
    super.onInit();
    print(Get.arguments['isSong']);
    music = Get.arguments['data'];
    isSong.value = Get.arguments['isSong'];
    staticData();
    // getDataFromStorage(true);
    getUserData();
  }

  void getUserData() async {
    var data = await PreferenceManager.instance.getLoginInfo();
    name.value = data.first_name! + ' ' + data.last_name!;
  }

  staticData() {
    moodList.clear();
    moodList.add(MoodModel(
      imageUrl: IconConstants.HAPPY_ICON,
      name: "Happy",
      subItems: [
        "Content",
        "Accepted",
        "Proud",
        "Grateful",
        "Optimistic",
        "Loving",
        "Ecstatic"
      ],
    ));

    moodList.add(MoodModel(
      imageUrl: IconConstants.SAD_ICON,
      name: "Sad",
      subItems: [
        "Disappointed",
        "Hurt",
        "Grief",
        "Lonely",
        "Depressed",
        "Regret",
        "Agony"
      ],
    ));
    moodList.add(MoodModel(
      imageUrl: IconConstants.ICN_DISGUSTED,
      name: "Disgusted",
      isPNG: true,
      subItems: [
        "Dislike",
        "Shameful",
        "Averse",
        "Contemptuous",
        "Self-hating",
        "Loathing",
        "Revolted"
      ],
    ));
    moodList.add(MoodModel(
      imageUrl: IconConstants.ANGRY_ICON,
      name: "Angry",
      subItems: [
        "Irritated",
        "Frustrated",
        "Bored",
        "Jealous",
        "Resentful",
        "Hostile",
        "Enraged"
      ],
    ));
    moodList.add(MoodModel(
      imageUrl: IconConstants.FEARFUL_ICON,
      name: "Fearful",
      subItems: [
        "Helpless",
        "Insecure",
        "Worried",
        "Inadequate",
        "Panicked",
        "Terrified",
        "Mortified"
      ],
    ));
    moodList.add(MoodModel(
      imageUrl: IconConstants.SURPRISED_ICON,
      name: "Surprised",
      subItems: [
        "Overcome",
        "Confused",
        "Distracted",
        "Shocked",
        "Amazed",
        "Astonished",
        "Disillusioned"
      ],
    ));
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void onClose() {
    super.onClose();
  }

  @override
  void onReady() {
    super.onReady();
  }

  Future<void> getDataFromStorage(bool isLoading) async {
    if (!await CommonUtils.checkInternetConnection()) {
      if (refreshController.isRefresh)
        refreshController.refreshCompleted(resetFooterState: true);
      Dialogs.showInfoDialog(Get.context!, Strings.ERROR_MESSAGE_NETWORK);
      return;
    }

    setLoading(isLoading);

    List<MoodModel> moodList = <MoodModel>[];

    firebase_storage.ListResult result =
        await firebase_storage.FirebaseStorage.instance.ref().listAll();
    result.prefixes.forEach((firebase_storage.Reference ref) {
      print('Found directory: $ref');
    });

    firebase_storage.ListResult result1 =
        await firebase_storage.FirebaseStorage.instance.ref("Mood").listAll();
    final List<firebase_storage.Reference> allFiles = result1.items;

    await Future.forEach<firebase_storage.Reference>(allFiles, (file) async {
      final String fileUrl = await file.getDownloadURL();
      var fileMeta = await file.getMetadata();
      moodList.add(MoodModel(
        name: getName(fileMeta.name),
        imageUrl: fileUrl,
      ));
    });

    // this.moodList.clear();
    // this.moodList.addAll(moodList);

    if (refreshController.isRefresh)
      refreshController.refreshCompleted(resetFooterState: true);
    else
      setLoading(!isLoading);
  }

  refreshData() async {
    getDataFromStorage(false);
  }

  setLoading(bool loading) {
    isLoading.value = loading;
  }

  String getName(String fullName) {
    final parts = fullName.split('.');
    return parts[0];
  }

  gotoNextScreen(int index) {
    Get.toNamed(Routes.SUB_MOOD_SELECTION_SCREEN, arguments: {
      "music" : music,
      "mood": this.moodList[index],
      'isSong' : isSong.value
    });
    // if (Get.arguments['isSong'])
    //   Get.offAndToNamed(Routes.PLAYER_SCREEN, arguments: music);
    // else
    //   Get.offAndToNamed(Routes.CLOSING_SCREEN);
  }
}
