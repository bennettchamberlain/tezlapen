import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shimmer/shimmer.dart';
import 'package:tezlapen_v2/bloc/app_bloc.dart';
import 'package:tezlapen_v2/src/affiliate_link_widget.dart';
import 'package:tezlapen_v2/src/product_info_widget.dart';
import 'package:tezlapen_v2/src/testimonials_widget.dart';

class ProductScreen extends StatefulWidget {
  const ProductScreen({super.key});

  @override
  State<ProductScreen> createState() => _ProductScreenState();
}

class _ProductScreenState extends State<ProductScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: BlocBuilder<AppBloc, AppState>(
          builder: (context, state) {
            if (state is NewUserSignedInState && state.affiliateLinksOn) {
              return const Row(
                children: [
                  Column(
                    children: [
                      ProductInfoWidget(),
                    ],
                  ),
                  //AFFILIATE LINKS ARE ON AND TESTIMONIALS ARE OFF
                  AffiliateLinkWidget(),
                ],
              );
            } else if (state is NewUserSignedInState &&
                !state.affiliateLinksOn) {
              return Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    constraints: BoxConstraints(
                      maxWidth: MediaQuery.of(context).size.width / 3 * 2,
                    ),
                    child: const Column(
                      children: [
                        ProductInfoWidget(),
                      ],
                    ),
                  ),
                  //AFFILIATE LINKS ARE OFF AND TESTIMONIALS ARE ON
                  const TestimonialsWidget(),
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
        ),
      ),
    );
  }
}
