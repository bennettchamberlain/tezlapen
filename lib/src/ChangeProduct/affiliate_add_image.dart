import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

class PhotoContainer extends StatefulWidget {
  TextEditingController url;
  PhotoContainer({required this.url, super.key});

  @override
  _PhotoContainerState createState() => _PhotoContainerState();
}

class _PhotoContainerState extends State<PhotoContainer> {
  final List<PlatformFile?> _photos = [];

  Future<void> _pickImages() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.image,
    );
    if (result != null) {
      _photos.addAll(result.files.map((file) => file));
      final storageReference = FirebaseStorage.instance
          .ref()
          .child('images/${DateTime.now().millisecondsSinceEpoch}');

      final task = storageReference.putData(
        _photos.first!.bytes!,
        SettableMetadata(contentType: 'image/${_photos.first!.extension}'),
      );
      await task;

      final downloadUrl = await (await task).ref.getDownloadURL();
      widget.url.text = downloadUrl;
    } else {
      // handle user cancel?
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _pickImages,
      child: Container(
        padding: const EdgeInsets.only(left: 20, right: 20, top: 4, bottom: 2),
        width: 200,
        height: 100,
        decoration: BoxDecoration(
            color: Colors.grey,
            borderRadius: const BorderRadius.all(Radius.circular(30))),
        child: _photos.isEmpty
            ? const Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Center(
                    child: Icon(Icons.upload, color: Colors.white),
                  ),
                  Center(
                    child: Text(
                      'Upload Photos',
                      style: TextStyle(fontSize: 16.0, color: Colors.white),
                    ),
                  ),
                ],
              )
            : GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 1,
                  crossAxisSpacing: 10.0,
                ),
                itemCount: _photos.length,
                itemBuilder: (context, index) {
                  if (_photos[index]!.bytes != null) {
                    return Padding(
                      padding: const EdgeInsets.only(top: 18.0, bottom: 10),
                      child: ClipRRect(
                        clipBehavior: Clip.hardEdge,
                        borderRadius: BorderRadius.circular(10),
                        child: Image.memory(
                          _photos[index]!.bytes!,
                          fit: BoxFit.cover,
                        ),
                      ),
                    );
                  }
                  return null;
                },
              ),
      ),
    );
  }
}
