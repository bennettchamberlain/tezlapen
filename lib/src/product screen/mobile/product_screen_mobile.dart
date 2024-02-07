import 'package:chewie/chewie.dart';
import 'package:expandable_text/expandable_text.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shimmer/shimmer.dart';
import 'package:tezlapen_v2/app_repository.dart';
import 'package:tezlapen_v2/bloc/product_bloc.dart';
import 'package:tezlapen_v2/bloc/video%20cubit/video_cubit.dart';
import 'package:tezlapen_v2/bloc/video%20cubit/video_state.dart';
import 'package:tezlapen_v2/src/affiliate_link_widget.dart';
import 'package:tezlapen_v2/src/product_info_widget.dart';
import 'package:tezlapen_v2/src/testimonial_card.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:video_player/video_player.dart';
import 'package:vrouter/vrouter.dart';
import 'package:tezlapen_v2/bloc/app_bloc.dart';

class ProductScreenMobile extends StatefulWidget {
  const ProductScreenMobile({super.key});

  @override
  State<ProductScreenMobile> createState() => _ProductScreenMobileState();
}

class _ProductScreenMobileState extends State<ProductScreenMobile> {
  @override
  void initState() {
    super.initState();
    _initProduct();
  }

  Future<void> _initProduct() async {
    try {
      BlocProvider.of<ProductBloc>(context).add(GetProductInfoEvent());
      BlocProvider.of<AppBloc>(context).add(CheckUserStatus());
    } catch (error) {
      print('Error fetching video URL: $error');
    }
  }

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
              double maxheight =
                  550 + productState.product.testimonials.length * 300;

              return SingleChildScrollView(
                child: Container(
                  constraints: BoxConstraints(maxHeight: maxheight),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const SizedBox(height: 20),
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            color: Colors.black,
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
                          const SizedBox(height: 15),
                          Text(
                            productState.product.productName,
                            style: const TextStyle(
                              fontSize: 28,
                              color: Colors.white,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          const SizedBox(height: 5),
                          ExpandableText(
                            productState.product.description,
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
                            padding: const EdgeInsets.only(top: 16, right: 20),
                            child: Align(
                              alignment: Alignment.center,
                              child: FloatingActionButton.extended(
                                backgroundColor:
                                    const Color.fromARGB(255, 232, 33, 39),
                                onPressed: () async {
                                  BlocProvider.of<VideoCubit>(context)
                                      .emit(VideoInitialState());

                                  context.vRouter.to('/paymentform');
                                },
                                label: Text(
                                  'Buy Now for \$${productState.product.price}',
                                  style: const TextStyle(
                                    fontSize: 24,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 24),
                        ],
                      ),
                      const Divider(),
                      const Text(
                        'Testimonials',
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Expanded(
                        child: BlocBuilder<AppBloc, AppState>(
                          builder: (context, state) {
                            if (state is AffiliateOn) {
                              return SizedBox(
                                child: ListView.builder(
                                  itemCount:
                                      productState.product.affiliate.length,
                                  itemBuilder: (context, index) {
                                    final affiliate =
                                        productState.product.affiliate[index];
                                    return AffiliateLinkWidget(
                                      affiliate: affiliate,
                                    );
                                  },
                                ),
                              );
                            }
                            return Column(
                              children: [
                                for (int i = 0;
                                    i <
                                        productState
                                            .product.testimonials.length;
                                    i++)
                                  TestimonialCard(
                                    index: i,
                                    videoUrl: productState.product
                                        .testimonials[i].testimonialVideo,
                                    testimonialName: productState.product
                                        .testimonials[i].testimonialName,
                                    onTap: () async {
                                      await BlocProvider.of<VideoCubit>(context)
                                          .play(
                                        productState.product.testimonials[i]
                                            .testimonialVideo,
                                      );
                                    },
                                  )
                              ],
                            );

                            // return SizedBox(
                            //   child: ListView.builder(
                            //     itemCount: productState.product.testimonials.length,
                            //     itemBuilder: (context, index) {
                            //       final testimonial =
                            //           productState.product.testimonials[index];
                            //       return TestimonialCard(
                            //         index: index,
                            //         videoUrl: testimonial.testimonialVideo,
                            //         testimonialName: testimonial.testimonialName,
                            //         onTap: () async {
                            //           await BlocProvider.of<VideoCubit>(context)
                            //               .play(
                            //             testimonial.testimonialVideo,
                            //           );
                            //         },
                            //       );
                            //     },
                            //   ),
                            // );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
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
