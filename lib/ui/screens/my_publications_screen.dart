import 'package:adoteme/data/bloc/publications_bloc.dart';
import 'package:adoteme/data/providers/id_publication_provider.dart';
import 'package:adoteme/data/service/login_firebase_service.dart';
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
  final PublicationsBloc _publicationAnimalBloc = PublicationsBloc();
  final PublicationsBloc _publicationInformativeBloc = PublicationsBloc();
  final ValueNotifier<String> _idUserNotifier = ValueNotifier<String>('');

  @override
  void initState() {
    var auth = context.read<LoginFirebaseService>();
    _idUserNotifier.value = auth.idFirebase();
    _publicationAnimalBloc.getPublicationsCurrentUser('publications_animal', auth.idFirebase());
    _publicationInformativeBloc.getPublicationsCurrentUser('informative_publication', auth.idFirebase());
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
            final idPublication = context.read<IdPublicationProvider>();
            idPublication.set(null);
            Navigator.pushNamed(context, '/create-publication/select_publication');
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
            const SeachComponent(
              labelTextValue: 'Pesquisa rápida',
              keyboardType: TextInputType.text,
            ),
            const SizedBox(
              height: 24,
            ),
            StreamBuilder2<QuerySnapshot<Map<String, dynamic>>, QuerySnapshot<Map<String, dynamic>>>(
              streams: StreamTuple2(
                _publicationInformativeBloc.stream,
                _publicationAnimalBloc.stream,
                // _publicationsBloc.getPublicationsCurrentUser('publications_animal', _idUserNotifier.value),
                // _publicationsBloc.getPublicationsCurrentUser('informative_publication', _idUserNotifier.value),
              ),
              // stream: _publicationsBloc.streams,
              builder: (context, snapshot) {
                if (snapshot.snapshot1.hasData || snapshot.snapshot2.hasData) {
                  var snapshot1Length = snapshot.snapshot1.data?.size ?? 0;
                  var snapshot2Length = snapshot.snapshot2.data?.size ?? 0;
                  if (snapshot1Length > 0 || snapshot2Length > 0) {
                    final idPublication = context.read<IdPublicationProvider>();
                    final rowSizes = List.generate(
                        (((snapshot.snapshot1.data?.size ?? 0) + (snapshot.snapshot2.data?.size ?? 0)) / 2).round(),
                        (_) => auto);
                    return LayoutBuilder(builder: (context, constraints) {
                      return LayoutGrid(
                          columnSizes: List.generate(
                              (constraints.maxWidth / 220).round(),
                              (_) => 1.fr),
                          rowSizes: rowSizes,
                          rowGap: 8,
                          columnGap: 8,
                          children: <Widget>[
                            for (var element in [
                              ...snapshot.snapshot1.data?.docChanges ?? [],
                              ...snapshot.snapshot2.data?.docChanges ?? []
                            ]) ...[
                              GestureDetector(
                                child: ['animal_lost', 'animal_adoption'].contains(element.doc['typePublication'])
                                    ? AnimalCard(
                                        image: element.doc['animalPhotos'][0],
                                  typePublication:
                                      element.doc['typePublication'],
                                  name: element.doc['name'],
                                  district: element.doc['address']['district'],
                                  //status: element.doc['status'],
                                      )
                                    : InformativeCard(
                                        image: element.doc?['imageCover'],
                                        title: element.doc['title'],
                                        description: element.doc['description'],
                                      ),
                                onTap: () {
                                  idPublication.set(element.doc.id);
                                  if (element.doc['typePublication'] ==
                                      'animal_adoption') {
                                    Navigator.pushNamed(
                                        context, '/adoption_post_details');
                                  } else if (element.doc['typePublication'] ==
                                      'animal_lost') {
                                    Navigator.pushNamed(
                                        context, '/lost_post_details');
                                  }
                                  else {
                                    Navigator.pushNamed(context, '/informative_post_details');
                                  }
                                },
                              ),
                            ]
                          ]);
                    });
                  } else {
                    return const Center(
                      child: Text('Nenhuma publicação encontrada'),
                    );
                  }
                } else if (snapshot.snapshot1.hasError || snapshot.snapshot2.hasError) {
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
