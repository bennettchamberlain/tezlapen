import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tezlapen_v2/bloc/product_bloc.dart';

import 'testimonial_card.dart';

class TestimonialsWidget extends StatefulWidget {
  const TestimonialsWidget({super.key});

  @override
  State<TestimonialsWidget> createState() => _TestimonialsWidgetState();
}

class _TestimonialsWidgetState extends State<TestimonialsWidget> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProductBloc, ProductState>(
      builder: (context, state) {
        if (state is ProductInfoSuccessState) {
          final List testimonials = state.product.testimonials;
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 16.0, left: 16),
                child: Text(
                  'Testimonials',
                  style: TextStyle(color: Colors.white, fontSize: 20),
                ),
              ),
              //SizedBox(height: 20),
              for (int i = 0; i < testimonials.length; i++)
                TestimonialCard(testimonial: testimonials[i], index: i)
            ],
          );
        } else if (state is ProductInfoRebuildState) {
          final List testimonials = state.product.testimonials;
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 16.0, left: 16),
                child: Text(
                  'Testimonials',
                  style: TextStyle(color: Colors.white, fontSize: 20),
                ),
              ),
              //SizedBox(height: 20),
              for (int i = 0; i < testimonials.length; i++)
                TestimonialCard(testimonial: testimonials[i], index: i)
            ],
          );
        } else {
          return Container();
        }
      },
    );
  }
}
