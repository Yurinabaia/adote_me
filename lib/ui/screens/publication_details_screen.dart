import 'package:adoteme/ui/components/texts/body_text_component.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

class PublicationDetailsScreen extends StatefulWidget {
  static const routeName = "/publication_details";

  const PublicationDetailsScreen({Key? key}) : super(key: key);

  @override
  State<PublicationDetailsScreen> createState() => _PublicationDetailsScreenState();
}

class _PublicationDetailsScreenState extends State<PublicationDetailsScreen> {
  int current = 0;
  final CarouselController controller = CarouselController();

  @override
  Widget build(BuildContext context) {
    TabBar tabBar = TabBar(
      indicatorColor: Theme.of(context).primaryColor,
      indicatorWeight: 4,
      tabs: const <Widget>[
        Padding(
          padding: EdgeInsets.symmetric(vertical: 8),
          child: Tab(
            child: BodyTextComponent(text: 'Geral'),
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(vertical: 8.0),
          child: Tab(
            child: BodyTextComponent(text: 'Cartão de vacina'),
          ),
        ),
      ],
    );

    // list images picsum
    List<String> list = [
      "https://picsum.photos/350?image=9",
      "https://picsum.photos/350?image=19",
      "https://picsum.photos/350?image=29",
      "https://picsum.photos/350?image=39",
      "https://picsum.photos/350?image=49",
    ];

    return Scaffold(
      body: DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            titleSpacing: 0,
            toolbarHeight: 300,
            centerTitle: true,
            title: Stack(
              alignment: const Alignment(0.5, 0.9),
              children: [
                Builder(builder: (context) {
                  return CarouselSlider(
                    carouselController: controller,
                    options: CarouselOptions(
                      height: 300,
                      viewportFraction: 1.0,
                      autoPlay: true,
                      onPageChanged: (index, reason) {
                        setState(() {
                          current = index;
                        });
                      },
                    ),
                    items: list
                        .map((item) => Image.network(
                              item,
                              fit: BoxFit.cover,
                              width: MediaQuery.of(context).size.width,
                            ))
                        .toList(),
                  );
                }),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: list.asMap().entries.map((entry) {
                    return GestureDetector(
                      onTap: () => controller.animateToPage(entry.key),
                      child: Container(
                        width: 12.0,
                        height: 12.0,
                        margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white.withOpacity(current == entry.key ? 1 : 0.4),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.5),
                              spreadRadius: 1,
                            ),
                          ],
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ],
            ),
            bottom: PreferredSize(
              preferredSize: tabBar.preferredSize,
              child: Material(
                color: Colors.white,
                child: tabBar,
              ),
            ),
          ),
          body: const TabBarView(
            children: [
              Icon(Icons.flight, size: 350),
              Icon(Icons.directions_transit, size: 350),
            ],
          ),
        ),
      ),
    );
  }
}
