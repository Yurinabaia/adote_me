import 'dart:io';
import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class PhotoAnimalComponent extends StatelessWidget {
  final PlatformFile? file;
  final Uint8List? imgFirebase;
  const PhotoAnimalComponent({Key? key, this.file, this.imgFirebase})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: const Color(0xffDFE5EC),
      ),
      child: selectImgType(),
    );
  }

  selectImgType() {
    dynamic image = SvgPicture.asset(
      'assets/images/add_photo.svg',
      height: 60,
      width: 60,
    );
    if (imgFirebase != null) {
      image = Image.memory(
        imgFirebase!,
        fit: BoxFit.cover,
      ).image;
    } else if (file != null) {
      image = Image(
        image: FileImage(File(file!.path!)),
        fit: BoxFit.cover,
        width: 200,
        height: 200,
      );
    }
    return image;
  }
}
