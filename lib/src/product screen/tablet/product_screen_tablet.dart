import 'package:chewie/chewie.dart';
import 'package:expandable_text/expandable_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shimmer/shimmer.dart';
import 'package:tezlapen_v2/app_repository.dart';
import 'package:tezlapen_v2/bloc/product_bloc.dart';
import 'package:tezlapen_v2/bloc/video%20cubit/video_cubit.dart';
import 'package:tezlapen_v2/bloc/video%20cubit/video_state.dart';

import 'package:tezlapen_v2/src/testimonial_card.dart';
import 'package:vrouter/vrouter.dart';

class ProductScreenTablet extends StatefulWidget {
  const ProductScreenTablet({super.key});

  @override
  State<ProductScreenTablet> createState() => _ProductScreenTabletState();
}

class _ProductScreenTabletState extends State<ProductScreenTablet> {
  @override
  void initState() {
    super.initState();
    _initVideoPlayer();
  }

  Future<void> _initVideoPlayer() async {
    try {
      BlocProvider.of<ProductBloc>(context).add(GetProductInfoEvent());
    } catch (error) {
      print('Error fetching video URL: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.only(top: 30, left: 20, right: 20),
        child: BlocBuilder<ProductBloc, ProductState>(
          builder: (context, productState) {
            if (productState is ProductInfoSuccessState) {
              BlocProvider.of<VideoCubit>(context).play(productState.video);

              return Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  SizedBox(
                    width: size.width / 1.8,
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            color: Colors.black,
                            width: size.width - 50,
                            height: size.height / 1.5,
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
                                          videoPlayerController:
                                              state.controller,
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
                            style: const TextStyle(
                              fontSize: 23,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 5),
                          ExpandableText(
                            productState.product.description,
                            maxLines: 3,
                            expandText: 'Read more',
                            collapseText: 'Read less',
                            linkColor: Colors.red,
                            style: const TextStyle(
                              fontSize: 16,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 10),
                          Padding(
                            padding: const EdgeInsets.only(right: 20),
                            child: Align(
                              alignment: Alignment.centerRight,
                              child: FloatingActionButton.extended(
                                backgroundColor:
                                    const Color.fromARGB(255, 232, 33, 39),
                                onPressed: () async {
                                  BlocProvider.of<VideoCubit>(context)
                                      .emit(VideoInitialState());
                                  final sessionId = await AppRepository()
                                      .customerPaymentInfo();
                                  Future.delayed(
                                    const Duration(seconds: 1),
                                    () {
                                      context.vRouter.to('/payment/$sessionId');
                                    },
                                  );
                                },
                                label: Text(
                                  'Buy ssNow for \$${productState.product.price}',
                                  style: const TextStyle(
                                    fontSize: 24,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 40),
                  Expanded(
                    child: SizedBox(
                      child: ListView.builder(
                      itemCount: productState.product.testimonials.length,
                      itemBuilder: (context, index) {
                        final testimonial =
                            productState.product.testimonials[index];
                        return TestimonialCard(
                          index: index,
                          videoUrl: testimonial.testimonialVideo,
                          testimonialName: testimonial.testimonialName,
                          onTap: () async {
                            await BlocProvider.of<VideoCubit>(context).play(
                              testimonial.testimonialVideo,
                            );
                          },
                        );
                      },
                    ),
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
