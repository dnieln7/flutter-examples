import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class PictureSelectorBottomSheet extends StatefulWidget {
  @override
  _PictureSelectorBottomSheetState createState() =>
      _PictureSelectorBottomSheetState();
}

class _PictureSelectorBottomSheetState
    extends State<PictureSelectorBottomSheet> {
  bool working = false;

  File profilePicture;
  String pictureUrl = '';

  @override
  Widget build(BuildContext context) {
    return BottomSheet(
      onClosing: () {},
      builder: (ctx) => SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            AppBar(
              title: Text('Select a picture'),
              leading: IconButton(
                icon: Icon(Icons.close_sharp),
                tooltip: 'Close',
                onPressed: () => Navigator.of(context).pop(''),
              ),
              actions: [
                IconButton(
                  icon: Icon(Icons.photo_camera_sharp),
                  tooltip: 'From camera',
                  onPressed: openCamera,
                ),
                IconButton(
                  icon: Icon(Icons.photo_library_sharp),
                  tooltip: 'From gallery',
                  onPressed: openGallery,
                ),
              ],
            ),
            SizedBox(height: 20),
            CircleAvatar(
              radius: 75,
              child: Text(
                profilePicture == null ? 'PREVIEW' : '',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.black54,
                ),
              ),
              backgroundColor: Theme.of(context).primaryColorLight,
              backgroundImage:
                  profilePicture != null ? FileImage(profilePicture) : null,
            ),
            SizedBox(height: 10),
            if (working)
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: [
                    Center(child: LinearProgressIndicator()),
                    Text(
                      'Loading picture...',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 14, color: Colors.black54),
                    ),
                  ],
                ),
              ),
            // if (!working)
            //   Row(
            //     mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            //     children: [
            //       TextButton.icon(
            //         icon: Icon(Icons.photo_camera_sharp),
            //         label: Text('CAMERA'),
            //         onPressed: openCamera,
            //       ),
            //       TextButton.icon(
            //         icon: Icon(Icons.photo_library_sharp),
            //         label: Text('GALLERY'),
            //         onPressed: openGallery,
            //       ),
            //     ],
            //   ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                TextButton.icon(
                  icon: Icon(Icons.upload_sharp),
                  label: Text('LOAD PICTURE'),
                  onPressed: update,
                ),
                TextButton.icon(
                  icon: Icon(Icons.send_sharp),
                  label: Text('SEND'),
                  onPressed: pictureUrl.isNotEmpty ? sendPicture : null,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future<void> openGallery() async {
    final pickerFile = await ImagePicker().getImage(
      source: ImageSource.gallery,
      imageQuality: 50,
      maxWidth: 500,
    );

    if (pickerFile != null) {
      setState(() {
        profilePicture = File(pickerFile.path);
        pictureUrl = '';
      });
    }
  }

  Future<void> openCamera() async {
    final pickerFile = await ImagePicker().getImage(
      source: ImageSource.camera,
      imageQuality: 50,
      maxWidth: 500,
    );

    if (pickerFile != null) {
      setState(() {
        profilePicture = File(pickerFile.path);
        pictureUrl = '';
      });
    }
  }

  void update() async {
    if (profilePicture != null) {
      setState(() => working = !working);

      final ref = FirebaseStorage.instance
          .ref()
          .child('users')
          .child('chat-images')
          .child('${DateTime.now().millisecondsSinceEpoch}.jpg');

      await ref.putFile(profilePicture).whenComplete(() => {});

      final url = await ref.getDownloadURL();

      setState(() {
        working = false;
        pictureUrl = url;
      });
    }
  }

  void sendPicture() {
    Navigator.of(context).pop(pictureUrl);
  }
}
