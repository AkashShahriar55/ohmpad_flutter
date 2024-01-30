import 'package:audio_session/audio_session.dart';
import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart';
import 'package:ohm_pad/custom_widget/dialogs.dart';
import 'package:ohm_pad/model/mood_model.dart';
import 'package:ohm_pad/model/music_list_model.dart';
import 'package:ohm_pad/model/music_model.dart';
import 'package:ohm_pad/routes/app_pages.dart';
import 'package:ohm_pad/utils/common_utils.dart';
import 'package:ohm_pad/utils/strings.dart';

class GeneralPlayerController extends GetxController {
  Rx<AudioPlayer> player = AudioPlayer().obs;
  Rx<Duration> duration = Duration.zero.obs;
  Rx<Duration> position = Duration.zero.obs;
  Rx<Duration> bufferedPosition = Duration.zero.obs;
  RxDouble volume = 0.0.obs;
  var processingState = ProcessingState.idle.obs;
  var playing = false.obs;
  MusicListModel? music;
  RxBool isPlaying = false.obs;
  MoodModel? data;

  static GeneralPlayerController get of => Get.find();

  @override
  void onInit() async {
    super.onInit();
  }

  Future<void> setListeners(MusicListModel? musicData) async {
    volume.value = 0.5;
    music = musicData;

    if (!await CommonUtils.checkInternetConnection())
      Dialogs.showInfoDialog(Get.context!, Strings.ERROR_MESSAGE_NETWORK);
    else
      playerListener();

    playerListener();
  }

  void setMusicData(MoodModel moodModel) {
    data = moodModel;
  }

  void navigateToPlayer({MusicListModel? musicList}) {
    bool isNew = false;
    if (musicList != null) {
      music = musicList;
      isNew = true;
    }
    Get.offNamedUntil(Routes.PLAYER_SCREEN,
        (route) => route.settings.name == Routes.MAIN_PAGE,
        arguments: {"music": music, "data": data, "isNew": isNew});
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void onClose() {
    player.value.dispose();
    super.onClose();
  }

  @override
  void onReady() {
    super.onReady();
  }

  void playerListener({bool isPlay = false}) async {
    final session = await AudioSession.instance;
    await session.configure(AudioSessionConfiguration.speech());

    player.value.pause();
    //Seekbar
    player.value.positionStream.listen((event) {
      position.value = event;
    });
    player.value.bufferedPositionStream.listen((event) {
      bufferedPosition.value = event;
    });
    player.value.durationStream.listen((event) {
      duration.value = event!;
    });

    //volume
    player.value.volumeStream.listen((event) {
      volume.value = event;
    });

    //get play/pause/loading/finish(state of song)
    player.value.playerStateStream.listen((event) {
      playing.value = event.playing;
      processingState.value = event.processingState;
      /*if(processingState.value == ProcessingState.completed){
        gotoMoodScreen();
      }*/
      if (processingState.value == ProcessingState.ready) {
        print('TAG Ready');
        //Future.delayed(Duration(seconds: 5),()=>player.value.play);
      }
    });

    // Listen to errors during playback.
    player.value.playbackEventStream.listen((event) {},
        onError: (Object e, StackTrace stackTrace) {
      print('A stream error occurred: $e');
    });
    // Try to load audio from a source and catch any errors.
    try {
      await player.value
          .setAudioSource(AudioSource.uri(Uri.parse(music!.downloadURL!)));
      if (isPlay) player.value.play();
    } catch (e) {
      print("Error loading audio source: $e");
    }
  }

  pausePlayer() {
    if (player.value.playing) player.value.pause;
  }
}
