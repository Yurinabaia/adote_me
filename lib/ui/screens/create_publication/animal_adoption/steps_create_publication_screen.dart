import 'package:adoteme/ui/components/appbars/appbar_to_back_component.dart';
import 'package:adoteme/ui/components/buttons/button_component.dart';
import 'package:adoteme/ui/components/texts/body_text_component.dart';
import 'package:adoteme/ui/components/texts/detail_text_component.dart';
import 'package:adoteme/ui/components/texts/title_three_component.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class StepsCreatePublicationScreen extends StatelessWidget {
  static const routeName = "/steps_create_publication";

  const StepsCreatePublicationScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AppBarToBackComponent(),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: <Widget>[
            const TitleThreeComponent(
              text: 'Passos para criar uma publicação',
            ),
            const SizedBox(
              height: 32,
            ),
            SvgPicture.asset(
              'assets/images/post_online.svg',
              height: 200,
              width: 200,
            ),
            const SizedBox(
              height: 32,
            ),
            const BodyTextComponent(
              text: '1. Dados básicos do animal',
              fontWeight: FontWeight.w600,
            ),
            const DetailTextComponent(
              text:
                  'Pedimos nome, idade, tamanho, sexo, temperamento, raça, cor',
            ),
            const SizedBox(
              height: 20,
            ),
            const BodyTextComponent(
              text: '2. Informações adicionais',
              fontWeight: FontWeight.w600,
            ),
            const DetailTextComponent(
              text:
                  'Informações adicionais que possam ser relevantes para encontrar um novo lar para o animal, motivo da doação ou mais detalhes sobre o animal perdido.',
            ),
            const SizedBox(
              height: 20,
            ),
            const BodyTextComponent(
              text: '3. Fotos do animal',
              fontWeight: FontWeight.w600,
            ),
            const DetailTextComponent(
              text:
                  'Para identificar o animal e permitir que as pessoas interessadas em adotar possam ver mais detalhes de sua aparência.',
            ),
            const SizedBox(
              height: 20,
            ),
            const BodyTextComponent(
              text: '4. Fotos do cartão de vacina',
              fontWeight: FontWeight.w600,
            ),
            const DetailTextComponent(
              text:
                  'Para identificar as vacinas que o animal possui e faltantes.',
            ),
            const SizedBox(
              height: 40,
            ),
            ButtonComponent(
              text: 'Continuar',
              onPressed: () {
                Navigator.of(context).pushNamed('/create-publication/basic_animal_data');
              },
            ),
          ],
        ),
      ),
    );
  }
}
