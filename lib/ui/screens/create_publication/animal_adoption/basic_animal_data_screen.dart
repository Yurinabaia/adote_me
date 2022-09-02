import 'package:adoteme/data/models/animal_model.dart';
import 'package:adoteme/data/providers/form_key_provider.dart';
import 'package:adoteme/data/service/create_publication.dart';
import 'package:adoteme/ui/components/appbars/appbar_to_back_component.dart';
import 'package:adoteme/ui/components/buttons/button_component.dart';
import 'package:adoteme/ui/components/buttons/button_outline_component.dart';
import 'package:adoteme/ui/components/inputs/dropdown_component.dart';
import 'package:adoteme/ui/components/inputs/input_component.dart';
import 'package:adoteme/ui/components/texts/title_three_component.dart';
import 'package:adoteme/utils/text_mask.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class BasicAnimalDataScreen extends StatefulWidget {
  static const routeName = "/create-publication/basic_animal_data";
  const BasicAnimalDataScreen({Key? key}) : super(key: key);

  @override
  State<BasicAnimalDataScreen> createState() => _BasicAnimalDataScreenState();
}

class _BasicAnimalDataScreenState extends State<BasicAnimalDataScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _animalController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();
  final TextEditingController _sizeController = TextEditingController();
  final TextEditingController _sexController = TextEditingController();
  final TextEditingController _temperamentController = TextEditingController();
  final TextEditingController _breedController = TextEditingController();
  final TextEditingController _colorAnimalController = TextEditingController();
  final TextEditingController _castratedController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  void startData() async {
    var dataPublication =
        await CreatePublicationService.getPublication('OMV59MpLx31zpIBMhDf2');
    if (dataPublication.data() != null) {
      _nameController.text = dataPublication.data()!['name'];
      _animalController.text = dataPublication.data()!['animal'];
      _ageController.text = dataPublication.data()!['age'].toString();
      _sizeController.text = dataPublication.data()!['size'];
      _sexController.text = dataPublication.data()!['sex'];
      _temperamentController.text = dataPublication.data()!['temperament'];
      _breedController.text = dataPublication.data()!['breed'];
      _colorAnimalController.text = dataPublication.data()!['color'];
      _castratedController.text = dataPublication.data()!['castrated'];

      setState(() {});
    }
  }

  @override
  void initState() {
    startData();
    super.initState();
  }

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
                      controller: _nameController,
                      keyboardType: TextInputType.text,
                      labelTextValue: 'Nome'),
                  InputComponent(
                      controller: _animalController,
                      keyboardType: TextInputType.text,
                      labelTextValue: 'Tipo Animal'),
                  InputComponent(
                      controller: _ageController,
                      textMask: TextMask('IDADE_ANIMAL'),
                      isRequired: false,
                      keyboardType: TextInputType.number,
                      labelTextValue: 'Idade (meses)'),
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
                    isRequired: false,
                    controller: _castratedController,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 64),
            ButtonComponent(
              text: 'Continuar',
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  final animalModel = context.read<AnimalModel>();
                  animalModel.setName(_nameController.text);
                  animalModel.setAnimal(_animalController.text);

                  animalModel.setAge(int.parse(
                      _ageController.text != '' ? _ageController.text : '0'));

                  animalModel.setSize(_sizeController.text);
                  animalModel.setSex(_sexController.text);
                  animalModel.setTemperament(_temperamentController.text);
                  animalModel.setBreed(_breedController.text);
                  animalModel.setColor(_colorAnimalController.text);
                  animalModel.setCastrated(_castratedController.text);

                  Navigator.pushNamed(
                      context, '/create-publication/details_animal');
                }
              },
            ),
            const SizedBox(height: 16),
            ButtonOutlineComponent(
              text: 'Cancelar',
              onPressed: () {
                Navigator.pushReplacementNamed(context, '/my_publications');
              },
            ),
          ],
        ),
      ),
    );
  }
}
