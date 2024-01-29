import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shimmer/shimmer.dart';
import 'package:tezlapen_v2/app_repository.dart';
import 'package:tezlapen_v2/bloc/product_bloc.dart';
import 'package:tezlapen_v2/bloc/video%20cubit/video_cubit.dart';
import 'package:tezlapen_v2/bloc/video%20cubit/video_state.dart';
import 'package:tezlapen_v2/src/affiliate_link_widget.dart';
import 'package:tezlapen_v2/src/product_info_widget.dart';
import 'package:tezlapen_v2/src/testimonial_card.dart';
import 'package:video_player/video_player.dart';

class ProductScreenMobile extends StatefulWidget {
  const ProductScreenMobile({super.key});

  @override
  State<ProductScreenMobile> createState() => _ProductScreenMobileState();
}

class _ProductScreenMobileState extends State<ProductScreenMobile> {
  @override
  void initState() {
    super.initState();
    _initVideoPlayer();
  }

  Future<void> _initVideoPlayer() async {
    try {
      BlocProvider.of<ProductBloc>(context).add(GetProductInfoEvent());
      // await
    } catch (error) {
      print('Error fetching video URL: $error');
    }
  }


  int playerIndex = 0;
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: BlocBuilder<ProductBloc, ProductState>(
          builder: (context, productState) {
            if (productState is ProductInfoSuccessState) {
              BlocProvider.of<VideoCubit>(context).play(productState.video);
              return Column(
                children: [
                  const SizedBox(height: 20),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        width: size.width - 50,
                        height: size.height / 2.8,
                        child: BlocBuilder<VideoCubit, VideoState>(
                          builder: (context, state) {
                            if (state is VideoInitializedState) {
                            
                              return SizedBox(
                                width: MediaQuery.of(context).size.width,
                                child: AspectRatio(
                                  aspectRatio:
                                      state.controller.value.aspectRatio,
                                  child: Chewie(
                                    controller: ChewieController(
                                      allowedScreenSleep: false,
                                      materialProgressColors:
                                          ChewieProgressColors(
                                        handleColor: const Color.fromARGB(
                                          255,
                                          255,
                                          255,
                                          255,
                                        ),
                                        playedColor: Colors.red,
                                        bufferedColor: Colors.red.shade100,
                                      ),
                                      hideControlsTimer:
                                          const Duration(seconds: 1),
                                      showControlsOnInitialize: false,
                                      videoPlayerController: state.controller,
                                    ),
                                  ),
                                ),
                              );
                            } else if (state is VideoInitialState) {
                              return const Center(
                                child: CircularProgressIndicator(
                                  color: Colors.red,
                                ),
                              );
                            } else {
                              return const SizedBox();
                            }
                          },
                        ),
                      ),
                      Text(
                        productState.product.productName,
                        style:
                            const TextStyle(fontSize: 20, color: Colors.white),
                      ),
                      Text(
                        productState.product.description,
                        style:
                            const TextStyle(fontSize: 16, color: Colors.white),
                      ),
                    ],
                  ),
                  Expanded(
                    child: ListView.builder(
                      itemCount: productState.product.testimonials.length,
                      itemBuilder: (context, index) {
                        return TestimonialCard(
                          index: index,
                          videoUrl: productState.product.testimonials[index]
                              ['testimonialVideo'] as String,
                          testimonialName: productState.product
                              .testimonials[index]['testimonialName'] as String,
                          onTap: () async {
                            await BlocProvider.of<VideoCubit>(context).play(
                              productState.product.testimonials[index]
                                  ['testimonialVideo'] as String,
                            );
                          },
                        );
                      },
                    ),
                  ),
                ],
              );
            } else if (productState is ProductInitial) {
              return Center(
                child: SizedBox(
                  height: MediaQuery.of(context).size.height,
                  width: MediaQuery.of(context).size.width,
                  child: Shimmer.fromColors(
                    baseColor: const Color.fromARGB(255, 232, 33, 39),
                    highlightColor: const Color.fromARGB(255, 222, 222, 222),
                    child: const Text(
                      'TezlaPen',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 80,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              );
            } else {
              return Center(
                child: Column(
                  children: [
                    const Text('Could not get products'),
                    const SizedBox(height: 20),
                    TextButton(
                      onPressed: () => BlocProvider.of<ProductBloc>(context)
                          .add(GetProductInfoEvent()),
                      child: const Text('Try Again'),
                    ),
                  ],
                ),
              );
            }
          },
        ),
      ),
    );
  }
}
