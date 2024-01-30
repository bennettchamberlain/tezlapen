import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tezlapen_v2/bloc/product_bloc.dart';
import 'package:video_player/video_player.dart';

import '../bloc/video cubit/video_cubit.dart';

class TestimonialVideo extends StatefulWidget {
  const TestimonialVideo({required this.url, super.key});
  final String url;

  @override
  _TestimonialVideoState createState() => _TestimonialVideoState();
}

class _TestimonialVideoState extends State<TestimonialVideo> {
  late VideoPlayerController _controller;
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
      final videoUrl = widget.url;

      // Initialize the VideoPlayerController with the retrieved URL
      _controller = VideoPlayerController.networkUrl(Uri.parse(videoUrl));

      // Add listener to update the state when the video is initialized
      _controller.addListener(() {
        if (_controller.value.isInitialized) {
          setState(() {
            _isVideoLoading = false;
          });
        }
      });

      // Initialize the video player
      await _controller.initialize();
    } catch (error) {
      print('Error fetching video URL: $error');
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProductBloc, ProductState>(
      builder: (context, state) {
        return Container(
          constraints: const BoxConstraints(maxWidth: 300, minHeight: 160),
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(10)),
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
                      constraints: BoxConstraints(
                          maxHeight: _controller.value.size.height),
                      child: AspectRatio(
                        aspectRatio: _controller.value.aspectRatio,
                        //_controller.value.aspectRatio,
                        child: Chewie(
                          controller: ChewieController(
                            materialProgressColors: ChewieProgressColors(
                              handleColor:
                                  const Color.fromARGB(255, 255, 255, 255),
                              playedColor: Colors.red,
                              bufferedColor: Colors.red.shade100,
                            ),
                            showControls: false,
                            videoPlayerController: _controller,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
        );
      },
    );
  }
}
