import 'package:adoteme/data/service/login_firebase_service.dart';
import 'package:adoteme/ui/components/buttons/outline_button_component.dart';
import 'package:adoteme/ui/components/texts/detail_text_component.dart';
import 'package:adoteme/ui/components/texts/title_three_component.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

class AlertLoginComponent extends StatelessWidget {
  const AlertLoginComponent({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      titlePadding: const EdgeInsets.only(top: 16, left: 16, right: 16),
      actionsPadding: const EdgeInsets.only(bottom: 16, left: 16, right: 16),
      title: const TitleThreeComponent(text: 'Fazer login para continuar'),
      content: const DetailTextComponent(
        text: 'Ops! Parece que você ainda não fez o login.',
        center: true,
      ),
      actions: <Widget>[
        Row(
          children: [
            Flexible(
              flex: 1,
              child: OutlineButtonComponent(
                text: "",
                onPressed: () async {
                  try {
                    final auth = context.read<LoginFirebaseService>();
                    await auth.signInWithGoogle();
                    if (auth.idFirebase().isNotEmpty) {
                      // ignore: use_build_context_synchronously
                      Navigator.pushReplacementNamed(context, '/favorites');
                    }
                  } catch (e) {
                    if (e is FirebaseAuthException) {}
                  }
                },
                svgIcon: "icon-google",
                islogin: true,
              ),
            ),
            const SizedBox(
              width: 20,
            ),
            Flexible(
              flex: 1,
              child: OutlineButtonComponent(
                text: "",
                onPressed: () async {
                  try {
                    final auth = context.read<LoginFirebaseService>();
                    await auth.signInWithFacebook();
                    if (auth.idFirebase().isNotEmpty) {
                      // ignore: use_build_context_synchronously
                      Navigator.pushReplacementNamed(context, '/user_profile');
                    }
                  } catch (e) {
                    if (e is FirebaseAuthException) {}
                  }
                },
                svgIcon: "icon-facebook",
                islogin: true,
              ),
            ),
          ],
        ),
        const SizedBox(
          height: 32,
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
