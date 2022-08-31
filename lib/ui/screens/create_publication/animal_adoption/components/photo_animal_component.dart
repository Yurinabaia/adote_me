import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class PhotoAnimalComponent extends StatefulWidget {
  const PhotoAnimalComponent({Key? key}) : super(key: key);

  @override
  State<PhotoAnimalComponent> createState() => _PhotoAnimalComponentState();
}

class _PhotoAnimalComponentState extends State<PhotoAnimalComponent> {
  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: const Color(0xffDFE5EC),
      ),
      child: SvgPicture.asset(
        'assets/images/add_photo.svg',
        height: 60,
        width: 60,
      ),
    );
  }
}
