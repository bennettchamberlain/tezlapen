import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tezlapen_v2/bloc/video%20cubit/video_state.dart';
import 'package:video_player/video_player.dart';

class VideoCubit extends Cubit<VideoState>{
  VideoCubit() : super(VideoInitialState());

  Future<void> play(String videoUrl) async {
    emit(VideoInitialState());
    if (videoUrl.isEmpty) return;
    final videoController = VideoPlayerController.networkUrl(Uri.parse(videoUrl));
    if (videoController.value.isInitialized) {
      await videoController.dispose();
    }
    await videoController.setVolume(0);
     await videoController.initialize().then((value) async{
     await  videoController.play();
    await  videoController.setVolume(100);
    });
    emit(VideoInitializedState(videoController));
  }

    
}
