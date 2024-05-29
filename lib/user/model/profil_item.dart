import 'package:image_picker/image_picker.dart';

class ProfilItem{
  ProfilItem({
    required this.alamat,
    required this.noHp
  });
  final String alamat;
  final String noHp;
}

pickImage(ImageSource source) async{
  final ImagePicker _picker = ImagePicker();
  final XFile? imagePicked = await _picker.pickImage(source: source);
  if (imagePicked != null) {
    return await imagePicked.readAsBytes();
  }
  print('No image Selected');
}