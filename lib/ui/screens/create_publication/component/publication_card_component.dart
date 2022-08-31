import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class PublicationCardComponent extends StatelessWidget {
  final String title;
  final String image;
  final Color color;
  final String route;

  const PublicationCardComponent({
    Key? key,
    required this.title,
    required this.image,
    required this.color,
    required this.route,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextButton(
      style: TextButton.styleFrom(
        padding: const EdgeInsets.all(16),
        backgroundColor: color,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      onPressed: () {
        Navigator.of(context).pushNamed(route);
      },
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          SvgPicture.asset(
            'assets/images/$image.svg',
            height: 100,
          ),
          const SizedBox(
            height: 24,
          ),
          Text(
            title,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
