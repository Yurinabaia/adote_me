import 'package:adoteme/data/models/animal_model.dart';
import 'package:adoteme/data/providers/form_key_provider.dart';
import 'package:adoteme/data/service/publication_service.dart';
import 'package:adoteme/data/service/login_firebase_service.dart';
import 'package:adoteme/ui/components/appbars/appbar_to_back_component.dart';
import 'package:adoteme/ui/components/buttons/button_component.dart';
import 'package:adoteme/ui/components/buttons/button_outline_component.dart';
import 'package:adoteme/ui/components/inputs/dropdown_component.dart';
import 'package:adoteme/ui/components/inputs/input_component.dart';
import 'package:adoteme/ui/components/texts/title_three_component.dart';
import 'package:adoteme/utils/text_mask.dart';
import 'package:adoteme/utils/validator_inputs.dart';
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
  String nameCollection = '';
  String nameAppBar = '';
  void startData() async {
    var dataPublication = await PublicationService.getPublication(
        'D4BgUd4AwzANV0Tlcyg3', nameCollection);
    if (dataPublication?.data() != null) {
      if (nameCollection == 'animal_adoption') {
        _ageController.text = dataPublication!.data()!['age'].toString();
        _temperamentController.text = dataPublication.data()!['temperament'];
        _castratedController.text = dataPublication.data()!['castrated'];
      }
      _nameController.text = dataPublication?.data()!['name'];
      _animalController.text = dataPublication?.data()!['animal'];
      _sizeController.text = dataPublication?.data()!['size'];
      _sexController.text = dataPublication?.data()!['sex'];
      _breedController.text = dataPublication?.data()!['breed'];
      _colorAnimalController.text = dataPublication?.data()!['color'];

      setState(() {});
    }
  }

  final ValueNotifier<String> _idUser = ValueNotifier<String>('');
  @override
  void initState() {
    final auth = context.read<LoginFirebaseService>();
    _idUser.value = auth.idFirebase();
    final animalModel = context.read<AnimalModel>();
    nameCollection = animalModel.typePublication!;
    nameAppBar = animalModel.typePublication == 'animal_adoption'
        ? 'Criar publicação de adoção'
        : 'Criar publicação de animal perdido';
    //TODO IMPEMENTAR O IF ABAIXO
    // if (_idPublicated.isNotEmpty && _idUser.value.isNotEmpty) {
    if (_idUser.value.isNotEmpty) {
      startData();
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final formKeyProvider = context.watch<FormKeyProvider>();
    formKeyProvider.set(_formKey);
    final animalModel = context.read<AnimalModel>();
    return Scaffold(
      appBar: AppBarToBackComponent(
        title: nameAppBar,
      ),
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
                    labelTextValue: 'Nome',
                    validator: (value) {
                      return ValidatorInputs.validatorText(value);
                    },
                  ),
                  InputComponent(
                    controller: _animalController,
                    keyboardType: TextInputType.text,
                    labelTextValue: 'Tipo Animal',
                    validator: (value) {
                      return ValidatorInputs.validatorText(value);
                    },
                  ),
                  if (animalModel.typePublication == 'animal_adoption') ...[
                    InputComponent(
                      controller: _ageController,
                      textMask: TextMask('IDADE_ANIMAL'),
                      isRequired: false,
                      keyboardType: TextInputType.number,
                      labelTextValue: 'Idade (meses)',
                    ),
                  ],
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
                    validator: (value) {
                      return ValidatorInputs.validatorText(value);
                    },
                  ),
                  DropDownComponent(
                    labelText: 'Sexo',
                    items: const [
                      'Macho',
                      'Fêmea',
                    ],
                    controller: _sexController,
                    validator: (value) {
                      return ValidatorInputs.validatorText(value);
                    },
                  ),
                  if (animalModel.typePublication == 'animal_adoption') ...[
                    InputComponent(
                        controller: _temperamentController,
                        isRequired: false,
                        keyboardType: TextInputType.text,
                        labelTextValue: 'Temperamento'),
                  ],
                  InputComponent(
                      controller: _breedController,
                      isRequired: false,
                      keyboardType: TextInputType.text,
                      labelTextValue: 'Raça'),
                  InputComponent(
                    controller: _colorAnimalController,
                    keyboardType: TextInputType.text,
                    labelTextValue: 'Cor',
                    validator: (value) {
                      return ValidatorInputs.validatorText(value);
                    },
                  ),
                  if (animalModel.typePublication == 'animal_adoption') ...[
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
                ],
              ),
            ),
            const SizedBox(height: 64),
            ButtonComponent(
              text: 'Continuar',
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  animalModel.setName(_nameController.text);
                  animalModel.setAnimal(_animalController.text);
                  animalModel.setAge(_ageController.text != ''
                      ? int.parse(_ageController.text)
                      : null);
                  animalModel.setSize(_sizeController.text);
                  animalModel.setSex(_sexController.text);
                  animalModel.setTemperament(_temperamentController.text != ''
                      ? _temperamentController.text
                      : null);
                  animalModel.setBreed(_breedController.text != ''
                      ? _breedController.text
                      : null);
                  animalModel.setColor(_colorAnimalController.text);
                  animalModel.setCastrated(_castratedController.text != ''
                      ? _castratedController.text
                      : null);

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
