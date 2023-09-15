import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:my_restaurant/widgets/sheet/image_selector_bottom_sheet.dart';

class ImageSelectorUtils {
  ImageSelectorUtils({
    this.height,
    this.width,
    this.quality,
    this.camera,
    this.cameraListener,
    this.galleryListener,
  });

  final double height;
  final double width;
  final int quality;
  final CameraDevice camera;
  final Function cameraListener;
  final Function galleryListener;

  void showSelector(context) {
    showModalBottomSheet(
      context: context,
      builder: (ctx) => ImageSelectorBottomSheet(
        theme: Theme.of(context).primaryColor,
        cameraLabel: 'Take a picture',
        galleryLabel: 'Choose from gallery',
        cameraAction: () => _fromCamera(),
        galleryAction: () => _fromGallery(),
      ),
    );
  }

  void _fromCamera() async {
    var file = await ImagePicker.pickImage(
      source: ImageSource.camera,
      maxHeight: height,
      maxWidth: width,
      imageQuality: quality,
      preferredCameraDevice: camera ?? CameraDevice.rear,
    );

    cameraListener(file);
  }

  void _fromGallery() async {
    var file = await ImagePicker.pickImage(
      source: ImageSource.gallery,
      maxHeight: height,
      maxWidth: width,
      imageQuality: quality,
    );

    galleryListener(file);
  }
}
