import 'package:flutter/material.dart';
import 'package:tezlapen_v2/src/ChangeProduct/affiliate_add_image.dart';
import 'package:tezlapen_v2/src/ChangeProduct/testimonial_video_upload_widget.dart';

class AffiliateLinkForm extends StatefulWidget {
  AffiliateLinkForm({
    required this.affiliateNameControllers,
    required this.affiliateUrlControllers,
    required this.affiliateImageUrlControllers,
    super.key,
  });
  List<TextEditingController> affiliateNameControllers;
  List<TextEditingController> affiliateUrlControllers;
  List<TextEditingController> affiliateImageUrlControllers;

  @override
  _AffiliateLinkFormState createState() => _AffiliateLinkFormState();
}

class _AffiliateLinkFormState extends State<AffiliateLinkForm> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        for (int i = 0; i < widget.affiliateNameControllers.length; i++)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Row(
              children: [
                Expanded(
                  flex: 2,
                  child: TextFormField(
                    style: const TextStyle(color: Colors.white),
                    maxLines: 1,
                    controller: widget.affiliateNameControllers[i],
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
                      labelText: 'Affiliate Product Name ${i + 1}',
                      labelStyle: const TextStyle(color: Colors.white),
                    ),
                  ),
                ),
                const SizedBox(width: 4),
                Expanded(
                  flex: 2,
                  child: TextFormField(
                    style: const TextStyle(color: Colors.white),
                    maxLines: 1,
                    controller: widget.affiliateUrlControllers[i],
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
                      labelText: 'Affiliate Product URL ${i + 1}',
                      labelStyle: const TextStyle(color: Colors.white),
                    ),
                  ),
                ),
                const SizedBox(width: 4),
                PhotoContainer(url: widget.affiliateImageUrlControllers[i]),
                const SizedBox(width: 4),
                IconButton(
                  icon: const Icon(Icons.clear, color: Colors.red),
                  onPressed: () {
                    setState(() {
                      widget.affiliateNameControllers.removeAt(i);
                      widget.affiliateUrlControllers.removeAt(i);
                      widget.affiliateImageUrlControllers.removeAt(i);
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
                widget.affiliateNameControllers.add(TextEditingController());
                widget.affiliateUrlControllers.add(TextEditingController());
                widget.affiliateImageUrlControllers
                    .add(TextEditingController());
              });
            },
            child: const Text('Add Affiliate Product'),
          ),
        ),
        const SizedBox(height: 16),
      ],
    );
  }
}
