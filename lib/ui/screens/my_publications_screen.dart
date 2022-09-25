import 'dart:async';

import 'package:adoteme/data/bloc/my_publications_bloc.dart';
import 'package:adoteme/data/providers/id_publication_provider.dart';
import 'package:adoteme/data/service/address/current_location.dart';
import 'package:adoteme/data/service/login_firebase_service.dart';
import 'package:adoteme/data/service/user_profile_firebase_service.dart';
import 'package:adoteme/ui/components/alerts/alert_complete_registration_component.dart';
import 'package:adoteme/ui/components/appbars/appbar_component.dart';
import 'package:adoteme/ui/components/drawer_component.dart';
import 'package:adoteme/ui/components/informative_card.dart';
import 'package:adoteme/ui/components/inputs/search_component.dart';
import 'package:adoteme/ui/components/animal_card.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_layout_grid/flutter_layout_grid.dart';
import 'package:multiple_stream_builder/multiple_stream_builder.dart';
import 'package:provider/provider.dart';

class MyPublicationsScreen extends StatefulWidget {
  const MyPublicationsScreen({Key? key}) : super(key: key);

  static const routeName = "/my_publications";

  @override
  State<MyPublicationsScreen> createState() => _MyPublicationsScreenState();
}

class _MyPublicationsScreenState extends State<MyPublicationsScreen> {
  final MyPublicationsBloc _publicationAnimalBloc = MyPublicationsBloc();
  final MyPublicationsBloc _publicationInformativeBloc = MyPublicationsBloc();
  final ValueNotifier<String> _idUserNotifier = ValueNotifier<String>('');

  final UserProfileFirebaseService userService = UserProfileFirebaseService();
  final _searchQuery = TextEditingController();
  Timer? _debounce;
  String searchText = "";
  bool _isExistTelephoneUser = false;
  @override
  void initState() {
    var auth = context.read<LoginFirebaseService>();
    _idUserNotifier.value = auth.idFirebase();
    getMyPublicated();
    super.initState();
  }

  getMyPublicated() async {
    var latLongUser = await getDataUser();
    _publicationAnimalBloc.getPublicationsAll('publications_animal',
        _idUserNotifier.value, latLongUser['lat'], latLongUser['long']);
    _publicationInformativeBloc.getPublicationsAll('informative_publication',
        _idUserNotifier.value, latLongUser['lat'], latLongUser['long']);
  }

  getMyPublicatedSearch(String value) async {
    var latLongUser = await getDataUser();
    _publicationAnimalBloc.getPublicationsAnimalSearch('publications_animal',
        _idUserNotifier.value, latLongUser['lat'], latLongUser['long'], value);

    _publicationInformativeBloc.getPublicationsInformativeSearch(
        'informative_publication',
        _idUserNotifier.value,
        latLongUser['lat'],
        latLongUser['long'],
        value);
  }

  Future<Map<dynamic, dynamic>> getDataUser() async {
    double latUser = 0;
    double longUser = 0;
    DocumentSnapshot<Map<String, dynamic>> dataUser =
        await userService.getUserProfile(_idUserNotifier.value);
    if (dataUser.data() != null) {
      latUser = double.parse(dataUser.data()?['lat'].toString() ?? '0');
      longUser = double.parse(dataUser.data()?['long'].toString() ?? '0');

      if (dataUser.data()?['mainCell'] != null) {
        _isExistTelephoneUser = true;
      }
    } else {
      var localizationUser = await CurrentLocation.getPosition();
      latUser = double.parse(localizationUser['lat'].toString());
      longUser = double.parse(localizationUser['long'].toString());
    }
    return {'lat': latUser, 'long': longUser};
  }

  @override
  void dispose() {
    _publicationAnimalBloc.dispose();
    _publicationInformativeBloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AppBarComponent(
        titulo: 'Minhas publicações',
      ),
      drawer: DrawerComponent(
        selectIndex: 2,
      ),
      floatingActionButton: SizedBox(
        height: 70,
        width: 70,
        child: FloatingActionButton(
          backgroundColor: Theme.of(context).primaryColor,
          onPressed: () {
            if (_isExistTelephoneUser) {
              final idPublication = context.read<IdPublicationProvider>();
              idPublication.set(null);
              Navigator.pushNamed(
                  context, '/create-publication/select_publication');
            } else {
              showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return const AlertCompleteRegistrationComponent();
                  });
            }
          },
          child: const Icon(
            Icons.add,
            size: 40,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: <Widget>[
            const SizedBox(
              height: 24,
            ),
            SeachComponent(
              labelTextValue: 'Pesquisa rápida',
              keyboardType: TextInputType.text,
              controller: _searchQuery,
              onChanged: (value) async {
                if (value != '') {
                  _searchQuery.addListener(_onSearchChanged);
                } else {
                  await getMyPublicated();
                }
                setState(() {});
              },
            ),
            const SizedBox(
              height: 24,
            ),
            StreamBuilder2<List<Map<String, dynamic>>,
                List<Map<String, dynamic>>>(
              streams: StreamTuple2(
                _publicationInformativeBloc.stream,
                _publicationAnimalBloc.stream,
              ),
              builder: (BuildContext context, snapshot) {
                if (snapshot.snapshot1.hasData || snapshot.snapshot2.hasData) {
                  var snap = [
                    ...snapshot.snapshot1.data ?? [],
                    ...snapshot.snapshot2.data ?? []
                  ];
                  snap.sort((a, b) => b['updatedAt'].compareTo(a['updatedAt']));
                  if (snap.isNotEmpty) {
                    final idPublication = context.read<IdPublicationProvider>();
                    final rowSizes =
                        List.generate((snap.length / 2).round(), (_) => auto);
                    return LayoutBuilder(builder: (context, constraints) {
                      return LayoutGrid(
                          columnSizes: List.generate(
                              (constraints.maxWidth / 220).round(),
                              (_) => 1.fr),
                          rowSizes: rowSizes,
                          rowGap: 8,
                          columnGap: 8,
                          children: [
                            for (var element in snap)
                              GestureDetector(
                                child: ['animal_lost', 'animal_adoption']
                                        .contains(element['typePublication'])
                                    ? AnimalCard(
                                        image: element['animalPhotos'][0],
                                        typePublication:
                                            element['typePublication'],
                                        name: element['name'],
                                        district: element['address']
                                            ['district'],
                                        status: element['status'],
                                      )
                                    : InformativeCard(
                                        image: element['imageCover'],
                                        title: element['title'],
                                        description: element['description'],
                                      ),
                                onTap: () {
                                  idPublication.set(element['id']);
                                  if (element['typePublication'] ==
                                      'animal_adoption') {
                                    Navigator.pushNamed(
                                        context, '/adoption_post_details');
                                  } else if (element['typePublication'] ==
                                      'animal_lost') {
                                    Navigator.pushNamed(
                                        context, '/lost_post_details');
                                  } else {
                                    Navigator.pushNamed(
                                        context, '/informative_post_details');
                                  }
                                },
                              ),
                          ]);
                    });
                  } else {
                    return const Center(
                      child: Text('Nenhuma publicação encontrada'),
                    );
                  }
                } else if (snapshot.snapshot1.hasError ||
                    snapshot.snapshot2.hasError) {
                  return const Center(
                    child: Text('Erro ao carregar publicações'),
                  );
                }
                return Center(
                  child: Image.asset(
                    'assets/images/dog_animated.gif',
                    height: 200,
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  _onSearchChanged() {
    if (_debounce?.isActive ?? false) _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 400), () async {
      if (searchText != _searchQuery.text) {
        setState(() {
          searchText = _searchQuery.text;
          getMyPublicatedSearch(searchText);
        });
      }
    });
  }
}
