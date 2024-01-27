import 'package:file_picker/file_picker.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tezlapen_v2/bloc/product_bloc.dart';

class TestimonialVideoUploadWidget extends StatefulWidget {
  const TestimonialVideoUploadWidget({required this.videoUrl, super.key});

  final TextEditingController videoUrl;
  @override
  _TestimonialVideoUploadWidgetState createState() =>
      _TestimonialVideoUploadWidgetState();
}

class _TestimonialVideoUploadWidgetState
    extends State<TestimonialVideoUploadWidget> {
  PlatformFile? _selectedVideo;
  double _uploadProgress = 0;

  Future<void> _uploadVideo() async {
    if (_selectedVideo == null) {
      return;
    }

    try {
      // Initialize Firebase (replace with your own initialization)
      await Firebase.initializeApp();

      // Replace 'videos' with your actual Firebase Storage path
      final storageReference = FirebaseStorage.instance
          .ref()
          .child('videos/${DateTime.now().millisecondsSinceEpoch}.mp4');

      final task = storageReference.putData(
        _selectedVideo!.bytes!,
        SettableMetadata(contentType: 'video/${_selectedVideo!.extension}'),
      );

      task.snapshotEvents.listen((TaskSnapshot snapshot) {
        setState(() {
          _uploadProgress =
              (snapshot.bytesTransferred / snapshot.totalBytes) * 100;
        });

        // Get the download URL once the upload is complete
      });

      await task;

      final downloadUrl = await (await task).ref.getDownloadURL();
      widget.videoUrl.text = downloadUrl;
      //UPLOAD THE URL TO FIREBASE
      // BlocProvider.of<ProductBloc>(context).add(
      //   UploadUrlToFirestoreEvent(
      //     dataName: 'videoUrl',
      //     dataValue: downloadUrl,
      //   ),
      // );
    } catch (error) {
      print('Error uploading video: $error');
    }
  }

  Future<void> _pickVideo() async {
    final result = await FilePicker.platform.pickFiles(type: FileType.video);

    if (result != null) {
      setState(() {
        _selectedVideo = result.files.first;
        _uploadProgress = 0.0;
      });

      // Start uploading the video
      await _uploadVideo();
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _pickVideo,
      child: Container(
        width: 200,
        height: 100,
        decoration: BoxDecoration(
          color: Colors.grey,
          borderRadius: BorderRadius.circular(20),
        ),
        child: BlocBuilder<ProductBloc, ProductState>(
          builder: (context, state) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.upload,
                  size: 20,
                  color: Colors.white,
                ),
                const SizedBox(height: 10),
                if (_uploadProgress > 0 && _uploadProgress < 100)
                  Padding(
                    padding: const EdgeInsets.all(8),
                    child: LinearProgressIndicator(
                      value: _uploadProgress / 100,
                      minHeight: 10,
                      backgroundColor: Colors.white,
                      valueColor: const AlwaysStoppedAnimation<Color>(
                        Colors.red,
                      ),
                    ),
                  ),
              ],
            );
          },
        ),
      ),
    );
  }
}
