import 'package:adoteme/data/bloc/favorites_bloc.dart';
import 'package:adoteme/data/providers/id_publication_provider.dart';
import 'package:adoteme/data/service/address/current_location.dart';
import 'package:adoteme/data/service/login_firebase_service.dart';
import 'package:adoteme/data/service/user_profile_firebase_service.dart';
import 'package:adoteme/ui/components/animal_card.dart';
import 'package:adoteme/ui/components/appbars/appbar_component.dart';
import 'package:adoteme/ui/components/drawer_component.dart';
import 'package:adoteme/ui/components/informative_card.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_layout_grid/flutter_layout_grid.dart';
import 'package:multiple_stream_builder/multiple_stream_builder.dart';
import 'package:provider/provider.dart';

class FavoritesScreen extends StatefulWidget {
  static const routeName = "/favorites";
  const FavoritesScreen({super.key});
  @override
  State<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  final FavoritesBloc _publicationAnimalBloc = FavoritesBloc();
  final FavoritesBloc _publicationInformativeBloc = FavoritesBloc();
  final ValueNotifier<String> _idUserNotifier = ValueNotifier<String>('');
  final UserProfileFirebaseService userService = UserProfileFirebaseService();

  getListFavorites() async {
    UserProfileFirebaseService userService = UserProfileFirebaseService();
    DocumentSnapshot<Map<String, dynamic>> user =
        await userService.getUserProfile(_idUserNotifier.value);
    List<String?>? listFavoritesAnimal =
        List<String?>.from(user.data()?['listFavoritesAnimal'] ?? []);
    List<String?>? listFavoritesInformative =
        List<String?>.from(user.data()?['listFavoritesInformative'] ?? []);

    var latLongUser = await getDataUser();
    _publicationAnimalBloc.getPublicationsAll(
      'publications_animal',
      listFavoritesAnimal,
      latLongUser['lat'],
      latLongUser['long'],
    );
    _publicationInformativeBloc.getPublicationsAll(
      'informative_publication',
      listFavoritesInformative,
      latLongUser['lat'],
      latLongUser['long'],
    );
  }

  Future<Map<dynamic, dynamic>> getDataUser() async {
    double latUser = 0;
    double longUser = 0;
    DocumentSnapshot<Map<String, dynamic>> dataUser =
        await userService.getUserProfile(_idUserNotifier.value);
    if (dataUser.data() != null) {
      latUser = double.parse(dataUser.data()?['lat'].toString() ?? '0');
      longUser = double.parse(dataUser.data()?['long'].toString() ?? '0');
    } else {
      var localizationUser = await CurrentLocation.getPosition();
      latUser = double.parse(localizationUser['lat'].toString());
      longUser = double.parse(localizationUser['long'].toString());
    }
    return {'lat': latUser, 'long': longUser};
  }

  @override
  void initState() {
    var auth = context.read<LoginFirebaseService>();
    _idUserNotifier.value = auth.idFirebase();
    getListFavorites();
    super.initState();
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
        titulo: 'Favoritos',
      ),
      drawer: DrawerComponent(
        selectIndex: 1,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: <Widget>[
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
                          children: <Widget>[
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
                                        distance: element['distance'],
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
                                    Navigator.of(context).pushNamed(
                                      '/adoption_post_details',
                                      arguments: 'favoritos',
                                    );
                                  } else if (element['typePublication'] ==
                                      'animal_lost') {
                                    Navigator.of(context).pushNamed(
                                      '/lost_post_details',
                                      arguments: 'favoritos',
                                    );
                                  } else {
                                    Navigator.of(context).pushNamed(
                                      '/informative_post_details',
                                      arguments: 'favoritos',
                                    );
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
}
