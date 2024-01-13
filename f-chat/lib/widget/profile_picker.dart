import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ProfilePicker extends StatefulWidget {
  ProfilePicker(this.setProfilePicture);

  final Function(File profilePicture) setProfilePicture;

  @override
  _ProfilePickerState createState() => _ProfilePickerState();
}

class _ProfilePickerState extends State<ProfilePicker> {
  File profilePicture;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: 20),
        CircleAvatar(
          radius: 75,
          child: Text(
            profilePicture == null ? 'PREVIEW' : '',
            style: TextStyle(fontSize: 14, color: Colors.white),
          ),
          backgroundColor: Theme.of(context).primaryColor,
          backgroundImage: profilePicture != null ? FileImage(profilePicture) : null,
        ),
        SizedBox(height: 10),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              TextButton.icon(
                icon: Icon(Icons.camera_sharp),
                label: Text('TAKE PICTURE'),
                onPressed: openCamera,
              ),
              TextButton.icon(
                icon: Icon(Icons.add_photo_alternate_sharp),
                label: Text('SELECT PICTURE'),
                onPressed: openGallery,
              ),
            ],
          ),
        ),
      ],
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
      widget.setProfilePicture(profilePicture);
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
      widget.setProfilePicture(profilePicture);
    }
  }
}
