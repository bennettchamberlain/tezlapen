import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shimmer/shimmer.dart';
import 'package:tezlapen_v2/bloc/product_bloc.dart';
import 'package:tezlapen_v2/src/video_widget.dart';
import 'package:video_player/video_player.dart';

class ProductInfoWidget extends StatefulWidget {
  const ProductInfoWidget({super.key});

  @override
  State<ProductInfoWidget> createState() => _ProductInfoWidgetState();
}

class _ProductInfoWidgetState extends State<ProductInfoWidget> {
  @override
  void initState() {
    BlocProvider.of<ProductBloc>(context)
        .add(GetProductInfoEvent(videoIndex: 0));

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProductBloc, ProductState>(
      builder: (context, state) {
        if (state is ProductInfoSuccessState) {
          final VideoPlayerController vidController =
              VideoPlayerController.networkUrl(
                  Uri.parse(state.product.videoUrl));
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                constraints: BoxConstraints(maxHeight: 450),
                child: VideoPlayerWidget(
                  controller: vidController,
                  url: state.product.videoUrl,
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4),
                child: Text(
                  state.product.productName,
                  style: TextStyle(color: Colors.white, fontSize: 35),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Container(
                  constraints: BoxConstraints(maxWidth: 750),
                  child: Text(
                    state.product.description,
                    style: TextStyle(color: Colors.white, fontSize: 18),
                  ),
                ),
              ),
            ],
          );
        } else if (state is ProductInfoRebuildState) {
          final VideoPlayerController vidController =
              VideoPlayerController.networkUrl(Uri.parse(state.video));
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                constraints: BoxConstraints(maxHeight: 450),
                child: VideoPlayerWidget(
                  controller: vidController,
                  url: state.video,
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4),
                child: Text(
                  state.product.productName,
                  style: TextStyle(color: Colors.white, fontSize: 35),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Container(
                  constraints: BoxConstraints(maxWidth: 750),
                  child: Text(
                    state.product.description,
                    style: TextStyle(color: Colors.white, fontSize: 18),
                  ),
                ),
              ),
            ],
          );
        } else {
          return Column(
            children: [
              const SizedBox(height: 200),
              SizedBox(
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
            ],
          );
        }
      },
    );
  }
}
