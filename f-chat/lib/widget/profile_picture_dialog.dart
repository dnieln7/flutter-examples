import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ProfilePictureDialog extends StatefulWidget {
  @override
  _ProfilePictureDialogState createState() => _ProfilePictureDialogState();
}

class _ProfilePictureDialogState extends State<ProfilePictureDialog> {
  bool working = false;

  File profilePicture;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Padding(
        padding: EdgeInsets.only(top: 15, bottom: 20, left: 20, right: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          children: [
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  Text(
                    'Change profile picture',
                    style: TextStyle(fontSize: 20),
                  ),
                  IconButton(
                    icon: Icon(Icons.close_sharp),
                    onPressed: Navigator.of(context).pop,
                  ),
                ],
              ),
            ),
            SizedBox(height: 10),
            CircleAvatar(
              radius: 100,
              child: Text(
                profilePicture == null ? 'PROFILE PICTURE' : '',
                style: TextStyle(fontSize: 14, color: Colors.white),
              ),
              backgroundColor: Theme.of(context).primaryColor,
              backgroundImage:
                  profilePicture != null ? FileImage(profilePicture) : null,
            ),
            SizedBox(height: 10),
            if (working) Center(child: CircularProgressIndicator()),
            if (!working)
              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  TextButton.icon(
                    icon: Icon(Icons.camera_sharp),
                    label: Text('TAKE PICTURE NOW'),
                    onPressed: openCamera,
                  ),
                  TextButton.icon(
                    icon: Icon(Icons.add_photo_alternate_sharp),
                    label: Text('SELECT FROM GALLERY'),
                    onPressed: openGallery,
                  ),
                  ElevatedButton(
                    child: Text('UPDATE'),
                    onPressed: update,
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
      setState(() => profilePicture = File(pickerFile.path));
    }
  }

  Future<void> openCamera() async {
    final pickerFile = await ImagePicker().getImage(
      source: ImageSource.camera,
      imageQuality: 50,
      maxWidth: 500,
    );

    if (pickerFile != null) {
      setState(() => profilePicture = File(pickerFile.path));
    }
  }

  void update() async {
    if (profilePicture != null) {
      setState(() => working = true);

      final auth = FirebaseAuth.instance;
      final fireStore = FirebaseFirestore.instance;

      final ref = FirebaseStorage.instance
          .ref()
          .child('users')
          .child('profile')
          .child(auth.currentUser.uid + '.jpg');

      await ref.putFile(profilePicture).whenComplete(() => {});

      final url = await ref.getDownloadURL();

      fireStore.collection('users').doc(auth.currentUser.uid).update({
        'profile-picture': url,
      });
    }

    setState(() => working = false);

    Navigator.of(context).pop();
  }
}
