import 'package:adoteme/data/bloc/favorites_bloc.dart';
import 'package:adoteme/data/providers/id_publication_provider.dart';
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

  getListFavorites(String idUser) async {
    UserProfileFirebaseService userService = UserProfileFirebaseService();
    DocumentSnapshot<Map<String, dynamic>> user =
        await userService.getUserProfile(idUser);
    setState(() {
      //TODO buscar lista de favoritos do usuario
      List<String?>? listFavoritesAnimal =
          user.data()?['listFavoritesAnimal'] ?? [];
      List<String>? listFavoritesInformative =
          user.data()?['listFavoritesInformative'] ?? [];

      _publicationAnimalBloc.getPublicationsAll(
          'publications_animal', listFavoritesAnimal);
      _publicationInformativeBloc.getPublicationsAll(
          'informative_publication', listFavoritesInformative);
    });
  }

  @override
  void initState() {
    var auth = context.read<LoginFirebaseService>();
    _idUserNotifier.value = auth.idFirebase();
    //getListFavorites(auth.idFirebase());
    //TODO BUSCAR ARRAY NA COLLECTION USER E PEGAR O ID COM ARRAY
    _publicationAnimalBloc.getPublicationsAll('publications_animal',
        ['2sjZSWz3UaGEawCjRiW8', '5Mzd6J3Z12jORkObyhVn']);

    _publicationInformativeBloc.getPublicationsAll(
        'informative_publication', ['1ChZJA5rIh4cQ2MhVdrO']);
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
            StreamBuilder2<QuerySnapshot<Map<String, dynamic>>,
                QuerySnapshot<Map<String, dynamic>>>(
              streams: StreamTuple2(
                _publicationInformativeBloc.stream,
                _publicationAnimalBloc.stream,
              ),
              builder: (BuildContext context, snapshot) {
                if (snapshot.snapshot1.hasData || snapshot.snapshot2.hasData) {
                  var snap = [
                    ...snapshot.snapshot1.data?.docs ?? [],
                    ...snapshot.snapshot2.data?.docs ?? []
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
                                child: [
                                  'animal_lost',
                                  'animal_adoption'
                                ].contains(element.data()['typePublication'])
                                    ? AnimalCard(
                                        image: element.data()['animalPhotos']
                                            [0],
                                        typePublication:
                                            element.data()['typePublication'],
                                        name: element.data()['name'],
                                        district: element.data()['address']
                                            ['district'],
                                        status: element.data()['status'],
                                      )
                                    : InformativeCard(
                                        image: element.data()['imageCover'],
                                        title: element.data()['title'],
                                        description:
                                            element.data()['description'],
                                      ),
                                onTap: () {
                                  idPublication.set(element.id);
                                  if (element.data()['typePublication'] ==
                                      'animal_adoption') {
                                    Navigator.pushNamed(
                                        context, '/adoption_post_details');
                                  } else if (element
                                          .data()['typePublication'] ==
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
}
