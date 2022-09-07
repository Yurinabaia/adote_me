import 'package:adoteme/data/service/animal_publication_service.dart';
import 'package:adoteme/data/service/user_profile_firebase_service.dart';
import 'package:adoteme/ui/components/alert_dialog_component.dart';
import 'package:adoteme/ui/components/buttons/button_component.dart';
import 'package:adoteme/ui/components/gallery_component.dart';
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

class AdoptionDetailsScreen extends StatefulWidget {
  static const routeName = "/adoption_post_details";

  const AdoptionDetailsScreen({Key? key}) : super(key: key);

  @override
  State<AdoptionDetailsScreen> createState() =>
      _AdoptionDetailsScreenState();
}

class _AdoptionDetailsScreenState extends State<AdoptionDetailsScreen>
    with SingleTickerProviderStateMixin {
  late TabController controllerTab;

  List<String?> _listImagesCarousel = List.filled(6, null);
  List<String> _listImagesVaccine = [];

  String? name;
  String? description;
  String? animal;
  dynamic age;
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
    DocumentSnapshot<Map<String, dynamic>> address =
        await userService.getUserProfile(idUser);
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
        await AnimalPublicationService.getPublication(
            'OMV59MpLx31zpIBMhDf2', 'animal_adoption');

    if (dataPublication?.data() != null) {
      getAdvertiser((dataPublication?.data()?['idUser']));
      setState(() {
        _listImagesCarousel =
            List<String>.from(dataPublication!.data()?['animalPhotos']);
        _listImagesVaccine =
            List<String>.from(dataPublication.data()?['picturesVaccineCard']);

        name = dataPublication.data()?['name'];
        description = dataPublication.data()?['description'];
        animal = dataPublication.data()?['animal'];
        age = dataPublication.data()?['age'] ?? 'Não informado';
        size = dataPublication.data()?['size'];
        sex = dataPublication.data()?['sex'];
        temperament = dataPublication.data()!['temperament'] ?? 'Não informado';
        breed = dataPublication.data()?['breed'] ?? 'Não informado';
        color = dataPublication.data()?['color'];
        castrated = dataPublication.data()?['castrated'] ?? 'Não informado';

        var timestamp = dataPublication.data()?['updatedAt'] ??
            dataPublication.data()?['createdAt'];
        var dateTime = DateTime.fromMicrosecondsSinceEpoch(
            timestamp!.microsecondsSinceEpoch);
        date =
            '${DateFormat.yMMMMEEEEd('pt-br').format(dateTime)}    ${DateFormat.jms('pt-br').format(dateTime)}';
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
          // TODO: falta implementar o card para obter o id da publicação em 'Minhas publicações para editar'
          // Navigator.of(context).pushNamed('/create-publication/basic_animal_data')
          onPressed: () => {},
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
                      if (_listImagesCarousel
                          .every((element) => element != null))
                        CarouselComponent(
                          listImages: _listImagesCarousel,
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
                            // TODO: implementar distancia dinâmica
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
                                typePhone: 'WhatsApp',
                              ),
                              if (userPhone2 != null)
                                ContactComponent(
                                  userName: userName,
                                  userPhoto: userPhoto,
                                  userPhone: userPhone2,
                                  typePhone: 'Telefone',
                                ),
                              if (userPhone3 != null)
                                ContactComponent(
                                  userName: userName,
                                  userPhoto: userPhoto,
                                  userPhone: userPhone3,
                                  typePhone: 'Telefone',
                                ),
                            ],
                          ),
                          const SizedBox(height: 64),
                          ButtonComponent(
                            text: 'Finalizar publicação',
                            color: const Color(0xff21725E),
                            onPressed: () {
                              Navigator.pushNamed(context, '/end_publication');
                            },
                          ),
                          const SizedBox(height: 16),
                          ButtonComponent(
                            text: 'Excluir publicação',
                            color: const Color(0xffA82525),
                            onPressed: () async {
                              await showDialog(
                                context: context,
                                builder: (context) =>
                                    const AlertDialogComponent(
                                  statusType: 'error',
                                  title: 'Excluir publicação',
                                  message:
                                      'A publicação será excluída permanentemente. Deseja prosseguir ?',
                                ),
                              ).then((value) {
                                if (value) {
                                  AnimalPublicationService.deletePublication(
                                      "D4BgUd4AwzANV0Tlcyg3", "animal_lost");
                                  Navigator.pushReplacementNamed(
                                      context, '/my_publications');
                                }
                              });
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                GridView.builder(
                  gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                    maxCrossAxisExtent: 200,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                  ),
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: _listImagesVaccine.length,
                  itemBuilder: (BuildContext context, int index) {
                    return _listImagesVaccine.isNotEmpty
                        ? GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => GalleryComponent(
                                    initialIndex: index,
                                    galleryItems: _listImagesVaccine,
                                  ),
                                ),
                              );
                            },
                            child: ClipRect(
                              child: Image.network(
                                _listImagesVaccine[index],
                                fit: BoxFit.cover,
                              ),
                            ),
                          )
                        : const Center(
                            child: DetailTextComponent(
                              text: 'Nenhuma imagem encontrada',
                            ),
                          );
                  },
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
