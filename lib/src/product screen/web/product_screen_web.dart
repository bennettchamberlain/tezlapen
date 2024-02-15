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
import 'package:tezlapen_v2/src/affiliate_link_widget.dart';
import 'package:tezlapen_v2/src/testimonial_card.dart';
import 'package:video_player/video_player.dart';
import 'package:vrouter/vrouter.dart';

import 'package:tezlapen_v2/bloc/app_bloc.dart';

import 'package:tezlapen_v2/src/payment/paypal/paypal_paywall.dart';

class ProductScreenWeb extends StatefulWidget {
  const ProductScreenWeb({super.key});

  @override
  State<ProductScreenWeb> createState() => _ProductScreenWebState();
}

class _ProductScreenWebState extends State<ProductScreenWeb> {
  VideoPlayerController controller =
      VideoPlayerController.networkUrl(Uri.parse(''));
  @override
  void initState() {
    super.initState();
    _initProducts();
  }

  Future<void> _initProducts() async {
    try {
      BlocProvider.of<ProductBloc>(context).add(GetProductInfoEvent());
      BlocProvider.of<AppBloc>(context).add(CheckUserStatus());
      // await
    } catch (error) {
      print('Error fetching video URL: $error');
    }
  }

  bool _paymentLoading = false;
  Future<void> _payWithPayPal(double amount) async {
    BlocProvider.of<VideoCubit>(context).emit(VideoInitialState());
    setState(() {
      _paymentLoading = true;
    });
    await AppRepository()
        .payPalPayment(
      amount,
    )
        .then((paymentResponse) {
      if (paymentResponse.isSuccess) {
        Navigator.push(
          context,
          MaterialPageRoute<void>(
            builder: (context) => PayPalPayWall(
              url: paymentResponse.message,
            ),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(paymentResponse.message),
          ),
        );
      }
    });

    setState(() {
      _paymentLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.only(top: 20, left: 20, right: 20),
        child: BlocBuilder<ProductBloc, ProductState>(
          builder: (context, productState) {
            if (productState is ProductInfoSuccessState) {
              BlocProvider.of<VideoCubit>(context).play(productState.video);

              return Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  SingleChildScrollView(
                    child: SizedBox(
                      width: size.width / 1.8,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            width: size.width - 50,
                            height: size.height / 1.5,
                            child: BlocBuilder<VideoCubit, VideoState>(
                              builder: (context, state) {
                                if (state is VideoInitializedState) {
                                  return Container(
                                    color: Colors.black,
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
                              fontSize: 36,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 5),
                          ExpandableText(
                            productState.product.description,
                            maxLines: 3,
                            expandText: ' Read more',
                            collapseText: ' Read less',
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
                              child: Column(
                                children: [
                                  FloatingActionButton.extended(
                                    backgroundColor:
                                        const Color.fromARGB(255, 232, 33, 39),
                                    onPressed: () {
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
                                  const SizedBox(height: 10),
                                  FloatingActionButton.extended(
                                    backgroundColor:
                                        const Color.fromARGB(255, 54, 97, 228),
                                    onPressed: () => _payWithPayPal(
                                      productState.product.price,
                                    ),
                                    label: _paymentLoading
                                        ? const CircularProgressIndicator()
                                        : const Text(
                                            'Pay via Paypal',
                                            style: TextStyle(
                                              fontSize: 24,
                                              color: Colors.white,
                                            ),
                                          ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(height: 40),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 30),
                  Expanded(
                    child: BlocBuilder<AppBloc, AppState>(
                      builder: (context, state) {
                        if (state is AffiliateOn) {
                          return SizedBox(
                            child: ListView.builder(
                              itemCount: productState.product.affiliate.length,
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

                        return SizedBox(
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
                                  await BlocProvider.of<VideoCubit>(context)
                                      .play(
                                    testimonial.testimonialVideo,
                                  );
                                },
                              );
                            },
                          ),
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
