import 'package:adoteme/data/service/login_firebase_service.dart';
import 'package:adoteme/ui/components/appbars/appbar_to_back_component.dart';
import 'package:adoteme/ui/components/buttons/button_component.dart';
import 'package:adoteme/ui/components/inputs/input_component.dart';
import 'package:adoteme/ui/components/mocal_component.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class RestorePasswordScreen extends StatefulWidget {
  const RestorePasswordScreen({Key? key}) : super(key: key);
  static const routeName = "/restore-password";

  @override
  State<RestorePasswordScreen> createState() => _RestorePasswordScreenState();
}

class _RestorePasswordScreenState extends State<RestorePasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AppBarToBackComponent(
        title: "Recuperar senha",
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: <Widget>[
            const Text(
              'Por favor, entre com seu endereço de e-mail. Você recebera um link para criar uma nova senha.',
              style: TextStyle(
                color: Colors.white70,
                fontSize: 16,
              ),
            ),
            const SizedBox(
              height: 40,
            ),
            Form(
              key: _formKey,
              child: InputComponent(
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
            ),
            const SizedBox(
              height: 40,
            ),
            SizedBox(
              height: 60,
              width: double.infinity,
              child: ButtonComponent(
                text: 'Enviar',
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    final auth = context.read<LoginFirebaseService>();
                    _emailController.text = _emailController.text.trim();
                    if (_formKey.currentState!.validate()) {
                      auth.resetPassword(_emailController.text);
                      ModalComponent.showModal(
                        context: context,
                        message:
                            'Enviamos um e-mail de recuperação de senha. Verifique sua caixa de entrada e spam.',
                        action1: () => {Navigator.pushNamed(context, '/login')},
                        text1: 'Fechar',
                      );
                    }
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
