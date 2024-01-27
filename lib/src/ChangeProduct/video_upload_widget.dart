import 'package:file_picker/file_picker.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tezlapen_v2/bloc/product_bloc.dart';

class VideoUploadWidget extends StatefulWidget {
  const VideoUploadWidget({super.key});

  @override
  _VideoUploadWidgetState createState() => _VideoUploadWidgetState();
}

class _VideoUploadWidgetState extends State<VideoUploadWidget> {
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

      //UPLOAD THE URL TO FIREBASE
      BlocProvider.of<ProductBloc>(context).add(
        UploadUrlToFirestoreEvent(
          dataName: 'videoUrl',
          dataValue: downloadUrl,
        ),
      );
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
        width: 400,
        height: 200,
        decoration: BoxDecoration(
          color: Colors.grey,
          borderRadius: BorderRadius.circular(20),
        ),
        child: BlocBuilder<ProductBloc, ProductState>(
          builder: (context, state) {
            if (state is UploadSuccessState) {
              return const Center(
                child: Text(
                  'Video Uploaded Successfully',
                  style: TextStyle(fontSize: 20),
                ),
              );
            } else {
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.upload,
                    size: 50,
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
            }
          },
        ),
      ),
    );
  }
}
