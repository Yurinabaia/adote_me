import 'package:adoteme/ui/components/buttons/button_component.dart';
import 'package:adoteme/ui/components/buttons/outline_button_component.dart';
import 'package:adoteme/ui/components/texts/detail_text_component.dart';
import 'package:adoteme/ui/components/texts/title_three_component.dart';
import 'package:flutter/material.dart';

class AlertCompleteRegistrationComponent extends StatelessWidget {
  const AlertCompleteRegistrationComponent({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const TitleThreeComponent(text: 'Cadastro'),
      content: const DetailTextComponent(
        text: 'Para continuar, complete seu cadastro',
        center: true,
      ),
      actions: <Widget>[
        ButtonComponent(
          text: "Completar cadastro",
          onPressed: () {
            Navigator.pushReplacementNamed(context, '/user_profile');
          },
        ),
        const SizedBox(
          height: 12,
        ),
        OutlineButtonComponent(
          text: "Cancelar",
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }
}
