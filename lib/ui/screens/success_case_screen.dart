import 'dart:async';

import 'package:adoteme/data/bloc/success_case_bloc.dart';
import 'package:adoteme/data/providers/filter_provider.dart';
import 'package:adoteme/data/providers/id_publication_provider.dart';
import 'package:adoteme/ui/components/animal_card.dart';
import 'package:adoteme/ui/components/appbars/appbar_component.dart';
import 'package:adoteme/ui/components/drawers/filter_drawer_component.dart';
import 'package:adoteme/ui/components/drawers/menu_drawer_component.dart';
import 'package:adoteme/ui/components/inputs/search_component.dart';
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
  final _searchQuery = TextEditingController();
  Timer? _debounce;
  String searchText = "";
  @override
  void initState() {
    _publicationBloc
        .getSuccessCaseAll(context.read<FilterProvider>().objFilter());
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
      drawer: MenuDrawerComponent(
        selectIndex: 3,
      ),
      endDrawer:
          const FilterDrawerComponent(routeName: SuccessCaseScreen.routeName),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: <Widget>[
            const SizedBox(
              height: 24,
            ),
            SearchComponent(
              labelTextValue: 'Pesquisa rápida',
              keyboardType: TextInputType.text,
              controller: _searchQuery,
              onChanged: (value) async {
                if (value != '') {
                  _searchQuery.addListener(_onSearchChanged);
                } else {
                  _publicationBloc.getSuccessCaseAll(
                      context.read<FilterProvider>().objFilter());
                }
                setState(() {});
              },
            ),
            const SizedBox(
              height: 24,
            ),
            StreamBuilder<List<Map<String, dynamic>>>(
              stream: _publicationBloc.stream,
              builder: (BuildContext context, snapshot) {
                if (snapshot.hasData) {
                  var snapshotData = snapshot.data ?? [];
                  snapshotData
                      .sort((a, b) => b['updatedAt'].compareTo(a['updatedAt']));
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
                                  image: element['animalPhotos'][0],
                                  typePublication: element['typePublication'],
                                  name: element['name'],
                                  district: element['address']['district'],
                                  status: element['status'],
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

  _onSearchChanged() {
    if (_debounce?.isActive ?? false) _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 400), () async {
      if (searchText != _searchQuery.text) {
        setState(() {
          searchText = _searchQuery.text;
          _publicationBloc.getSuccessCaseSearch(
              searchText, context.read<FilterProvider>().objFilter());
        });
      }
    });
  }
}
