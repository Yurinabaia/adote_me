import 'package:adoteme/data/providers/form_key_provider.dart';
import 'package:adoteme/data/service/login_firebase_service.dart';
import 'package:adoteme/ui/components/appbars/appbar_to_back_component.dart';
import 'package:adoteme/ui/components/buttons/button_component.dart';
import 'package:adoteme/ui/components/inputs/input_component.dart';
import 'package:adoteme/ui/components/mocal_component.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CreateAccountScreen extends StatefulWidget {
  const CreateAccountScreen({Key? key}) : super(key: key);
  static const routeName = "/register";

  @override
  State<CreateAccountScreen> createState() => _CreateAccountScreenState();
}

class _CreateAccountScreenState extends State<CreateAccountScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    final formKeyProvider = context.watch<FormKeyProvider>();
    formKeyProvider.set(_formKey);
    return Scaffold(
      appBar: const AppBarToBackComponent(
        title: "Criar conta",
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: <Widget>[
            const Icon(
              Icons.person,
              size: 200,
              color: Color(0xff334155),
              // color: Colors.red,
            ),
            Form(
              key: _formKey,
              child: Wrap(
                runSpacing: 16,
                children: [
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
                  const SizedBox(
                    height: 16,
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
                  InputComponent(
                    controller: _confirmPasswordController,
                    keyboardType: TextInputType.visiblePassword,
                    labelTextValue: "Confirmar senha",
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
            const SizedBox(
              height: 40,
            ),
            SizedBox(
              height: 60,
              width: double.infinity,
              child: ButtonComponent(
                text: "Criar conta",
                onPressed: () async {
                  _emailController.text = _emailController.text.trim();

                  if (_passwordController.text !=
                      _confirmPasswordController.text) {
                    snackBar('Senha não coincidem');
                    return;
                  }
                  if (_formKey.currentState!.validate()) {
                    String? erroMessageCreateAccount;
                    final auth = context.read<LoginFirebaseService>();
                    erroMessageCreateAccount =
                        await auth.createUserWithEmailAndPassword(
                            _emailController.text, _passwordController.text);

                    if (erroMessageCreateAccount != null) {
                      snackBar(erroMessageCreateAccount);
                      return;
                    }
                    await auth.sendEmailVerification();

                    ModalComponent.showModal(
                      context: context,
                      message:
                          'Enviamos um e-mail de verificação. Verifique sua caixa de entrada e spam.',
                      action1: () => {Navigator.pushNamed(context, '/login')},
                      text1: 'Fechar',
                    );
                  }
                },
              ),
            ),
          ],
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
