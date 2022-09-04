import 'package:adoteme/ui/components/buttons/button_component.dart';
import 'package:adoteme/ui/components/texts/detail_text_component.dart';
import 'package:adoteme/ui/components/texts/label_text_component.dart';
import 'package:adoteme/ui/components/texts/title_three_component.dart';
import 'package:adoteme/ui/screens/publication_details/components/carousel_component.dart';
import 'package:adoteme/ui/screens/publication_details/components/contact_component.dart';
import 'package:adoteme/ui/screens/publication_details/components/term_description_component.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

class PublicationDetailsScreen extends StatefulWidget {
  static const routeName = "/publication_details";

  const PublicationDetailsScreen({Key? key}) : super(key: key);

  @override
  State<PublicationDetailsScreen> createState() => _PublicationDetailsScreenState();
}

class _PublicationDetailsScreenState extends State<PublicationDetailsScreen> with SingleTickerProviderStateMixin {
  late TabController controllerTab;

  @override
  void initState() {
    super.initState();
    controllerTab = TabController(length: 2, vsync: this);
  }

  int current = 0;
  final CarouselController controller = CarouselController();

  List<String> list = [
    "https://picsum.photos/300?image=9",
    "https://picsum.photos/300?image=19",
    "https://picsum.photos/300?image=29",
    "https://picsum.photos/300?image=39",
    "https://picsum.photos/300?image=49",
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: SizedBox(
        height: 70,
        width: 70,
        child: FloatingActionButton(
          backgroundColor: Theme.of(context).primaryColor,
          onPressed: () => Navigator.of(context).pushNamed('/create-publication/basic_animal_data'),
          child: const Icon(
            Icons.edit,
            size: 40,
          ),
        ),
      ),
      body: NestedScrollView(
        scrollBehavior: const ScrollBehavior(),
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return [
            SliverAppBar(
              shadowColor: Colors.transparent,
              leading: Align(
                alignment: const Alignment(0.2, 0.2),
                child: CircleAvatar(
                  backgroundColor: Colors.white,
                  child: IconButton(
                    icon: const Icon(
                      Icons.arrow_back_ios_rounded,
                      color: Color(0xff334155),
                    ),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ),
              ),
              flexibleSpace: FlexibleSpaceBar(
                collapseMode: CollapseMode.pin,
                background: SafeArea(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      CarouselComponent(listImages: list),
                    ],
                  ),
                ),
              ),
              expandedHeight: 310.0,
              collapsedHeight: 310.0,
              bottom: TabBar(
                indicatorColor: Theme.of(context).primaryColor,
                indicatorWeight: 4,
                labelColor: Theme.of(context).primaryColor,
                tabs: const <Widget>[
                  Tab(
                    child: Text(
                      'Geral',
                      style: TextStyle(
                        fontSize: 18,
                      ),
                    ),
                  ),
                  Tab(
                    child: Text(
                      'Cartão de vacina',
                      style: TextStyle(
                        fontSize: 18,
                      ),
                    ),
                  ),
                ],
                controller: controllerTab,
              ),
            )
          ];
        },
        body: LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
            return TabBarView(
              controller: controllerTab,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: ListView(
                    children: <Widget>[
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          DetailTextComponent(
                            text: "01 de abr. 1970    12:30:49",
                          ),
                          SizedBox(height: 16),
                          Text(
                            "Nome do animal",
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Color(0xff334155),
                            ),
                          ),
                          DetailTextComponent(
                            text: "Rua dos bobos, 0, Belo Horizonte - MG \n1,5 km",
                          ),
                          SizedBox(height: 32),
                          TitleThreeComponent(text: "Resumo"),
                          DetailTextComponent(
                            text:
                                'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sit adipiscing id et sollicitudin nisl. Eget amet quam sem sed ut. Velit sollicitudin blandit nullam aliquam habitant gravida ut. Facilisi ac proin urna viverra quis quis in egestas.',
                          ),
                          SizedBox(height: 32),
                          TitleThreeComponent(text: 'Descrição'),
                          TermDescriptionComponent(
                            term: "Nome",
                            description: "Bolinha",
                          ),
                          TermDescriptionComponent(
                            term: "Nome",
                            description: "Bolinha",
                          ),
                          TermDescriptionComponent(
                            term: "Nome",
                            description: "Bolinha",
                          ),
                          TermDescriptionComponent(
                            term: "Nome",
                            description: "Bolinha",
                          ),
                          SizedBox(height: 32),
                          Wrap(
                            spacing: 12,
                            runSpacing: 12,
                            children: [
                              ContactComponent(),
                              ContactComponent(),
                              ContactComponent(),
                            ],
                          ),
                          SizedBox(height: 64),
                          ButtonComponent(
                            text: 'Finalizar publicação',
                            color: Color(0xff21725E),
                            // TODO: Implementar ação do finalizar publicação
                            onPressed: () {},
                          ),
                          SizedBox(height: 16),
                          ButtonComponent(
                            text: 'Excluir permanentemente',
                            color: Color(0xffA82525),
                            // TODO: Implementar ação do excluir publicação
                            onPressed: () {},
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Container(
                    // color: Colors.green,
                    ),
              ],
            );
          },
        ),
      ),
    );
  }
}
