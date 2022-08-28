import 'dart:io';

import 'package:adoteme/data/service/login_firebase_service.dart';
import 'package:adoteme/data/service/user_profile_firebase_service.dart';
import 'package:adoteme/ui/components/appbar_component.dart';
import 'package:adoteme/ui/components/button_component.dart';
import 'package:adoteme/ui/components/inputs/input_component.dart';
import 'package:adoteme/ui/components/inputs/search_component.dart';
import 'package:adoteme/ui/components/title_three_component.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class UserProfileScreen extends StatefulWidget {
  static const routeName = "/user_profile";
  const UserProfileScreen({Key? key}) : super(key: key);

  @override
  State<UserProfileScreen> createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen> {
  //Controllers
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

  //Providers
  final ValueNotifier<String> _idUser = ValueNotifier('');
  final ValueNotifier<String> _emailUser = ValueNotifier('');
  PlatformFile? _file;
  Future selectFile() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['jpg', 'png'],
    );
    if (result != null) {
      setState(() {
        _file = result.files.first;
      });
    }
  }

  @override
  void initState() {
    final auth = context.read<FirebaseService>();
    _idUser.value = auth.idFirebase();
    if (_idUser.value.isNotEmpty) {
      _emailUser.value = auth.emailFirebase();
    }
    _emailController.text = _emailUser.value;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _zipCodeController.text = '13.068-000';
    _streetController.text = 'Rua dos Bobos';
    _numberController.text = '123';
    _districtController.text = 'Bairro do Bobo';
    _cityController.text = 'Cidade do Bobo';
    _stateController.text = 'Estado do Bobo';
    _complementController.text = 'Complemento do Bobo';

    return Scaffold(
      appBar: const AppBarComponent(titulo: 'Perfil'),
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
                        _file != null
                            ? _showPopupMenu(details.globalPosition)
                            : selectFile();
                      },
                      child: Stack(
                        children: <Widget>[
                          CircleAvatar(
                            radius: 75,
                            backgroundColor: Colors.grey[300],
                            backgroundImage: _file != null
                                ? FileImage(File(_file!.path!))
                                : Image.asset('assets/images/user_profile.png')
                                    .image,
                          ),
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
                    key: null,
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
                          controller: _mainCellController,
                          keyboardType: TextInputType.phone,
                          labelTextValue: 'Celular Principal',
                        ),
                        InputComponent(
                          controller: _optionalCellController,
                          keyboardType: TextInputType.phone,
                          labelTextValue: 'Celular (Opcional)',
                        ),
                        InputComponent(
                          controller: _optionalCell2Controller,
                          keyboardType: TextInputType.phone,
                          labelTextValue: 'Celular (Opcional)',
                        ),
                        const Center(
                          child: TextThreeComponent(text: 'Endereço'),
                        ),
                        const SeachComponent(
                          keyboardType: TextInputType.number,
                          labelTextValue: 'Pesquisar CEP',
                        ),
                        InputComponent(
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
                          keyboardType: TextInputType.text,
                          labelTextValue: 'Complemento',
                        ),
                        InputComponent(
                          controller: _districtController,
                          keyboardType: TextInputType.text,
                          labelTextValue: 'Bairro',
                          isActive: false,
                        ),
                        InputComponent(
                          controller: _cityController,
                          keyboardType: TextInputType.text,
                          labelTextValue: 'Cidade',
                          isActive: false,
                        ),
                        InputComponent(
                          controller: _stateController,
                          keyboardType: TextInputType.text,
                          labelTextValue: 'Estado',
                          isActive: false,
                        ),
                        InputComponent(
                          controller: _zipCodeController,
                          keyboardType: TextInputType.number,
                          labelTextValue: 'CEP',
                          isActive: false,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 32),
                  ButtonComponent(
                    text: 'Salvar',
                    onPressed: saveData,
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
            });
          },
          child: const Text("Remove"),
        ),
      ],
      elevation: 8.0,
    );
  }

  void saveData() {
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
    };

    UserProfileFirebaseService userProfileFirebaseService =
        UserProfileFirebaseService();
    userProfileFirebaseService.createUserProfile(_idUser.value, data);
  }
}
