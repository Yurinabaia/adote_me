import 'package:adoteme/data/providers/form_key_provider.dart';
import 'package:adoteme/data/service/login_firebase_service.dart';
import 'package:adoteme/ui/components/buttons/button_component.dart';
import 'package:adoteme/ui/components/buttons/outline_button_component.dart';
import 'package:adoteme/ui/components/inputs/input_component.dart';
import 'package:adoteme/ui/components/mocal_component.dart';
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
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

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
    final formKeyProvider = context.watch<FormKeyProvider>();
    formKeyProvider.set(_formKey);
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
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
                  const SizedBox(
                    height: 32,
                  ),
                  Wrap(
                    runSpacing: 16,
                    children: [
                      Form(
                        key: _formKey,
                        child: Wrap(
                          runSpacing: 16,
                          children: <Widget>[
                            InputComponent(
                              controller: _emailController,
                              keyboardType: TextInputType.emailAddress,
                              labelTextValue: 'Email',
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Por favor, insira um email';
                                }
                                return null;
                              },
                              isRequired: true,
                            ),
                            InputComponent(
                              controller: _passwordController,
                              keyboardType: TextInputType.visiblePassword,
                              labelTextValue: "Senha",
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Por favor, insira uma senha';
                                }
                                return null;
                              },
                              isRequired: true,
                              isPassword: true,
                            ),
                          ],
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.pushNamed(context, '/restore-password');
                        },
                        style: TextButton.styleFrom(
                          padding: const EdgeInsets.all(0),
                        ),
                        child: const Text(
                          'Esqueceu sua senha?',
                          style: TextStyle(
                            color: Color(0xff334155),
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ),
                      ButtonComponent(
                        text: 'Entrar',
                        onPressed: () async {
                          _emailController.text = _emailController.text.trim();
                          if (!_formKey.currentState!.validate()) {
                            return;
                          }
                          final auth = context.read<LoginFirebaseService>();
                          try {
                            bool isloginEP =
                                await auth.signInWithEmailAndPassword(
                                    _emailController.text,
                                    _passwordController.text);

                            if (!isloginEP) {
                              snackBar('E-mail e/ou senhas incorretos.');
                              return;
                            }

                            if (!await auth.isEmailVerified()) {
                              ModalComponent.showModal(
                                context: context,
                                message:
                                    'Verifique sua caixa de entrada e spam',
                                action1: () => {
                                  auth.sendEmailVerification(),
                                  Navigator.pop(context)
                                },
                                text1: 'Reenviar e-mail',
                                action2: () => {Navigator.pop(context)},
                                text2: 'Fechar',
                              );
                              return;
                            }
                            // ignore: use_build_context_synchronously
                            Navigator.pushReplacementNamed(context, '/home');
                          } catch (e) {
                            if (e is FirebaseAuthException) {
                              snackBar(e.message!);
                            }
                          }
                        },
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.pushNamed(context, '/register');
                        },
                        child: RichText(
                          text: const TextSpan(
                            text: 'Ainda não possui uma conta? ',
                            style: TextStyle(
                              color: Color(0xff334155),
                            ),
                            children: <TextSpan>[
                              TextSpan(
                                text: "Registre-se",
                                style: TextStyle(
                                  color: Color(0xff334155),
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Divider(
                        color: Theme.of(context).primaryColor,
                        height: 20,
                      ),
                      OutlineButtonComponent(
                        text: "Continuar sem login",
                        onPressed: () async {
                          final auth = context.read<LoginFirebaseService>();
                          await auth.signOut();
                          // ignore: use_build_context_synchronously
                          Navigator.pushReplacementNamed(context, '/home');
                        },
                        islogin: true,
                      ),
                      OutlineButtonComponent(
                        text: "Entrar com gmail",
                        onPressed: () async {
                          try {
                            final auth = context.read<LoginFirebaseService>();
                            await auth.signInWithGoogle();
                            if (auth.idFirebase().isNotEmpty) {
                              // ignore: use_build_context_synchronously
                              Navigator.pushReplacementNamed(context, '/home');
                            }
                          } catch (e) {
                            if (e is FirebaseAuthException) {}
                          }
                        },
                        svgIcon: "icon-google",
                        islogin: true,
                      ),
                      OutlineButtonComponent(
                        text: "Entrar com facebook",
                        onPressed: () async {
                          try {
                            final auth = context.read<LoginFirebaseService>();
                            await auth.signInWithFacebook();
                            if (auth.idFirebase().isNotEmpty) {
                              // ignore: use_build_context_synchronously
                              Navigator.pushReplacementNamed(context, '/home');
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
      ),
    );
  }

  snackBar(message) {
    final snack = SnackBar(
      behavior: SnackBarBehavior.floating,
      content: Text(message),
      backgroundColor: Colors.red,
      padding: const EdgeInsets.all(16),
    );
    ScaffoldMessenger.of(context).showSnackBar(snack);
  }
}
