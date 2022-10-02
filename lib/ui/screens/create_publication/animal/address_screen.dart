import 'package:adoteme/data/controller/address/via_cep_controller.dart';
import 'package:adoteme/data/models/publication_model.dart';
import 'package:adoteme/data/providers/form_key_provider.dart';
import 'package:adoteme/data/providers/id_publication_provider.dart';
import 'package:adoteme/data/service/login_firebase_service.dart';
import 'package:adoteme/data/service/publication_service.dart';
import 'package:adoteme/ui/components/appbars/appbar_to_back_component.dart';
import 'package:adoteme/ui/components/buttons/button_component.dart';
import 'package:adoteme/ui/components/buttons/outline_button_component.dart';
import 'package:adoteme/ui/components/inputs/input_component.dart';
import 'package:adoteme/ui/components/inputs/search_component.dart';
import 'package:adoteme/ui/components/texts/detail_text_component.dart';
import 'package:adoteme/ui/components/texts/title_three_component.dart';
import 'package:adoteme/utils/text_mask.dart';
import 'package:adoteme/utils/validator_inputs.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

class AddressScreen extends StatefulWidget {
  static const routeName = "/create-publication/address";
  const AddressScreen({super.key});

  @override
  State<AddressScreen> createState() => _AddressScreenState();
}

class _AddressScreenState extends State<AddressScreen> {
  String nameCollection = '';
  String nameAppBar = ' ';
  bool _isNotAddress = true;

  final _formKey = GlobalKey<FormState>();

  final TextEditingController _zipCodeController = TextEditingController();
  final TextEditingController _streetController = TextEditingController();
  final TextEditingController _numberController = TextEditingController();
  final TextEditingController _districtController = TextEditingController();
  final TextEditingController _cityController = TextEditingController();
  final TextEditingController _stateController = TextEditingController();
  final TextEditingController _complementController = TextEditingController();

  final ViaCepController _viaCepController = Get.put(ViaCepController());

  final ValueNotifier<String> _idUser = ValueNotifier<String>('');
  final ValueNotifier<String?> _idPublication = ValueNotifier<String?>(null);

  void startData() async {
    var dataPublication = await PublicationService.getPublication(
        _idPublication.value!, 'publications_animal');
    if (dataPublication?.data() != null) {
      _zipCodeController.text = dataPublication?.data()?['address']['zipCode'];
      _streetController.text = dataPublication?.data()?['address']['street'];
      _numberController.text = dataPublication?.data()?['address']['number'];
      _districtController.text =
          dataPublication?.data()?['address']['district'];
      _cityController.text = dataPublication?.data()?['address']['city'];
      _stateController.text = dataPublication?.data()?['address']['state'];
      _complementController.text =
          dataPublication?.data()?['address']['complement'] ?? '';
      setState(() {
        _isNotAddress = false;
      });
    }
  }

  @override
  void initState() {
    final auth = context.read<LoginFirebaseService>();
    _idUser.value = auth.idFirebase();
    final animalModel = context.read<PublicationModel>();
    nameCollection = animalModel.typePublication!;
    nameAppBar = animalModel.typePublication == 'animal_adoption'
        ? 'Criar publicação de adoção'
        : 'Criar publicação de animal perdido';
    final idPublication = context.read<IdPublicationProvider>();
    _idPublication.value = idPublication.get();
    if (_idPublication.value != null && _idUser.value.isNotEmpty) {
      startData();
    }
    super.initState();
  }

  @override
  void dispose() {
    Get.delete<ViaCepController>();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final formKeyProvider = context.watch<FormKeyProvider>();
    formKeyProvider.set(_formKey);
    final animalModel = context.read<PublicationModel>();
    return Scaffold(
      appBar: AppBarToBackComponent(
        title: nameAppBar,
      ),
      body: SafeArea(
        child: ListView(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: <Widget>[
                  Form(
                    key: _formKey,
                    child: Wrap(
                      runSpacing: 24,
                      children: <Widget>[
                        const TitleThreeComponent(
                          text: '3. Endereço',
                        ),
                        const SizedBox(height: 16),
                        const DetailTextComponent(
                          text:
                              'Informe o endereço onde o animal está disponível ou último local que foi visto.',
                        ),
                        SearchComponent(
                            textMask: TextMask('CEP'),
                            keyboardType: TextInputType.number,
                            onChanged: (value) => searchCEP(value),
                            labelTextValue: 'Pesquisar CEP',
                            validator: (value) {
                              return ValidatorInputs.validatorCep(
                                  _isNotAddress, value ?? '');
                            }),
                        InputComponent(
                          iconError: _isNotAddress,
                          controller: _streetController,
                          keyboardType: TextInputType.text,
                          labelTextValue: 'Logradouro',
                          isActive: false,
                        ),
                        InputComponent(
                          controller: _numberController,
                          keyboardType: TextInputType.text,
                          labelTextValue: 'Número',
                          validator: (value) {
                            return ValidatorInputs.validatorText(value);
                          },
                        ),
                        InputComponent(
                          controller: _complementController,
                          isRequired: false,
                          keyboardType: TextInputType.text,
                          labelTextValue: 'Complemento',
                        ),
                        InputComponent(
                          iconError: _isNotAddress,
                          controller: _districtController,
                          keyboardType: TextInputType.text,
                          labelTextValue: 'Bairro',
                          isActive: false,
                        ),
                        InputComponent(
                          iconError: _isNotAddress,
                          controller: _cityController,
                          keyboardType: TextInputType.text,
                          labelTextValue: 'Cidade',
                          isActive: false,
                        ),
                        InputComponent(
                          iconError: _isNotAddress,
                          controller: _stateController,
                          keyboardType: TextInputType.text,
                          labelTextValue: 'Estado',
                          isActive: false,
                        ),
                        InputComponent(
                          iconError: _isNotAddress,
                          controller: _zipCodeController,
                          keyboardType: TextInputType.number,
                          labelTextValue: 'CEP',
                          isActive: false,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 64),
                  ButtonComponent(
                      text: 'Continuar',
                      onPressed: () {
                        saveData(animalModel);
                      }),
                  const SizedBox(height: 16),
                  OutlineButtonComponent(
                    text: 'Cancelar',
                    onPressed: () {
                      Navigator.pushReplacementNamed(
                          context, '/my_publications');
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  searchCEP(String value) async {
    if (value.length == 8) {
      var dataCep = await _viaCepController.fetchViaCep(value);
      if (dataCep.cep == null) {
        setState(() {
          _formKey.currentState!.validate();
          _isNotAddress = true;
        });
      } else {
        setState(() {
          _isNotAddress = false;
        });
      }
      // ignore: use_build_context_synchronously
      final formKeyProvider = context.read<FormKeyProvider>();
      formKeyProvider.get().currentState!.validate();
      _zipCodeController.text = dataCep.cep ?? '';
      _streetController.text = dataCep.logradouro ?? '';
      _numberController.text = dataCep.complemento ?? '';
      _districtController.text = dataCep.bairro ?? '';
      _cityController.text = dataCep.localidade ?? '';
      _stateController.text = dataCep.uf ?? '';
    }
  }

  saveData(animalModel) {
    if (_formKey.currentState!.validate()) {
      Map<String, dynamic> address = {
        'street': _streetController.text,
        'number': _numberController.text,
        'complement': _complementController.text != ''
            ? _complementController.text
            : null,
        'district': _districtController.text,
        'city': _cityController.text,
        'state': _stateController.text,
        'zipCode': _zipCodeController.text,
      };
      animalModel.setAddress(address);
      Navigator.pushNamed(context, '/create-publication/animal_photos');
    }
  }
}
