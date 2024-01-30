import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:tezlapen_v2/src/ChangeProduct/testimonials_form.dart';

import '../affiliate_link_form.dart';

class AddProductForm extends StatefulWidget {
  const AddProductForm({super.key});

  @override
  _AddProductFormState createState() => _AddProductFormState();
}

class _AddProductFormState extends State<AddProductForm> {
  final TextEditingController _productNameController = TextEditingController();
  final TextEditingController _productDescriptionController =
      TextEditingController();
  final TextEditingController _pricecontroller = TextEditingController();
  final List<TextEditingController> testimonialNamesControllers = [
    TextEditingController(),
  ];
  final List<TextEditingController> testimonialUrlsControllers = [
    TextEditingController(),
  ];

  final List<TextEditingController> affiliateNamesControllers = [
    TextEditingController(),
  ];
  final List<TextEditingController> affiliateUrlsControllers = [
    TextEditingController(),
  ];
  final List<TextEditingController> affiliateImagesControllers = [
    TextEditingController(),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(maxWidth: 1000),
      padding: const EdgeInsets.all(20),
      child: Form(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Submitting this form requires you to update product fields. (not affiliate link fields)',
              style: TextStyle(color: Colors.white),
            ),
            SizedBox(height: 5),
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
            TextFormField(
              keyboardType: TextInputType.numberWithOptions(decimal: true),
              inputFormatters: <TextInputFormatter>[
                FilteringTextInputFormatter.allow(RegExp(r'^(\d+)?\.?\d{0,2}'))
              ],
              style: const TextStyle(color: Colors.white),
              controller: _pricecontroller,
              decoration: InputDecoration(
                enabledBorder: const OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.white),
                ),
                focusedBorder: const OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.red),
                ),
                label: const Text(
                  'Product Price',
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
            AffiliateLinkForm(
              affiliateNameControllers: affiliateNamesControllers,
              affiliateUrlControllers: affiliateUrlsControllers,
              affiliateImageUrlControllers: affiliateImagesControllers,
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
                    'price': double.parse(_pricecontroller.text)
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
              child: const Text('Submit Product Content'),
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                final affiliateLinks = <Map>[];
                for (var i = 0; i < testimonialNamesControllers.length; i++) {
                  affiliateLinks.add({
                    'affiliateName': affiliateNamesControllers[i].text,
                    'affiliateUrl': affiliateUrlsControllers[i].text,
                    'affiliateImage': affiliateImagesControllers[i].text
                  });
                }
                FirebaseFirestore.instance
                    .collection('product')
                    .doc('product1')
                    .set(
                  {
                    'affiliate': affiliateLinks,
                  },
                  SetOptions(merge: true),
                );

                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text(
                      'Successfully Uploaded Affiliate Products',
                    ),
                  ),
                );
              },
              child: const Text('Submit Affiliate Products'),
            ),
          ],
        ),
      ),
    );
  }
}
