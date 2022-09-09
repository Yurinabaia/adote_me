import 'package:adoteme/data/models/publication_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_layout_grid/flutter_layout_grid.dart';

Map<String, dynamic> typePublication = {
  "animal_lost": {
    'tag': 'Perdido',
    'color': const Color(0xffA82525),
  },
  "animal_adoption": {
    'tag': 'Adoção',
    'color': const Color(0xffFBC224),
  },
};

class CardLayoutGrid extends StatelessWidget {
  final QuerySnapshot<Map<String, dynamic>> items;
  CardLayoutGrid({
    Key? key,
    required this.items,
  }) : super(key: key);

  int crossAxisCount = 2;

  @override
  Widget build(BuildContext context) {
    final rowSizes =
        List.generate((items.size / crossAxisCount).round(), (_) => auto);
    return LayoutBuilder(
      builder: (context, constraints) {
        return LayoutGrid(
          columnSizes:
              List.generate((constraints.maxWidth / 220).round(), (_) => 1.fr),
          rowSizes: rowSizes,
          rowGap: 8,
          columnGap: 8,
          children: <Widget>[
            for (var i = 0; i < items.size; i++) ...[
              Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                clipBehavior: Clip.antiAlias,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Image.network(
                      items.docs[i].data()['animalPhotos'][0] ??
                          'https://picsum.photos/250?image=9',
                      height: 250,
                      fit: BoxFit.cover,
                    ),
                    ListTile(
                      title: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Chip(
                            label: Text(
                              typePublication[items.docs[i]['typePublication']]
                                  ['tag'],
                              style: TextStyle(
                                fontSize: 12,
                                color: items.docs[i]['typePublication'] ==
                                        'animal_lost'
                                    ? Colors.white
                                    : Colors.black,
                              ),
                            ),
                            backgroundColor: typePublication[items.docs[i]
                                ['typePublication']]['color'],
                          ),
                          Text(items.docs[i]['name'].toString()),
                        ],
                      ),
                      subtitle: Text(
                        items.docs[i]['address']['district'].toString(),
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
              ),
            ],
          ],
        );
      },
    );
  }
}
