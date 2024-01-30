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
                      enabledBorder: const OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.white),
                      ),
                      focusedBorder: const OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.red),
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 24,
                      ),
                      labelText: 'Testimonial ${i + 1}',
                      labelStyle: const TextStyle(color: Colors.white),
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
                      widget.testimonialUrlControllers.removeAt(i);
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
