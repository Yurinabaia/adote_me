import 'package:flutter/material.dart';

Map<String, dynamic> typePu = {
  "animal_lost": {
    'tag': 'Perdido',
    'color': const Color(0xffA82525),
  },
  "animal_adoption": {
    'tag': 'Adoção',
    'color': const Color(0xffFBC224),
  },
};

class AnimalCard extends StatelessWidget {
  final String image;
  final String typePublication;
  final String name;
  final String district;
  const AnimalCard({
    Key? key,
    required this.image,
    required this.typePublication,
    required this.name,
    required this.district,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ConstrainedBox(
            constraints: const BoxConstraints(
              maxHeight: 175,
            ),
            child: Stack(
              fit: StackFit.expand,
              children: [
                Image.network(
                  image,
                  height: 250,
                  fit: BoxFit.cover,
                ),
              ],
            ),
          ),
          ListTile(
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Chip(
                  label: Text(
                    typePu[typePublication]['tag'],
                    style: TextStyle(
                      fontSize: 12,
                      color: typePublication == 'animal_lost' ? Colors.white : Colors.black,
                    ),
                  ),
                  backgroundColor: typePu[typePublication]['color'],
                ),
                Text(name),
              ],
            ),
            subtitle: Text(
              district,
              style: TextStyle(color: Colors.black.withOpacity(0.6)),
            ),
            minVerticalPadding: 0.0,
            minLeadingWidth: 0.0,
            contentPadding: const EdgeInsets.only(
              top: 0,
              left: 8.0,
              right: 8.0,
              bottom: 8.0,
            ),
          )
        ],
      ),
    );
  }
}
