import 'package:video_player/video_player.dart';

class VideoState {}

class VideoInitialState extends VideoState {}

class VideoInitializedState extends VideoState {
  VideoInitializedState(this.controller);

  final VideoPlayerController controller;
}
