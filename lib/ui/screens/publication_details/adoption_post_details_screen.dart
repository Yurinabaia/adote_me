import 'package:adoteme/data/models/publication_model.dart';
import 'package:adoteme/data/providers/id_publication_provider.dart';
import 'package:adoteme/data/service/address/calculate_distance.dart';
import 'package:adoteme/data/service/address/current_location.dart';
import 'package:adoteme/data/service/login_firebase_service.dart';
import 'package:adoteme/data/service/publication_service.dart';
import 'package:adoteme/data/service/user_profile_firebase_service.dart';
import 'package:adoteme/ui/components/alert_dialog_component.dart';
import 'package:adoteme/ui/components/buttons/button_component.dart';
import 'package:adoteme/ui/components/gallery_component.dart';
import 'package:adoteme/ui/components/texts/detail_text_component.dart';
import 'package:adoteme/ui/components/texts/label_text_component.dart';
import 'package:adoteme/ui/components/texts/title_three_component.dart';
import 'package:adoteme/ui/screens/publication_details/components/carousel_component.dart';
import 'package:adoteme/ui/screens/publication_details/components/check_favorite_component.dart';
import 'package:adoteme/ui/screens/publication_details/components/contact_component.dart';
import 'package:adoteme/ui/screens/publication_details/components/term_description_component.dart';
import 'package:adoteme/utils/contact_open.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:provider/provider.dart';

class AdoptionDetailsScreen extends StatefulWidget {
  static const routeName = "/adoption_post_details";

  const AdoptionDetailsScreen({Key? key}) : super(key: key);

  @override
  State<AdoptionDetailsScreen> createState() => _AdoptionDetailsScreenState();
}

class _AdoptionDetailsScreenState extends State<AdoptionDetailsScreen>
    with SingleTickerProviderStateMixin {
  late TabController controllerTab;

  List<String?> _listImagesCarousel = List.filled(6, null);
  List<String> _listImagesVaccine = [];
  List<String> _listFavoritesFirebase = [];

  final CarouselController controller = CarouselController();

  final ValueNotifier<String?> _idPublication = ValueNotifier<String?>(null);
  final ValueNotifier<String?> _idUser = ValueNotifier<String?>(null);
  final UserProfileFirebaseService userService = UserProfileFirebaseService();
  final ContactOpen contactOpen = ContactOpen();

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
  String? status;
  String? feedback;

  String? userName;
  String? userPhoto;
  String? userPhone1;
  String? userPhone2;
  String? userPhone3;
  String? street;
  String? number;
  String? city;
  String? state;
  double? latAdvertiser;
  double? longAdvertiser;

  int current = 0;
  bool _isSelected = false;
  bool _isMyPublication = false;

  double _distance = 0.0;
  getDataUser() async {
    double latUser = 0.0;
    double longUser = 0.0;
    DocumentSnapshot<Map<String, dynamic>> dataUser =
        await userService.getUserProfile(_idUser.value!);
    if (dataUser.data() != null) {
      _listFavoritesFirebase =
          List<String>.from(dataUser.data()?['listFavoritesAnimal']);
      _isSelected = _listFavoritesFirebase.contains(_idPublication.value);
      latUser = dataUser.data()?['lat'] ?? 0.0;
      longUser = dataUser.data()?['long'] ?? 0.0;
    } else {
      var localizationUser = await CurrentLocation.getPosition();
      longUser = double.parse(localizationUser['lat'].toString());
      longUser = double.parse(localizationUser['long'].toString());
    }
    _distance = CalculateDistance.calculateDistance(
        latUser, longUser, latAdvertiser ?? 0.0, longAdvertiser ?? 0.0);
    setState(() {});
  }

  getAdvertiser(String idAdverties) async {
    DocumentSnapshot<Map<String, dynamic>> address =
        await userService.getUserProfile(idAdverties);
    setState(() {
      userName = address.data()?["name"];
      userPhoto = address.data()?["image"];
      userPhone1 = address.data()?["mainCell"];
      userPhone2 = address.data()?["optionalCell"];
      userPhone3 = address.data()?["optionalCell2"];
      if (!_isMyPublication) {
        getDataUser();
      }
    });
  }

  getDataPublication() async {
    initializeDateFormatting('pt-br');
    final idPublication = context.read<IdPublicationProvider>();
    DocumentSnapshot<Map<String, dynamic>>? dataPublication =
        await PublicationService.getPublication(
            idPublication.get(), 'publications_animal');

    if (dataPublication?.data() != null) {
      _isMyPublication = dataPublication?.data()?['idUser'] == _idUser.value;
      getAdvertiser((dataPublication?.data()?['idUser']));
      setState(() {
        _listImagesCarousel =
            List<String>.from(dataPublication!.data()?['animalPhotos']);
        if (dataPublication.data()?['picturesVaccineCard'] != null) {
          _listImagesVaccine =
              List<String>.from(dataPublication.data()?['picturesVaccineCard']);
        }

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
        status = dataPublication.data()?['status'];
        feedback = dataPublication.data()?['feedback'];

        street = dataPublication.data()?['address']['street'];
        number = dataPublication.data()?['address']['number'];
        city = dataPublication.data()?['address']['city'];
        state = dataPublication.data()?['address']['state'];
        latAdvertiser = dataPublication.data()?['address']['lat'] ?? 0.0;
        longAdvertiser = dataPublication.data()?['address']['long'] ?? 0.0;
        var timestamp = dataPublication.data()?['updatedAt'];
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
    final idPublication = context.read<IdPublicationProvider>();
    final auth = context.read<LoginFirebaseService>();
    _idPublication.value = idPublication.get();
    _idUser.value = auth.idFirebase();
    if (_idPublication.value != null) {
      getDataPublication();
    }
    controllerTab = TabController(length: 2, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    final animalModel = context.read<PublicationModel>();
    return Scaffold(
      floatingActionButton: status != 'finished'
          ? SizedBox(
              height: 70,
              width: 70,
              child: FloatingActionButton(
                backgroundColor: Theme.of(context).primaryColor,
                onPressed: () {
                  animalModel.setTypePublication('animal_adoption');
                  Navigator.pushNamed(
                      context, '/create-publication/basic_animal_data');
                },
                child: const Icon(
                  Icons.edit,
                  size: 40,
                ),
              ),
            )
          : Container(),
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
                      final arguments =
                          ModalRoute.of(context)?.settings.arguments;

                      if (arguments != null) {
                        Navigator.pushReplacementNamed(context, '/favorites');
                      } else {
                        Navigator.pop(context);
                      }
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
                          status: status,
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
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: DetailTextComponent(
                                  text: "$date",
                                ),
                              ),
                              const SizedBox(
                                width: 50,
                              ),
                              if (!_isMyPublication)
                                GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        _isSelected = !_isSelected;
                                        _listFavoritesFirebase
                                                .contains(_idPublication.value)
                                            ? _listFavoritesFirebase
                                                .remove(_idPublication.value)
                                            : _listFavoritesFirebase
                                                .add(_idPublication.value!);

                                        Map<String, dynamic> data = {
                                          'listFavoritesAnimal':
                                              _listFavoritesFirebase
                                        };
                                        userService.updateProfile(
                                            _idUser.value, data);
                                      });
                                    },
                                    child: CheckFavoriteComponent(
                                        isChecked: _isSelected)),
                            ],
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
                            text:
                                "$street, $number, $city - $state \n${_distance == 0 ? '' : '${_distance.toStringAsFixed(2)} km'}",
                          ),
                          TextButton.icon(
                            onPressed: () => contactOpen.openGoogleMaps(
                                latAdvertiser.toString(),
                                longAdvertiser.toString()),
                            label: const Text(
                              'Ver no mapa',
                              style: TextStyle(
                                fontSize: 16,
                              ),
                            ),
                            icon: SvgPicture.asset(
                              'assets/images/google-maps.svg',
                              width: 30,
                              height: 30,
                            ),
                            style: TextButton.styleFrom(
                              padding: const EdgeInsets.all(0),
                            ),
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
                          const SizedBox(height: 16),
                          if (status != 'finished') ...[
                            const SizedBox(height: 16),
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
                                Navigator.pushNamed(
                                    context, '/end_publication');
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
                                    PublicationService.deletePublication(
                                        _idPublication.value!,
                                        "publications_animal");
                                    Navigator.pushReplacementNamed(
                                        context, '/my_publications');
                                  }
                                });
                              },
                            ),
                          ] else
                            Container(
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(
                                  color: Theme.of(context).primaryColor,
                                  width: 1,
                                ),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  ListTile(
                                    contentPadding: EdgeInsets.zero,
                                    // minVerticalPadding: -4,
                                    tileColor: Colors.black,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    leading: SizedBox(
                                      height: 100,
                                      width: 50,
                                      child: CircleAvatar(
                                        backgroundImage: userPhoto != null
                                            ? Image.network(
                                                '$userPhoto',
                                              ).image
                                            : Image.asset(
                                                'assets/images/user_profile.png',
                                              ).image,
                                      ),
                                    ),
                                    title: Text(
                                      '$userName',
                                      style: const TextStyle(
                                        color: Color(0xff334155),
                                        fontSize: 18,
                                      ),
                                    ),
                                    subtitle: const LabelTextComponent(
                                      text: 'Anunciante',
                                    ),
                                  ),
                                  const SizedBox(height: 16),
                                  const TitleThreeComponent(text: 'Feedback'),
                                  DetailTextComponent(
                                    text: '$feedback',
                                  ),
                                ],
                              ),
                            ),
                        ],
                      ),
                      const SizedBox(
                        height: 6,
                      ),
                    ],
                  ),
                ),
                _listImagesVaccine.isNotEmpty
                    ? GridView.builder(
                        gridDelegate:
                            const SliverGridDelegateWithMaxCrossAxisExtent(
                          maxCrossAxisExtent: 200,
                          crossAxisSpacing: 16,
                          mainAxisSpacing: 16,
                        ),
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: _listImagesVaccine.length,
                        itemBuilder: (BuildContext context, int index) {
                          return GestureDetector(
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
                          );
                        },
                      )
                    : Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const <Widget>[
                          Icon(
                            Icons.pets,
                            size: 64,
                            color: Color(0xff334155),
                          ),
                          SizedBox(width: 16),
                          DetailTextComponent(text: 'Sem imagens'),
                        ],
                      ),
              ],
            );
          },
        ),
      ),
    );
  }
}
