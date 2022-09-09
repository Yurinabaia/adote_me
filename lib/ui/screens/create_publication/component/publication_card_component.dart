import 'package:adoteme/data/models/publication_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

class PublicationCardComponent extends StatelessWidget {
  final String title;
  final String image;
  final Color color;
  final String route;
  final String typePublication;
  const PublicationCardComponent({
    Key? key,
    required this.title,
    required this.image,
    required this.color,
    required this.route,
    required this.typePublication,
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
        final animalModel = context.read<PublicationModel>();
        animalModel.setTypePublication(typePublication);
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
