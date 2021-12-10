import 'dart:io';
import 'package:image_picker/image_picker.dart';

class ImagePickerUtil{
  File? imageR;
  final ImagePicker _picker = ImagePicker();

  Future getImageCamera() async{
    final image = await _picker.pickImage(source: ImageSource.camera);
    if(image != null){
      return File(image.path);
    }
  }

  Future getImageGalerya() async{
    final image = await _picker.pickImage(source: ImageSource.gallery);
    if(image != null){
      return File(image.path);
    }
  }
}

