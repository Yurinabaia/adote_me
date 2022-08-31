import 'package:adoteme/ui/components/appbars/appbar_to_back_component.dart';
import 'package:adoteme/ui/screens/create_publication/component/publication_card_component.dart';
import 'package:flutter/material.dart';

class SelectPublicationScreen extends StatelessWidget {
  const SelectPublicationScreen({Key? key}) : super(key: key);

  static const routeName = "/select_publication";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AppBarToBackComponent(),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: GridView(
          gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
            maxCrossAxisExtent: 200,
            childAspectRatio: .75,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
          ),
          children: const <Widget>[
            PublicationCardComponent(
              title: 'Animal para Adoção',
              image: 'cat',
              color: Color(0xffE0CE2C),
              route: '/steps_create_publication',
            ),
            PublicationCardComponent(
              title: 'Animal perdido',
              image: 'dog',
              color: Color(0xffA82525),
              // TODO: Implementar rota para a interface publicação de animal perdido
              route: '',
            ),
            PublicationCardComponent(
              title: 'Informativo',
              image: 'info',
              color: Color(0xff2789E3),
              // TODO: Implementar rota para a interface de criação de publicação de informativo
              route: '',
            ),
          ],
        ),
      ),
    );
  }
}
