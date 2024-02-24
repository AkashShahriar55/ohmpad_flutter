import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:ohm_pad/data/network/network_constants.dart';
import 'package:ohm_pad/model/mood_model.dart';
import 'package:ohm_pad/model/music_list_model.dart';
import 'package:ohm_pad/model/music_model.dart';
import 'package:ohm_pad/routes/app_pages.dart';
import 'package:ohm_pad/utils/strings.dart';

class SubMoodController extends GetxController {
  Rx<List<String>> items = Rx<List<String>>([]);
  Rx<String> moodName = Rx<String>("");
  MusicListModel? music;
  MoodModel? data;
  FirebaseAnalytics analytics = FirebaseAnalytics.instance;
  var dbRef = FirebaseFirestore.instance.collection(NetworkParams.TABLE_USER);

  moveToNextScreen(String finalMood) {
    print('sss');
    navigate(finalMood);
  }

  void navigate(String finalMood) {
    if (Get.arguments['isSong']) {
      logEvent(finalMood);
      logCustomEvent(finalMood);
      Get.offNamedUntil(Routes.PLAYER_SCREEN,
          (route) => route.settings.name == Routes.MAIN_PAGE,
          arguments: {"music": music, "data": data});
    } else {
      logEvent(finalMood, type: Strings.END_MOOD_SELECTION);
      logCustomEvent(finalMood, type: Strings.END);
      Get.offNamedUntil(Routes.CLOSING_SCREEN,
          (route) => route.settings.name == Routes.MAIN_PAGE);
    }
  }

  void logEvent(String finalMood,
      {String type = Strings.START_MOOD_SELECTION}) {
    analytics.logSelectContent(
        contentType: music!.name.toString() +
            ', ' +
            type +
            ', ' +
            moodName.value +
            ', ' +
            finalMood,
        itemId: FirebaseAuth.instance.currentUser!.uid);
  }

  void logCustomEvent(String finalMood, {String type = Strings.START}) {
    var format = new DateFormat('dd, MM yyyy, hh:mm a');
    String date = format.format(DateTime.now());
    Map<String, Object?>? arguments = {
      "music": music!.name,
      "mood": this.moodName.value,
      "sub_mood": finalMood,
      'mood_selection': type,
      'user_id': FirebaseAuth.instance.currentUser!.uid,
      'date_time': date,
    };

    dbRef
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection('Events')
        .doc(DateTime.now().microsecondsSinceEpoch.toString())
        .set(arguments);

    analytics.logEvent(name: Strings.MOOD_SELECTION, parameters: arguments);
  }

  @override
  void onInit() {
    data = Get.arguments["mood"];
    music = Get.arguments["music"];
    moodName.value = data!.name!;
    items.value = data!.subItems!;
    items.refresh();
    moodName.refresh();
    super.onInit();
  }
}
