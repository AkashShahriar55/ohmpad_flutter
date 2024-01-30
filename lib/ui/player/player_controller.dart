import 'package:audio_session/audio_session.dart';
import 'package:get/get.dart';
import 'package:ohm_pad/model/music_list_model.dart';
import 'package:volume_control/volume_control.dart';
import 'package:ohm_pad/routes/app_pages.dart';
import 'package:ohm_pad/ui/home/general_player_controller.dart';

class PlayerController extends GetxController {
  MusicListModel? music;
  RxDouble volume = 0.5.obs;
  bool isNew = false;

  @override
  void onInit() async{
    super.onInit();
    isNew = Get.arguments["isNew"];
    music = Get.arguments["music"];
    Future.delayed(Duration(seconds: 2), () {
      GeneralPlayerController.of.player.value.play();
    });
    if (isNew) GeneralPlayerController.of.playerListener(isPlay: isNew);
  }

  @override
  void dispose() {
    super.dispose();
  }


  @override
  void onClose() {
    // player.value.dispose();
    super.onClose();
  }

  @override
  void onReady() {
    super.onReady();
    GeneralPlayerController.of.isPlaying.value = true;
    GeneralPlayerController.of.setMusicData(Get.arguments["data"]);
  }

  void playerListener() async{

    final session = await AudioSession.instance;
    await session.configure(AudioSessionConfiguration.speech());


    //Seekbar
    // player.value.positionStream.listen((event) {
    //   position.value = event;
    // });
    // player.value.bufferedPositionStream.listen((event) {
    //   bufferedPosition.value = event;
    // });
    // player.value.durationStream.listen((event) {
    //   duration.value = event!;
    // });

    //volume
    // player.value.volumeStream.listen((event) {
    //   volume.value = event;
    // });
    //
    // //get play/pause/loading/finish(state of song)
    // player.value.playerStateStream.listen((event) {
    //   playing.value = event.playing;
    //   processingState.value = event.processingState;
    /*if(processingState.value == ProcessingState.completed){
        gotoMoodScreen();
      }*/
    //   if(processingState.value == ProcessingState.ready){
    //     print('TAG Ready');
    //     //Future.delayed(Duration(seconds: 5),()=>player.value.play);
    //   }
    // });

    // Listen to errors during playback.
    // player.value.playbackEventStream.listen((event) {},
    //     onError: (Object e, StackTrace stackTrace) {
    //       print('A stream error occurred: $e');
    //     });
    // // Try to load audio from a source and catch any errors.
    // try {
    //   await player.value.setAudioSource(AudioSource.uri(Uri.parse(music!.url!)));
    //   player.value.play();
    // } catch (e) {
    //   print("Error loading audio source: $e");
    // }
  }

  gotoMoodScreen() {
    GeneralPlayerController.of.isPlaying.value = false;
    pausePlayer();

    final map = {"isSong": false, "mood": Get.arguments["data"], "data": music};
    Get.offAndToNamed(Routes.MOOD_SELECTION_SCREEN, arguments: map);
  }

  pausePlayer(){
    // if(player.value.playing)
    //   player.value.pause;
  }

}