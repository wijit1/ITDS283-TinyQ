import 'dart:io';
import 'package:image_picker/image_picker.dart';

class ImagePickerr {
  Future<File?> uploadImage(String inputSource) async {
    final picker = ImagePicker();
    final XFile? pickerImage = await picker.pickImage(
      source:
          inputSource == 'camera' ? ImageSource.camera : ImageSource.gallery,
    );

    if (pickerImage == null) {
      return null;
    }
    File imageFile = File(pickerImage!.path);
    return imageFile;
  }
}