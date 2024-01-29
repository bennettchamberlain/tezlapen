import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tezlapen_v2/bloc/product_bloc.dart';
import 'package:video_player/video_player.dart';

class VideoPlayerWidget extends StatefulWidget {
  const VideoPlayerWidget({
    required this.controller,
    required this.url,
    super.key,
  });
  final VideoPlayerController controller;
  final String url;

  @override
  _VideoPlayerWidgetState createState() => _VideoPlayerWidgetState();
}

class _VideoPlayerWidgetState extends State<VideoPlayerWidget> {
  bool _isVideoLoading = true;

  @override
  void initState() {
    super.initState();
    _initVideoPlayer();
  }

  Future<void> _initVideoPlayer() async {
    // Reference to the Firestore document

    try {
      // Get the video URL from Firestore

      // Initialize the VideoPlayerController with the retrieved URL
      //_controller = VideoPlayerController.networkUrl(Uri.parse(videoUrl));

      // Add listener to update the state when the video is initialized
      widget.controller.addListener(() {
        if (widget.controller.value.isInitialized) {
          setState(() {
            _isVideoLoading = false;
          });
        }
      });

      // Initialize the video player
      await widget.controller.initialize();
      await widget.controller.setVolume(0);
      await widget.controller.play();

      await widget.controller.setVolume(100);
    } catch (error) {
      print('Error fetching video URL: $error');
    }
  }

  @override
  void dispose() {
    widget.controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProductBloc, ProductState>(
      builder: (context, state) {
        if (state is ProductInfoSuccessState) {
          return Container(
            //  constraints: const BoxConstraints(maxHeight: 563, maxWidth: 1000),
            child: _isVideoLoading
                ? const Center(
                    child: CircularProgressIndicator(
                      color: Colors.red,
                    ),
                  )
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        // constraints: const BoxConstraints(maxHeight: 450),
                        child: AspectRatio(
                          //aspectRatio: widget.controller.value.aspectRatio,
                          aspectRatio: widget.controller.value.aspectRatio,
                          child: Chewie(
                            controller: ChewieController(
                              allowedScreenSleep: false,
                              materialProgressColors: ChewieProgressColors(
                                handleColor:
                                    const Color.fromARGB(255, 255, 255, 255),
                                playedColor: Colors.red,
                                bufferedColor: Colors.red.shade100,
                              ),
                              hideControlsTimer: const Duration(seconds: 1),
                              showControlsOnInitialize: false,
                              videoPlayerController: widget.controller,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
          );
        } else {
          return Container(
            // constraints: const BoxConstraints(maxHeight: 563, maxWidth: 1000),
            child: _isVideoLoading
                ? const Center(
                    child: CircularProgressIndicator(
                      color: Colors.red,
                    ),
                  )
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        // constraints: const BoxConstraints(maxHeight: 450),
                        child: AspectRatio(
                          //aspectRatio: widget.controller.value.aspectRatio,
                          aspectRatio: widget.controller.value.aspectRatio,
                          child: Chewie(
                            controller: ChewieController(
                              allowedScreenSleep: false,
                              materialProgressColors: ChewieProgressColors(
                                handleColor:
                                    const Color.fromARGB(255, 255, 255, 255),
                                playedColor: Colors.red,
                                bufferedColor: Colors.red.shade100,
                              ),
                              hideControlsTimer: const Duration(seconds: 1),
                              showControlsOnInitialize: false,
                              videoPlayerController: widget.controller,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
          );
        }
      },
    );
  }
}
