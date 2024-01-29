import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'package:tezlapen_v2/src/ChangeProduct/testimonials_form.dart';

class AddProductForm extends StatefulWidget {
  const AddProductForm({super.key});

  @override
  _AddProductFormState createState() => _AddProductFormState();
}

class _AddProductFormState extends State<AddProductForm> {
  final TextEditingController _productNameController = TextEditingController();
  final TextEditingController _productDescriptionController =
      TextEditingController();
  final List<TextEditingController> testimonialNamesControllers = [
    TextEditingController(),
  ];
  final List<TextEditingController> testimonialUrlsControllers = [
    TextEditingController(),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(maxWidth: 600),
      padding: const EdgeInsets.all(20),
      child: Form(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              controller: _productNameController,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                enabledBorder: const OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.white),
                ),
                focusedBorder: const OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.red),
                ),
                label: const Text(
                  'Product Name',
                  style: TextStyle(color: Colors.white),
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            const SizedBox(height: 20),
            TextFormField(
              style: const TextStyle(color: Colors.white),
              maxLines: 4,
              controller: _productDescriptionController,
              decoration: InputDecoration(
                enabledBorder: const OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.white),
                ),
                focusedBorder: const OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.red),
                ),
                label: const Text(
                  'Product Description',
                  style: TextStyle(color: Colors.white),
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            const SizedBox(height: 20),
            TestimonialsForm(
              testimonialNameControllers: testimonialNamesControllers,
              testimonialUrlControllers: testimonialUrlsControllers,
            ),
            ElevatedButton(
              onPressed: () {
                final testimonials = <Map>[];
                for (var i = 0; i < testimonialNamesControllers.length; i++) {
                  testimonials.add({
                    'testimonialName': testimonialNamesControllers[i].text,
                    'testimonialVideo': testimonialUrlsControllers[i].text,
                  });
                }
                FirebaseFirestore.instance
                    .collection('product')
                    .doc('product1')
                    .set(
                  {
                    'productName': _productNameController.text,
                    'description': _productDescriptionController.text,
                    'testimonials': testimonials,
                    'affiliate': [
                      {'hello': 'hello'},
                    ],
                  },
                  SetOptions(merge: true),
                );

                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text(
                      'Successfully Uploaded Product Content',
                    ),
                  ),
                );
              },
              child: const Text('Submit'),
            ),
          ],
        ),
      ),
    );
  }
}
