import 'package:adoteme/data/bloc/publications_bloc.dart';
import 'package:adoteme/ui/components/appbars/appbar_component.dart';
import 'package:adoteme/ui/components/drawer_component.dart';
import 'package:adoteme/ui/components/inputs/search_component.dart';
import 'package:adoteme/ui/components/card_layout_grid.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class MyPublicationsScreen extends StatefulWidget {
  const MyPublicationsScreen({Key? key}) : super(key: key);

  static const routeName = "/my_publications";

  @override
  State<MyPublicationsScreen> createState() => _MyPublicationsScreenState();
}

class _MyPublicationsScreenState extends State<MyPublicationsScreen> {
  final PublicationsBloc _publicationAnimalLostBloc = PublicationsBloc();
  @override
  void initState() {
    _publicationAnimalLostBloc.getPublications('publications_animal');
    super.initState();
  }

  @override
  void dispose() {
    _publicationAnimalLostBloc.dispose();
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
          onPressed: () => Navigator.of(context)
              .pushNamed('/create-publication/select_publication'),
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
            StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
              stream: _publicationAnimalLostBloc.streams,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  if (snapshot.data!.size > 0) {
                    return CardLayoutGrid(
                      items: snapshot.data!,
                    );
                  } else {
                    return const Center(
                      child: Text('Nenhuma publicação encontrada'),
                    );
                  }
                } else if (snapshot.hasError || snapshot.data == null) {
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
