import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';

class UploadFileFirebaseService {
  static Future<bool> uploadImage(File fileImage, String path) async {
    final storageRef = FirebaseStorage.instance.ref().child(path);

    try {
      await storageRef.putFile(fileImage);
    } catch (e) {
      return false;
    }
    return true;
  }

  static Future<String> getImage(String path) async {
    String url = '';
    try {
      final storageRef = FirebaseStorage.instance.ref().child(path);
      url = await storageRef.getDownloadURL();
    } catch (e) {
      return '';
    }
    return url;
  }
}
