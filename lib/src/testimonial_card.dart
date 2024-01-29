// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:tezlapen_v2/bloc/product_bloc.dart';
import 'package:tezlapen_v2/src/testimonial_video.dart';

class TestimonialCard extends StatefulWidget {
  const TestimonialCard({
    required this.index,
    required this.videoUrl,
    required this.testimonialName,
    required this.onTap,
    super.key,
  });
  final int index;
  final String videoUrl;
  final String testimonialName;
  final Function() onTap;

  @override
  State<TestimonialCard> createState() => _TestimonialCardState();
}

class _TestimonialCardState extends State<TestimonialCard> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: GestureDetector(
        onTap: widget.onTap,
        child: Container(
          // constraints: const BoxConstraints(
          //   maxWidth: 300,
          // ),

          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.white,
                    ),
                    child: TestimonialVideo(
                      url: widget.videoUrl,
                    ),
                  ),
                  // TextButton(
                  //   style: TextButton.styleFrom(
                  //     foregroundColor: MaterialStateColor.resolveWith(
                  //       (states) => Colors.red,
                  //     ),
                  //     shape: RoundedRectangleBorder(
                  //       borderRadius: BorderRadius.circular(0),
                  //     ),
                  //   ),
                  //   onPressed: () {
                  //     // BlocProvider.of<ProductBloc>(context).add(
                  //     //   ChangeVideo(widget.videoUrl),
                  //     // );
                  //    // play(widget.videoUrl);
                  //   },
                  //   child: const SizedBox(height: 170, width: 300),
                  // ),
                ],
              ),
              const SizedBox(height: 8),
              Padding(
                padding: const EdgeInsets.only(left: 4),
                child: Text(
                  widget.testimonialName,
                  style: const TextStyle(fontSize: 14, color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
