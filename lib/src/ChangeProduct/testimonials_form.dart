import 'package:flutter/material.dart';
import 'package:tezlapen_v2/src/ChangeProduct/testimonial_video_upload_widget.dart';

class TestimonialsForm extends StatefulWidget {
  TestimonialsForm({
    required this.testimonialNameControllers,
    required this.testimonialUrlControllers,
    super.key,
  });
  List<TextEditingController> testimonialNameControllers;
  List<TextEditingController> testimonialUrlControllers;

  @override
  _TestimonialsFormState createState() => _TestimonialsFormState();
}

class _TestimonialsFormState extends State<TestimonialsForm> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Text('Editing the testimonials Section will require you to upload all testimonials again', style: TextStyle(color: Colors.white),),
        for (int i = 0; i < widget.testimonialNameControllers.length; i++)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Row(
              children: [
                Expanded(
                  flex: 3,
                  child: TextFormField(
                    style: const TextStyle(color: Colors.white),
                    maxLines: 3,
                    controller: widget.testimonialNameControllers[i],
                    decoration: InputDecoration(
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 24,
                      ),
                      labelText: 'Testimonial ${i + 1}',
                      labelStyle: const TextStyle(color: Colors.white),
                      border: const OutlineInputBorder(
                        borderSide: BorderSide(width: 3),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 4),
                Expanded(
                  child: TestimonialVideoUploadWidget(
                    videoUrl: widget.testimonialUrlControllers[i],
                  ),
                ),
                const SizedBox(width: 4),
                IconButton(
                  icon: const Icon(Icons.clear, color: Colors.red),
                  onPressed: () {
                    setState(() {
                      widget.testimonialNameControllers.removeAt(i);
                    });
                  },
                ),
              ],
            ),
          ),
        const SizedBox(height: 16),
        Align(
          alignment: Alignment.centerLeft,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            onPressed: () {
              setState(() {
                widget.testimonialNameControllers.add(TextEditingController());
                widget.testimonialUrlControllers.add(TextEditingController());
              });
            },
            child: const Text('Add Testimonial'),
          ),
        ),
        const SizedBox(height: 16),
      ],
    );
  }
}
