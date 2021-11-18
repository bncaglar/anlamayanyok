import 'dart:io';

import 'package:image_picker/image_picker.dart';


class MediaService {
  static MediaService instance = MediaService();
  final _picker = ImagePicker();
  PickedFile image;
  Future<File> getImageFromGallery() async{
    image = await _picker.getImage(source: ImageSource.gallery,
    imageQuality: 25);
    return File(image.path);
  }
  Future<File> getImageFromCamera() async{
    image = await _picker.getImage(source: ImageSource.camera,
        imageQuality: 25);
    return File(image.path);
  }
}
