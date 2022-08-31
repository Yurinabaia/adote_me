import 'package:adoteme/data/providers/form_key_provider.dart';
import 'package:adoteme/ui/components/appbars/appbar_to_back_component.dart';
import 'package:adoteme/ui/components/buttons/button_component.dart';
import 'package:adoteme/ui/components/buttons/button_outline_component.dart';
import 'package:adoteme/ui/components/inputs/dropdown_component.dart';
import 'package:adoteme/ui/components/inputs/input_component.dart';
import 'package:adoteme/ui/components/texts/title_three_component.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class BasicAnimalDataScreen extends StatefulWidget {
  const BasicAnimalDataScreen({Key? key}) : super(key: key);

  @override
  State<BasicAnimalDataScreen> createState() => _BasicAnimalDataScreenState();
}

class _BasicAnimalDataScreenState extends State<BasicAnimalDataScreen> {
  final TextEditingController _nomeController = TextEditingController();
  final TextEditingController _animalController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();
  final TextEditingController _sizeController = TextEditingController();
  final TextEditingController _sexController = TextEditingController();
  final TextEditingController _temperamentController = TextEditingController();
  final TextEditingController _breedController = TextEditingController();
  final TextEditingController _colorAnimalController = TextEditingController();
  final TextEditingController _castratedController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final formKeyProvider = context.watch<FormKeyProvider>();
    formKeyProvider.set(_formKey);
    return Scaffold(
      appBar: const AppBarToBackComponent(),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: <Widget>[
            const TitleThreeComponent(
              text: '1. Dados Básicos do animal',
            ),
            const SizedBox(height: 32),
            Form(
              key: _formKey,
              child: Wrap(
                runSpacing: 24,
                children: <Widget>[
                  InputComponent(
                      controller: _nomeController,
                      keyboardType: TextInputType.text,
                      labelTextValue: 'Nome'),
                  InputComponent(
                      controller: _animalController,
                      keyboardType: TextInputType.text,
                      labelTextValue: 'Tipo Animal'),
                  InputComponent(
                      controller: _ageController,
                      isRequired: false,
                      keyboardType: TextInputType.number,
                      labelTextValue: 'Idade'),
                  DropDownComponent(
                    labelText: 'Tamanho',
                    items: const [
                      'Mini',
                      'Pequeno',
                      'Médio',
                      'Grande',
                      'Gigante'
                    ],
                    controller: _sizeController,
                  ),
                  DropDownComponent(
                    labelText: 'Sexo',
                    items: const [
                      'Macho',
                      'Fêmea',
                    ],
                    controller: _sexController,
                  ),
                  InputComponent(
                      controller: _temperamentController,
                      isRequired: false,
                      keyboardType: TextInputType.text,
                      labelTextValue: 'Temperamento'),
                  InputComponent(
                      controller: _breedController,
                      isRequired: false,
                      keyboardType: TextInputType.text,
                      labelTextValue: 'Raça'),
                  InputComponent(
                      controller: _colorAnimalController,
                      keyboardType: TextInputType.text,
                      labelTextValue: 'Cor'),
                  DropDownComponent(
                    labelText: 'Castrado',
                    items: const [
                      'Sim',
                      'Não',
                    ],
                    controller: _castratedController,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 64),
            ButtonComponent(
              text: 'Continuar',
              //TODO: implementar o proxima tela de descricao
              onPressed: () {
                if (_formKey.currentState!.validate()) {}
              },
            ),
            const SizedBox(height: 16),
            ButtonOutlineComponent(
              text: 'Cancelar',
              //TODO: Implementar ação de voltar para a Página Inicial
              onPressed: () {},
            ),
          ],
        ),
      ),
    );
  }
}
