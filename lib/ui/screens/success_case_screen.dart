import 'package:adoteme/data/bloc/success_case_bloc.dart';
import 'package:adoteme/data/providers/id_publication_provider.dart';
import 'package:adoteme/ui/components/animal_card.dart';
import 'package:adoteme/ui/components/appbars/appbar_component.dart';
import 'package:adoteme/ui/components/drawer_component.dart';
import 'package:adoteme/ui/components/inputs/search_component.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_layout_grid/flutter_layout_grid.dart';
import 'package:provider/provider.dart';

class SuccessCaseScreen extends StatefulWidget {
  static const routeName = "/success_case";

  const SuccessCaseScreen({super.key});

  @override
  State<SuccessCaseScreen> createState() => _SuccessCaseScreenState();
}

class _SuccessCaseScreenState extends State<SuccessCaseScreen> {
  final SuccessCaseBloc _publicationBloc = SuccessCaseBloc();

  @override
  void initState() {
    _publicationBloc.getSuccessCaseAll();
    super.initState();
  }

  @override
  void dispose() {
    _publicationBloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AppBarComponent(
        titulo: 'Casos de sucesso',
      ),
      drawer: DrawerComponent(
        selectIndex: 3,
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
              onChanged: (value) {
                if (value != '') {
                  _publicationBloc.getSuccessCaseSearch(value);
                } else {
                  _publicationBloc.getSuccessCaseAll();
                }
                setState(() {});
              },
            ),
            const SizedBox(
              height: 24,
            ),
            StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
              stream: _publicationBloc.stream,
              builder: (BuildContext context, snapshot) {
                if (snapshot.hasData) {
                  var snapshotData = snapshot.data!.docs;
                  if (snapshotData.isNotEmpty) {
                    final rowSizes = List.generate(
                        (snapshotData.length / 2).round(), (_) => auto);
                    return LayoutBuilder(
                      builder: (context, constraints) {
                        final idPublication =
                            context.read<IdPublicationProvider>();
                        return LayoutGrid(
                          columnSizes: List.generate(
                              (constraints.maxWidth / 220).round(),
                              (_) => 1.fr),
                          rowSizes: rowSizes,
                          rowGap: 8,
                          columnGap: 8,
                          children: <Widget>[
                            for (var element in snapshotData)
                              GestureDetector(
                                child: AnimalCard(
                                  image: element.data()['animalPhotos'][0],
                                  typePublication:
                                      element.data()['typePublication'],
                                  name: element.data()['name'],
                                  district: element.data()['address']
                                      ['district'],
                                  status: element.data()['status'],
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
                                  }
                                },
                              ),
                          ],
                        );
                      },
                    );
                  } else {
                    return const Center(
                      child: Text('Nenhuma publicação encontrada'),
                    );
                  }
                } else if (snapshot.hasError) {
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
