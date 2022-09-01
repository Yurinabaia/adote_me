import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';

class UploadFileFirebaseService {
  static Future<bool> uploadImage(File fileImage, String path) async {
    
    // Upload the file to the path 'images/mountains.jpg'
    final storageRef = FirebaseStorage.instance.ref().child(path);

    // Upload file and metadata to the path 'images/mountains.jpg'
    try {
      await storageRef.putFile(fileImage);
    } catch (e) {
      return false;
    }
    return true;
  }

  static Future<String> getImage(String path) async {
    final storageRef = FirebaseStorage.instance.ref().child(path);
    final url = await storageRef.getDownloadURL();
    return url;
  }
}
