import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';

final FirebaseStorage storage = FirebaseStorage.instance;

Future<XFile?> getImage() async {
  final ImagePicker picker = ImagePicker();
  final XFile? image = await picker.pickImage(source: ImageSource.gallery);
  return image;
}

Future<String> uploadImage(File image) async {
  // print(image);

  final String nameFile = image.path.split("/").last;

  final Reference ref = storage.ref().child("Instrumentos").child(nameFile);

  final UploadTask uploadTask = ref.putFile(image);
  print(uploadTask);

  final TaskSnapshot snapshot = await uploadTask.whenComplete(() => true);
  print(snapshot);

  final String url = await snapshot.ref.getDownloadURL();
  print(url);

  return url;
}
