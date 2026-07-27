import 'package:image_picker/image_picker.dart';

class ImagePickerService {
  ImagePickerService({ImagePicker? picker}) : _picker = picker ?? ImagePicker();

  final ImagePicker _picker;

  Future<XFile?> fromGallery() =>
      _picker.pickImage(source: ImageSource.gallery);

  Future<XFile?> fromCamera() =>
      _picker.pickImage(source: ImageSource.camera);
}
