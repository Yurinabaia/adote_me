import 'package:adoteme/ui/components/appbars/appbar_to_back_component.dart';
import 'package:adoteme/ui/components/buttons/button_component.dart';
import 'package:adoteme/ui/components/buttons/button_outline_component.dart';
import 'package:adoteme/ui/components/texts/detail_text_component.dart';
import 'package:adoteme/ui/components/texts/title_three_component.dart';
import 'package:adoteme/ui/screens/create_publication/animal_adoption/components/photo_animal_component.dart';
import 'package:flutter/material.dart';

class PicturesVaccineCardScreen extends StatefulWidget {
  static const routeName = "/pictures_vaccine_Card";

  const PicturesVaccineCardScreen({Key? key}) : super(key: key);

  @override
  State<PicturesVaccineCardScreen> createState() => _PicturesVaccineCardScreen();
}

class _PicturesVaccineCardScreen extends State<PicturesVaccineCardScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AppBarToBackComponent(),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: <Widget>[
            const Center(
              child: TitleThreeComponent(text: '4. Fotos do cartão de vacina'),
            ),
            const Center(
              child: DetailTextComponent(text: 'As fotos do cartão de vacina são opcionais.'),
            ),
            const SizedBox(
              height: 32,
            ),
            GridView.builder(
              gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                maxCrossAxisExtent: 200,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
              ),
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: 4,
              itemBuilder: (BuildContext context, int index) {
                return const PhotoAnimalComponent();
              },
            ),
            const SizedBox(
              height: 64,
            ),
            ButtonComponent(
              text: 'Publicar',
              // TODO: Implementar a ação para salvar a publicação
              onPressed: () {},
            ),
            const SizedBox(
              height: 16,
            ),
            ButtonOutlineComponent(
              text: 'Cancelar',
              // TODO: implementar ação de cancelar a criação da publicação
              onPressed: () {},
            ),
          ],
        ),
      ),
    );
  }
}
