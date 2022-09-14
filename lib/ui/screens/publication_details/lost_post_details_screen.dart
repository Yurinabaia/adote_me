import 'package:adoteme/data/models/publication_model.dart';
import 'package:adoteme/data/providers/id_publication_provider.dart';
import 'package:adoteme/data/service/login_firebase_service.dart';
import 'package:adoteme/data/service/publication_service.dart';
import 'package:adoteme/data/service/user_profile_firebase_service.dart';
import 'package:adoteme/ui/components/alert_dialog_component.dart';
import 'package:adoteme/ui/components/buttons/button_component.dart';
import 'package:adoteme/ui/components/texts/detail_text_component.dart';
import 'package:adoteme/ui/components/texts/label_text_component.dart';
import 'package:adoteme/ui/components/texts/title_three_component.dart';
import 'package:adoteme/ui/screens/publication_details/components/carousel_component.dart';
import 'package:adoteme/ui/screens/publication_details/components/check_favorite_component.dart';
import 'package:adoteme/ui/screens/publication_details/components/contact_component.dart';
import 'package:adoteme/ui/screens/publication_details/components/term_description_component.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:provider/provider.dart';

class LostDetailsScreen extends StatefulWidget {
  static const routeName = "/lost_post_details";

  const LostDetailsScreen({Key? key}) : super(key: key);

  @override
  State<LostDetailsScreen> createState() => _LostDetailsScreenState();
}

class _LostDetailsScreenState extends State<LostDetailsScreen>
    with SingleTickerProviderStateMixin {
  List<String?> _listImagesCarousel = List.filled(6, null);
  List<String> _listFavoritesFirebase = [];

  String? name;
  String? description;
  String? animal;
  String? size;
  String? sex;
  String? breed;
  String? color;
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

  final CarouselController controller = CarouselController();
  final UserProfileFirebaseService userService = UserProfileFirebaseService();

  final ValueNotifier<String?> _idUser = ValueNotifier<String?>(null);
  final ValueNotifier<String?> _idPublication = ValueNotifier<String?>(null);

  int current = 0;
  bool _isSelected = false;
  bool _isMyPublication = false;

  getFavoriteUser() async {
    DocumentSnapshot<Map<String, dynamic>> dataUser =
        await userService.getUserProfile(_idUser.value!);
    if (dataUser.data() != null) {
      setState(() {
        _listFavoritesFirebase =
            List<String>.from(dataUser.data()?['listFavoritesAnimal']);
        _isSelected = _listFavoritesFirebase.contains(_idPublication.value);
      });
    }
  }

  getAdvertiser(String idUser) async {
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
    DocumentSnapshot<Map<String, dynamic>>? dataPublication =
        await PublicationService.getPublication(
            _idPublication.value!, 'publications_animal');

    if (dataPublication?.data() != null) {
      _isMyPublication = dataPublication?.data()?['idUser'] == _idUser.value;
      if (!_isMyPublication) {
        getFavoriteUser();
      }
      getAdvertiser((dataPublication?.data()?['idUser']));
      setState(() {
        _listImagesCarousel =
            List<String>.from(dataPublication!.data()?['animalPhotos']);

        name = dataPublication.data()?['name'];
        description = dataPublication.data()?['description'];
        animal = dataPublication.data()?['animal'];
        size = dataPublication.data()?['size'];
        sex = dataPublication.data()?['sex'];
        breed = dataPublication.data()?['breed'] ?? 'Não informado';
        color = dataPublication.data()?['color'];
        status = dataPublication.data()?['status'];
        feedback = dataPublication.data()?['feedback'];

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
                  animalModel.setTypePublication('animal_lost');
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
            )
          ];
        },
        body: Padding(
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
                                  'listFavoritesAnimal': _listFavoritesFirebase
                                };
                                userService.updateProfile(_idUser.value, data);
                              });
                            },
                            child:
                                CheckFavoriteComponent(isChecked: _isSelected)),
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
                    term: "Tamanho",
                    description: "$size",
                  ),
                  TermDescriptionComponent(
                    term: "Sexo",
                    description: "$sex",
                  ),
                  TermDescriptionComponent(
                    term: "Raça",
                    description: "$breed",
                  ),
                  TermDescriptionComponent(
                    term: "Cor",
                    description: "$color",
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
                          builder: (context) => const AlertDialogComponent(
                            statusType: 'error',
                            title: 'Excluir publicação',
                            message:
                                'A publicação será excluída permanentemente. Deseja prosseguir ?',
                          ),
                        ).then((value) {
                          if (value) {
                            PublicationService.deletePublication(
                                _idPublication.value!, "publications_animal");
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
            ],
          ),
        ),
      ),
    );
  }
}
