// ignore_for_file: use_build_context_synchronously

import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:adoteme/data/controller/address/via_cep_controller.dart';
import 'package:adoteme/data/providers/form_key_provider.dart';
import 'package:adoteme/data/service/login_firebase_service.dart';
import 'package:adoteme/data/service/user_profile_firebase_service.dart';
import 'package:adoteme/ui/components/appbars/appbar_component.dart';
import 'package:adoteme/ui/components/buttons/button_component.dart';
import 'package:adoteme/ui/components/buttons/button_outline_component.dart';
import 'package:adoteme/ui/components/circle_avatar_component.dart';
import 'package:adoteme/ui/components/drawer_component.dart';
import 'package:adoteme/ui/components/inputs/input_component.dart';
import 'package:adoteme/ui/components/inputs/search_component.dart';
import 'package:adoteme/ui/components/loading_modal_component.dart';
import 'package:adoteme/ui/components/texts/title_three_component.dart';
import 'package:adoteme/utils/text_mask.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

class UserProfileScreen extends StatefulWidget {
  static const routeName = "/user_profile";
  const UserProfileScreen({Key? key}) : super(key: key);

  @override
  State<UserProfileScreen> createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _mainCellController = TextEditingController();
  final TextEditingController _optionalCellController = TextEditingController();
  final TextEditingController _optionalCell2Controller =
      TextEditingController();
  final TextEditingController _zipCodeController = TextEditingController();
  final TextEditingController _streetController = TextEditingController();
  final TextEditingController _numberController = TextEditingController();
  final TextEditingController _districtController = TextEditingController();
  final TextEditingController _cityController = TextEditingController();
  final TextEditingController _stateController = TextEditingController();
  final TextEditingController _complementController = TextEditingController();

  final ValueNotifier<String> _idUser = ValueNotifier('');
  final ValueNotifier<String> _emailUser = ValueNotifier('');

  PlatformFile? _file;
  Uint8List? _imgFirebase;

  UserProfileFirebaseService userProfileFirebaseService =
      UserProfileFirebaseService();

  final _formKey = GlobalKey<FormState>();

  final ViaCepController _viaCepController = Get.put(ViaCepController());
  bool _isNotAddress = false;
  Future selectFile() async {
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['jpg', 'png'],
      );
      if (result != null) {
        setState(() {
          _file = result.files.first;
          _imgFirebase = null;
        });
      }
    } catch (e) {
      rethrow;
    }
  }

  void startData() async {
    var dataUser =
        await userProfileFirebaseService.getUserProfile(_idUser.value);
    if (dataUser.data() != null) {
      _nameController.text = dataUser.data()!['name'];
      _mainCellController.text = dataUser.data()!['mainCell'];
      _optionalCellController.text = dataUser.data()!['optionalCell'];
      _optionalCell2Controller.text = dataUser.data()!['optionalCell2'];
      _zipCodeController.text = dataUser.data()!['zipCode'];
      _streetController.text = dataUser.data()!['street'];
      _numberController.text = dataUser.data()!['number'];
      _districtController.text = dataUser.data()!['district'];
      _cityController.text = dataUser.data()!['city'];
      _stateController.text = dataUser.data()!['state'];
      _complementController.text = dataUser.data()!['complement'];
      if (dataUser.data()!['image'] != null) {
        setState(() {
          _imgFirebase = base64Decode(dataUser.data()!['image']);
        });
      }
    }
  }

  @override
  void initState() {
    final auth = context.read<LoginFirebaseService>();
    _idUser.value = auth.idFirebase();
    if (_idUser.value.isNotEmpty) {
      _emailUser.value = auth.emailFirebase();
      startData();
    }
    _emailController.text = _emailUser.value;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final formKeyProvider = context.watch<FormKeyProvider>();
    formKeyProvider.set(_formKey);
    return Scaffold(
      appBar: const AppBarComponent(titulo: 'Perfil'),
      drawer: DrawerComponent(
        selectIndex: 4,
      ),
      body: SafeArea(
        child: ListView(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: <Widget>[
                  Center(
                    child: GestureDetector(
                      onTapUp: (TapUpDetails details) {
                        _file != null || _imgFirebase != null
                            ? _showPopupMenu(details.globalPosition)
                            : selectFile();
                      },
                      child: Stack(
                        children: <Widget>[
                          CircleAvatarComponent.findCircleAvatar(
                              imgFirebase: _imgFirebase, file: _file),
                          Positioned(
                            bottom: 0,
                            right: 0,
                            child: Container(
                              padding: const EdgeInsets.all(12.0),
                              decoration: BoxDecoration(
                                color: Theme.of(context).primaryColor,
                                borderRadius: BorderRadius.circular(50),
                              ),
                              child: const Icon(
                                Icons.edit,
                                size: 24,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),
                  Form(
                    key: _formKey,
                    child: Wrap(
                      runSpacing: 24,
                      children: <Widget>[
                        InputComponent(
                          controller: _nameController,
                          labelTextValue: 'Nome',
                          keyboardType: TextInputType.text,
                        ),
                        InputComponent(
                          controller: _emailController,
                          labelTextValue: 'Email',
                          keyboardType: TextInputType.emailAddress,
                          isActive: false,
                        ),
                        InputComponent(
                          textMask: TextMask('CELL'),
                          controller: _mainCellController,
                          keyboardType: TextInputType.phone,
                          labelTextValue: 'Whatsapp',
                        ),
                        InputComponent(
                          textMask: TextMask('CELL'),
                          controller: _optionalCellController,
                          isRequired: false,
                          keyboardType: TextInputType.phone,
                          labelTextValue: 'Celular (Opcional)',
                        ),
                        InputComponent(
                          textMask: TextMask('CELL'),
                          controller: _optionalCell2Controller,
                          isRequired: false,
                          keyboardType: TextInputType.phone,
                          labelTextValue: 'Celular (Opcional)',
                        ),
                        const Center(
                          child: TitleThreeComponent(text: 'Endereço'),
                        ),
                        SeachComponent(
                          textMask: TextMask('CEP'),
                          keyboardType: TextInputType.number,
                          isError: _isNotAddress,
                          errorMessage: 'CEP inválido',
                          onChanged: (String value) async {
                            if (value.length == 8) {
                              var dataCep =
                                  await _viaCepController.fetchViaCep(value);
                              if (dataCep.cep == null) {
                                setState(() {
                                  _isNotAddress = true;
                                });
                              } else {
                                setState(() {
                                  _isNotAddress = false;
                                });
                              }
                              _zipCodeController.text = dataCep.cep ?? '';
                              _streetController.text = dataCep.logradouro ?? '';
                              _numberController.text =
                                  dataCep.complemento ?? '';
                              _districtController.text = dataCep.bairro ?? '';
                              _cityController.text = dataCep.localidade ?? '';
                              _stateController.text = dataCep.uf ?? '';
                            }
                          },
                          labelTextValue: 'Pesquisar CEP',
                        ),
                        InputComponent(
                          iconErro: _isNotAddress,
                          controller: _streetController,
                          keyboardType: TextInputType.text,
                          labelTextValue: 'Logradouro',
                          isActive: false,
                        ),
                        InputComponent(
                          controller: _numberController,
                          keyboardType: TextInputType.text,
                          labelTextValue: 'Número',
                        ),
                        InputComponent(
                          controller: _complementController,
                          isRequired: false,
                          keyboardType: TextInputType.text,
                          labelTextValue: 'Complemento',
                        ),
                        InputComponent(
                          iconErro: _isNotAddress,
                          controller: _districtController,
                          keyboardType: TextInputType.text,
                          labelTextValue: 'Bairro',
                          isActive: false,
                        ),
                        InputComponent(
                          iconErro: _isNotAddress,
                          controller: _cityController,
                          keyboardType: TextInputType.text,
                          labelTextValue: 'Cidade',
                          isActive: false,
                        ),
                        InputComponent(
                          iconErro: _isNotAddress,
                          controller: _stateController,
                          keyboardType: TextInputType.text,
                          labelTextValue: 'Estado',
                          isActive: false,
                        ),
                        InputComponent(
                          iconErro: _isNotAddress,
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
                    text: 'Salvar',
                    onPressed: saveData,
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
          ],
        ),
      ),
    );
  }

  void _showPopupMenu(Offset offset) async {
    double left = offset.dx;
    double top = offset.dy;
    await showMenu(
      context: context,
      position: RelativeRect.fromLTRB(left, top, 0, 0),
      items: [
        PopupMenuItem(
          onTap: () {
            selectFile();
          },
          child: const Text("Editar"),
        ),
        PopupMenuItem(
          onTap: () {
            setState(() {
              _file = null;
              _imgFirebase = null;
            });
          },
          child: const Text("Remove"),
        ),
      ],
      elevation: 8.0,
    );
  }

  void saveData() async {
    if (_formKey.currentState!.validate()) {
      String? img64;
      if (_file != null) {
        final bytes = File(_file!.path.toString()).readAsBytesSync();
        img64 = base64Encode(bytes);
      } else if (_imgFirebase != null) {
        img64 = base64Encode(_imgFirebase!);
      }
      Map<String, dynamic> data = {
        'name': _nameController.text,
        'email': _emailController.text,
        'mainCell': _mainCellController.text,
        'optionalCell': _optionalCellController.text,
        'optionalCell2': _optionalCell2Controller.text,
        'street': _streetController.text,
        'number': _numberController.text,
        'complement': _complementController.text,
        'district': _districtController.text,
        'city': _cityController.text,
        'state': _stateController.text,
        'zipCode': _zipCodeController.text,
        'image': img64,
      };
      LoadingModalComponent loadingModalComponent = LoadingModalComponent();
      loadingModalComponent.showModal(context);

      bool result =
          await userProfileFirebaseService.saveUserProfile(_idUser.value, data);

      if (userProfileFirebaseService.isExecute && !result) {
        const snack = SnackBar(
          behavior: SnackBarBehavior.floating,
          content: Text('Erro ao gravar dados'),
          backgroundColor: Colors.red,
        );
        ScaffoldMessenger.of(context).showSnackBar(snack);
      }
      Navigator.of(context, rootNavigator: true).pop();
    }
  }
}
