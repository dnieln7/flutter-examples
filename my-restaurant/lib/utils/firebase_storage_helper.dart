import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';

class FirebaseStorageHelper {
  FirebaseStorageHelper({
    @required this.imageToUpload,
    @required this.fileName,
    @required this.location,
    @required this.onSuccess,
    @required this.onFailure,
  });

  final File imageToUpload;
  final String fileName;
  final String location;
  final Function onSuccess;
  final Function onFailure;

  Future uploadFile() async {
    final app = await Firebase.initializeApp();
    final ref = FirebaseStorage.instance.ref().child('$location$fileName');
    final uploadTask = ref.putFile(imageToUpload);
    final taskSnapshot = await uploadTask.whenComplete(() => null);
    await taskSnapshot.ref
        .getDownloadURL()
        .then((url) => onSuccess(url))
        .catchError((error) => onFailure(error));
  }

  static void deleteFile(String fileName) {
    final file = fileName
        .split('/o/')[1]
        .replaceAll('%2F', '/')
        .replaceAll('%20', ' ')
        .split('?alt')[0];

    Firebase.initializeApp().then(
      (_) => FirebaseStorage.instance.ref().child(file).delete(),
    );
  }
}
