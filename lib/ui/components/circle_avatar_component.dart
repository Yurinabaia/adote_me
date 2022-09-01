import 'dart:io';
import 'dart:typed_data';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

class CircleAvatarComponent {
  static CircleAvatar findCircleAvatar(
      {Uint8List? imgFirebase, PlatformFile? file}) {
    var backgroundImage = Image.asset('assets/images/user_profile.png').image;
    if (imgFirebase != null) {
      backgroundImage = Image.memory(
        imgFirebase,
        fit: BoxFit.cover,
      ).image;
    } else if (file != null) {
      backgroundImage = FileImage(File(file.path!));
    }

    return CircleAvatar(
      radius: 75,
      backgroundColor: Colors.grey[300],
      backgroundImage: backgroundImage,
    );
  }
}
