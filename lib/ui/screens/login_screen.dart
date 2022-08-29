import 'package:adoteme/data/service/login_firebase_service.dart';
import 'package:adoteme/ui/components/buttons/button_outline_component.dart';
import 'package:adoteme/ui/components/texts/title_three_component.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';

class Login extends StatefulWidget {
  static const routeName = "/login";
  const Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

final FirebaseService service = FirebaseService();

class _LoginState extends State<Login> {
  @override
  void dispose() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                SvgPicture.asset(
                  'assets/images/logo.svg',
                  height: 200,
                  width: 200,
                ),
                Wrap(
                    runSpacing: 16,
                    alignment: WrapAlignment.center,
                    children: const <Widget>[
                      TextThreeComponent(text: "Seja bem-vindo(a)"),
                      Text(
                        "Com nosso aplicativo voçê fará a vida de nossos amigos peludos mais felizes.",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 18,
                          color: Color(0xff334155),
                        ),
                      ),
                    ]),
                Wrap(
                  runSpacing: 16,
                  children: <Widget>[
                    ButtonOutlineComponent(
                      text: "Continuar sem login",
                      onPressed: () {
                        service.clearAuth();
                        Navigator.pushReplacementNamed(
                            context, '/user_profile');
                      },
                      textColor: const Color(0xff334155),
                    ),
                    ButtonOutlineComponent(
                      text: "Entrar com gmail",
                      onPressed: () async {
                        try {
                          await service.signInwithGoogle();
                          if (service.idFirebase().isNotEmpty) {
                            // ignore: use_build_context_synchronously
                            Navigator.pushReplacementNamed(
                                context, '/user_profile');
                          }
                        } catch (e) {
                          if (e is FirebaseAuthException) {}
                        }
                      },
                      svgIcon: "icon-google",
                      textColor: const Color(0xff334155),
                    ),
                    ButtonOutlineComponent(
                      text: "Entrar com facebook",
                      onPressed: () async {
                        try {
                          await service.signInWithFacebook();
                          if (service.idFirebase().isNotEmpty) {
                            // ignore: use_build_context_synchronously
                            Navigator.pushReplacementNamed(
                                context, '/user_profile');
                          }
                        } catch (e) {
                          if (e is FirebaseAuthException) {}
                        }
                      },
                      svgIcon: "icon-facebook",
                      textColor: const Color(0xff334155),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
