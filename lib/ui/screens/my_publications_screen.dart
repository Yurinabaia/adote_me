import 'package:adoteme/ui/components/appbars/appbar_component.dart';
import 'package:adoteme/ui/components/drawer_component.dart';
import 'package:adoteme/ui/components/inputs/search_component.dart';
import 'package:flutter/material.dart';

class MyPublicationsScreen extends StatelessWidget {
  const MyPublicationsScreen({Key? key}) : super(key: key);

  static const routeName = "/my_publications";

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
          onPressed: () => Navigator.of(context).pushNamed('/select_publication'),
          child: const Icon(
            Icons.add,
            size: 40,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: const <Widget>[
            SizedBox(
              height: 24,
            ),
            SeachComponent(
              labelTextValue: 'Pesquisa rápida',
              keyboardType: TextInputType.text,
            ),
            SizedBox(
              height: 24,
            ),
          ],
        ),
      ),
    );
  }
}
