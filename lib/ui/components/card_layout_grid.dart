import 'package:flutter/material.dart';
import 'package:flutter_layout_grid/flutter_layout_grid.dart';

// TODO: JÁ EXISTE UM COMPONENTE CHAMADO PublicationCardComponent (sugestão: CardLayoutGrid )
class CardLayoutGrid extends StatelessWidget {
  CardLayoutGrid({
    Key? key,
    // required this.items,
  }) : super(key: key);

  int crossAxisCount = 2;

  @override
  Widget build(BuildContext context) {
    final rowSizes = List.generate(6 ~/ crossAxisCount, (_) => auto);
    return LayoutBuilder(
      builder: (context, constraints) {
        return LayoutGrid(
          columnSizes: List.generate((constraints.maxWidth / 220).round(), (_) => 1.fr),
          rowSizes: rowSizes,
          rowGap: 8,
          columnGap: 8,
          children: [
            for (var i = 0; i < 6; i++)
              Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                clipBehavior: Clip.antiAlias,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Image.network(
                      'https://picsum.photos/300',
                      fit: BoxFit.cover,
                    ),
                    ListTile(
                      title: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const <Widget>[
                          Chip(
                            label: Text(
                              'Adoção',
                              style: TextStyle(
                                fontSize: 12,
                                color: Color(0xff334155),
                              ),
                            ),
                            backgroundColor: Color(0xFFFBC224),
                          ),
                          Text('Card title 1'),
                        ],
                      ),
                      subtitle: Text(
                        'Secondary Text',
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
        );
      },
    );
  }
}
