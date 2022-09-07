import 'package:adoteme/data/service/login_firebase_service.dart';
import 'package:adoteme/ui/components/buttons/button_outline_component.dart';
import 'package:adoteme/ui/components/texts/title_three_component.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatefulWidget {
  static const routeName = "/login";
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScrenState();
}

class _LoginScrenState extends State<LoginScreen> {
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
                      TitleThreeComponent(text: "Seja bem-vindo(a)"),
                      Text(
                        "Com nosso aplicativo você fará a vida de nossos amigos peludos mais feliz.",
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
                      onPressed: () async {
                        final auth = context.read<LoginFirebaseService>();
                        await auth.signOut();
                        // ignore: use_build_context_synchronously
                        Navigator.pushReplacementNamed(
                            context, '/user_profile');
                      },
                      islogin: true,
                    ),
                    ButtonOutlineComponent(
                      text: "Entrar com gmail",
                      onPressed: () async {
                        try {
                          final auth = context.read<LoginFirebaseService>();
                          await auth.signInWithGoogle();
                          if (auth.idFirebase().isNotEmpty) {
                            // ignore: use_build_context_synchronously
                            Navigator.pushReplacementNamed(
                                context, '/lost_post_details');
                          }
                        } catch (e) {
                          if (e is FirebaseAuthException) {}
                        }
                      },
                      svgIcon: "icon-google",
                      islogin: true,
                    ),
                    ButtonOutlineComponent(
                      text: "Entrar com facebook",
                      onPressed: () async {
                        try {
                          final auth = context.read<LoginFirebaseService>();
                          await auth.signInWithFacebook();
                          if (auth.idFirebase().isNotEmpty) {
                            // ignore: use_build_context_synchronously
                            Navigator.pushReplacementNamed(
                                context, '/user_profile');
                          }
                        } catch (e) {
                          if (e is FirebaseAuthException) {}
                        }
                      },
                      svgIcon: "icon-facebook",
                      islogin: true,
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
