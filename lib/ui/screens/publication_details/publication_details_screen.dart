import 'package:adoteme/data/service/animal_publication_service.dart';
import 'package:adoteme/data/service/user_profile_firebase_service.dart';
import 'package:adoteme/ui/components/buttons/button_component.dart';
import 'package:adoteme/ui/components/texts/detail_text_component.dart';
import 'package:adoteme/ui/components/texts/title_three_component.dart';
import 'package:adoteme/ui/screens/publication_details/components/carousel_component.dart';
import 'package:adoteme/ui/screens/publication_details/components/contact_component.dart';
import 'package:adoteme/ui/screens/publication_details/components/term_description_component.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';

class PublicationDetailsScreen extends StatefulWidget {
  static const routeName = "/publication_details";

  const PublicationDetailsScreen({Key? key}) : super(key: key);

  @override
  State<PublicationDetailsScreen> createState() => _PublicationDetailsScreenState();
}

class _PublicationDetailsScreenState extends State<PublicationDetailsScreen> with SingleTickerProviderStateMixin {
  late TabController controllerTab;

  List<String?> listImages = List.filled(6, null);

  String? name;
  String? description;
  String? animal;
  int? age;
  String? size;
  String? sex;
  String? temperament;
  String? breed;
  String? color;
  String? castrated;
  String? date;

  String? userName;
  String? userPhoto;
  String? userPhone1;
  String? userPhone2;
  String? userPhone3;
  String? street;
  String? number;
  String? city;
  String? state;

  getAdvertiser(String idUser) async {
    UserProfileFirebaseService userService = UserProfileFirebaseService();
    DocumentSnapshot<Map<String, dynamic>> address = await userService.getUserProfile(idUser);
    setState(() {
      userName = address.data()?["name"];
      userPhoto = address.data()?["image"];
      userPhone1 = address.data()?["mainCell"];
      userPhone2 = address.data()?["optionalCell"];
      userPhone3 = address.data()?["optionalCell2"];
      street = address.data()?['street'];
      number = address.data()?['number'];
      city = address.data()?['city'];
      state = address.data()?['state'];
    });
  }

  getDataPublication() async {
    initializeDateFormatting('pt-br');
    // TODO: implementar passagem de dados dinâmicos
    DocumentSnapshot<Map<String, dynamic>>? dataPublication =
        await AnimalPublicationService.getPublication('OMV59MpLx31zpIBMhDf2', 'animal_adoption');

    if (dataPublication?.data() != null) {
      // TODO: corrigir chave para idUser
      getAdvertiser((dataPublication?.data()?['idUsuario']));

      setState(() {
        listImages = List<String>.from(dataPublication!.data()!['animalPhotos']);
        name = dataPublication.data()?['name'];
        description = dataPublication.data()?['description'] ?? 'Não informado';
        animal = dataPublication.data()?['animal'];
        age = dataPublication.data()?['age'] ?? 'Não informado';
        size = dataPublication.data()?['size'];
        sex = dataPublication.data()?['sex'];
        temperament = dataPublication.data()!['temperament'] ?? 'Não informado';
        breed = dataPublication.data()?['breed'] ?? 'Não informado';
        color = dataPublication.data()?['color'];
        castrated = dataPublication.data()?['castrated'] ?? 'Não informado';
        
        var timestamp = dataPublication.data()?['updateDate'] ?? dataPublication.data()?['createDate'];
        var dateTime = DateTime.fromMicrosecondsSinceEpoch(timestamp!.microsecondsSinceEpoch);
        date = '${DateFormat.yMMMMEEEEd('pt-br').format(dateTime)}    ${DateFormat.jms('pt-br').format(dateTime)}';
      });
    }
  }

  @override
  void initState() {
    super.initState();
    getDataPublication();
    controllerTab = TabController(length: 2, vsync: this);
  }

  int current = 0;
  final CarouselController controller = CarouselController();

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
                      if (listImages.every((element) => element != null))
                        CarouselComponent(
                          listImages: listImages,
                        ),
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
                            text: "$date",
                          ),
                          const SizedBox(height: 16),
                          Text(
                            "$name",
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Color(0xff334155),
                            ),
                          ),
                          DetailTextComponent(
                            // TODO: implementar distãncia dinâmica
                            text: "$street, $number, $city - $state \n1,5 km",
                          ),
                          const SizedBox(height: 32),
                          const TitleThreeComponent(text: "Resumo"),
                          DetailTextComponent(
                            text: "$description",
                          ),
                          const SizedBox(height: 32),
                          const TitleThreeComponent(text: 'Descrição'),
                          TermDescriptionComponent(
                            term: "Animal",
                            description: "$animal",
                          ),
                          TermDescriptionComponent(
                            term: "Idade",
                            description: "$age",
                          ),
                          TermDescriptionComponent(
                            term: "Tamanho",
                            description: "$size",
                          ),
                          TermDescriptionComponent(
                            term: "Sexo",
                            description: "$sex",
                          ),
                          TermDescriptionComponent(
                            term: "Temperamento",
                            description: "$temperament",
                          ),
                          TermDescriptionComponent(
                            term: "Raça",
                            description: "$breed",
                          ),
                          TermDescriptionComponent(
                            term: "Cor",
                            description: "$color",
                          ),
                          TermDescriptionComponent(
                            term: "Castrado",
                            description: "$castrated",
                          ),
                          const SizedBox(height: 32),
                          Wrap(
                            spacing: 12,
                            runSpacing: 12,
                            children: [
                              ContactComponent(
                                userName: userName,
                                userPhoto: userPhoto,
                                userPhone: userPhone1,
                              ),
                              // TODO: substituir por null
                              if (userPhone2 != "")
                                ContactComponent(
                                  userName: userName,
                                  userPhoto: userPhoto,
                                  userPhone: userPhone2,
                                ),
                              // TODO: substituir por null
                              if (userPhone3 != "")
                                ContactComponent(
                                  userName: userName,
                                  userPhoto: userPhoto,
                                  userPhone: userPhone3,
                                ),
                            ],
                          ),
                          const SizedBox(height: 64),
                          ButtonComponent(
                            text: 'Finalizar publicação',
                            color: Color(0xff21725E),
                            // TODO: Implementar ação do finalizar publicação
                            onPressed: () {},
                          ),
                          const SizedBox(height: 16),
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
