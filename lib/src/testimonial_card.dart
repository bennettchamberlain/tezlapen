import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:video_player/video_player.dart';

import '../bloc/product_bloc.dart';
import 'testimonial_video.dart';

class TestimonialCard extends StatefulWidget {
  final int index;
  final testimonial;
  const TestimonialCard(
      {required this.index, required this.testimonial, super.key});

  @override
  State<TestimonialCard> createState() => _TestimonialCardState();
}

class _TestimonialCardState extends State<TestimonialCard> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(16),
      child: Container(
        constraints: BoxConstraints(
          maxWidth: 300,
        ),
        child: InkWell(
          onTap: () {
            BlocProvider.of<ProductBloc>(context)
                .add(GetProductInfoEvent(videoIndex: widget.index + 1));
          },
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                children: [
                  Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.white),
                    child: TestimonialVideo(
                        url: widget.testimonial['testimonialVideo'] as String),
                  ),
                  TextButton(
                      style: TextButton.styleFrom(
                        foregroundColor: MaterialStateColor.resolveWith(
                            (states) => Colors.red),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(0.0),
                        ),
                      ),
                      onPressed: () {
                        BlocProvider.of<ProductBloc>(context).add(
                            GetProductInfoEvent(videoIndex: widget.index + 1));
                      },
                      child: Container(height: 170, width: 300))
                ],
              ),
              SizedBox(height: 8),
              Padding(
                padding: const EdgeInsets.only(left: 4.0),
                child: Text(
                  widget.testimonial['testimonialName'] as String,
                  style: TextStyle(fontSize: 14, color: Colors.white),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
