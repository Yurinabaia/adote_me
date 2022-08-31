import 'package:adoteme/ui/components/appbars/appbar_to_back_component.dart';
import 'package:adoteme/ui/components/buttons/button_component.dart';
import 'package:adoteme/ui/components/buttons/button_outline_component.dart';
import 'package:adoteme/ui/components/texts/detail_text_component.dart';
import 'package:adoteme/ui/components/texts/title_three_component.dart';
import 'package:adoteme/ui/screens/create_publication/animal_adoption/components/photo_animal_component.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class AnimalPhotosScreen extends StatefulWidget {
  static const routeName = "/animal_photos";

  const AnimalPhotosScreen({Key? key}) : super(key: key);

  @override
  State<AnimalPhotosScreen> createState() => _AnimalPhotosScreenState();
}

class _AnimalPhotosScreenState extends State<AnimalPhotosScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AppBarToBackComponent(),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: <Widget>[
            const Center(
              child: TitleThreeComponent(text: '3. Fotos do animal'),
            ),
            const Center(
              child: DetailTextComponent(text: 'Envie pelo menos uma foto do animal'),
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
              itemCount: 6,
              itemBuilder: (BuildContext context, int index) {
                return const PhotoAnimalComponent();
              },
            ),
            const SizedBox(
              height: 64,
            ),
            ButtonComponent(
              text: 'Continuar',
              // TODO: Implementar a navegação para a próxima tela
              onPressed: () {},
            ),
            const SizedBox(
              height: 16,
            ),
            ButtonOutlineComponent(
              text: 'Cancelar',
              // TODO: implementar ação de cancelar
              onPressed: () {},
            ),
          ],
        ),
      ),
    );
  }
}
