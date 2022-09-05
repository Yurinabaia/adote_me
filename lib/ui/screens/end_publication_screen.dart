import 'package:adoteme/ui/components/alert_dialog_component.dart';
import 'package:adoteme/ui/components/appbars/appbar_to_back_component.dart';
import 'package:adoteme/ui/components/buttons/button_component.dart';
import 'package:adoteme/ui/components/texts/detail_text_component.dart';
import 'package:adoteme/ui/components/texts/textarea_component.dart';
import 'package:flutter/material.dart';

class EndPublicationScreen extends StatefulWidget {
  const EndPublicationScreen({Key? key}) : super(key: key);

  static const routeName = "/end_publication";

  @override
  State<EndPublicationScreen> createState() => _EndPublicationScreenState();
}

class _EndPublicationScreenState extends State<EndPublicationScreen> {
  TextEditingController controllerTextArea = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AppBarToBackComponent(title: 'Finalizar publicação'),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: <Widget>[
            const Text(
              'Meus parabéns!!👏🥳🎉',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Color(0xff334155),
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(
              height: 16,
            ),
            const DetailTextComponent(
              text:
                  'Sua publicação o atingiu o objetivo. Deixe um feedback para que outras pessoas sejam motivadas com esse caso de sucesso.',
            ),
            const SizedBox(
              height: 32,
            ),
            TextareaComponent(
              controller: controllerTextArea,
              hint: 'Deixe o seu feedback aqui',
            ),
            const SizedBox(
              height: 64,
            ),
            ButtonComponent(
              text: 'Enviar feedback',
              color: const Color(0xff21725E),
              onPressed: () {
                AlertDialogComponent(
                  statusType: 'success',
                  title: 'Finalizar publicação',
                  message:
                      'Após a finalização, a publicação e o feedback não poderão ser alterados. Deseja finalizar ?',
                ).showAlert(context);
              },
            ),
          ],
        ),
      ),
    );
  }
}
