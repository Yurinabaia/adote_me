import 'dart:io';

import 'package:adoteme/ui/components/appbar_component.dart';
import 'package:adoteme/ui/components/inputs/input_component.dart';
import 'package:adoteme/ui/components/inputs/search_component.dart';
import 'package:adoteme/ui/components/title_three_component.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

class UserProfileScreen extends StatefulWidget {
  static const routeName = "/user_profile";
  const UserProfileScreen({Key? key}) : super(key: key);

  @override
  State<UserProfileScreen> createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen> {
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
  Widget build(BuildContext context) {
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
                          labelTextValue: 'Nome',
                        ),
                        InputComponent(
                          labelTextValue: 'Email',
                          isActive: false,
                          initTextValue: 'teste@teste',
                        ),
                        InputComponent(
                          labelTextValue: 'Celular Principal',
                        ),
                        InputComponent(
                          labelTextValue: 'Celular (Opcional)',
                        ),
                        InputComponent(
                          labelTextValue: 'Celular (Opcional)',
                        ),
                        Center(child: TextThreeComponent(text: 'Endereço')),
                        SeachComponent(
                          labelTextValue: 'Pesquisar CEP',
                        ),
                        InputComponent(
                          labelTextValue: 'Logradouro',
                          isActive: false,
                          initTextValue: 'Rua teste',
                        ),
                        InputComponent(
                          labelTextValue: 'Número',
                          isActive: false,
                          initTextValue: '123',
                        ),
                        InputComponent(
                          labelTextValue: 'Complemento',
                          isActive: false,
                          initTextValue: 'Apto 123',
                        ),
                        InputComponent(
                          labelTextValue: 'Bairro',
                          isActive: false,
                          initTextValue: 'Bairro teste',
                        ),
                        InputComponent(
                          labelTextValue: 'Cidade',
                          isActive: false,
                          initTextValue: 'Cidade teste',
                        ),
                        InputComponent(
                          labelTextValue: 'Estado',
                          isActive: false,
                          initTextValue: 'Estado teste',
                        ),
                        InputComponent(
                          labelTextValue: 'CEP',
                          isActive: false,
                          initTextValue: '12345-678',
                        ),
                      ],
                    ),
                  )
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
    ).then((value) {
      if (value != null) print(value);
    });
  }
}
