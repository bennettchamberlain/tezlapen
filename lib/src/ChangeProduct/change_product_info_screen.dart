import 'package:flutter/material.dart';
import 'package:tezlapen_v2/src/ChangeProduct/add_product_form.dart';
import 'package:tezlapen_v2/src/ChangeProduct/video_upload_widget.dart';
import 'package:vrouter/vrouter.dart';

class ChangeProductInfoScreen extends StatefulWidget {
  const ChangeProductInfoScreen({super.key});

  @override
  State<ChangeProductInfoScreen> createState() =>
      _ChangeProductInfoScreenState();
}

class _ChangeProductInfoScreenState extends State<ChangeProductInfoScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.home),
          onPressed: () {
            context.vRouter.to('/');
          },
        ),
        title: const Text('Change Product'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(width: MediaQuery.of(context).size.width, height: 16),
            const VideoUploadWidget(),
            const AddProductForm(),
          ],
        ),
      ),
    );
  }
}
