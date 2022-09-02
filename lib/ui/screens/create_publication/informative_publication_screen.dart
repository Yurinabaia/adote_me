import 'dart:typed_data';

import 'package:adoteme/ui/components/appbars/appbar_to_back_component.dart';
import 'package:adoteme/ui/components/buttons/button_component.dart';
import 'package:adoteme/ui/components/buttons/button_outline_component.dart';
import 'package:adoteme/ui/components/inputs/input_component.dart';
import 'package:adoteme/ui/components/texts/body_text_component.dart';
import 'package:adoteme/ui/components/texts/detail_text_component.dart';
import 'package:adoteme/ui/components/texts/textarea_component.dart';
import 'package:adoteme/ui/components/texts/title_three_component.dart';
import 'package:adoteme/ui/screens/create_publication/animal_adoption/components/photo_animal_component.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

class InformativePublicationScreen extends StatefulWidget {
  static const routeName = "/informative_publication";

  const InformativePublicationScreen({Key? key}) : super(key: key);

  @override
  State<InformativePublicationScreen> createState() =>
      _InformativePublicationScreenState();
}

class _InformativePublicationScreenState
    extends State<InformativePublicationScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _urlController = TextEditingController();

  PlatformFile? _file;
  String? _imgFirebase;
  List<PlatformFile?> listImages = List<PlatformFile?>.filled(6, null);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AppBarToBackComponent(),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: <Widget>[
            const TitleThreeComponent(
              text: 'Informativo',
            ),
            const DetailTextComponent(
              text:
                  'Ao criar uma publicação informativa você pode adicionar título ou capa que outros usuários irão visualizar no feed, descrição,  link caso a informação tenha sido extraída de um site e fotos, se necessário.',
            ),
            const SizedBox(height: 32),
            Form(
              key: _formKey,
              child: Wrap(
                runSpacing: 24,
                children: <Widget>[
                  Column(
                    children: [
                      const BodyTextComponent(text: 'Capa da Publicação'),
                      const SizedBox(height: 16),
                      GestureDetector(
                        onTap: () {
                          selectFile(null);
                        },
                        child: SizedBox(
                          width: MediaQuery.of(context).size.width * 0.5,
                          height: MediaQuery.of(context).size.width * 0.5,
                          child: PhotoAnimalComponent(
                            file: _file,
                            imgFirebase: _imgFirebase,
                          ),
                        ),
                      ),
                    ],
                  ),
                  InputComponent(
                    controller: _titleController,
                    labelTextValue: 'Título da publicação',
                    keyboardType: TextInputType.text,
                  ),
                  TextareaComponent(
                    controller: _descriptionController,
                    hint: 'Informações adicionais',
                    maxLength: 1000,
                  ),
                  InputComponent(
                    controller: _titleController,
                    labelTextValue: 'URL (opcional)',
                    keyboardType: TextInputType.text,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const BodyTextComponent(
                        text: 'Fotos (opcional)',
                      ),
                      const SizedBox(height: 16),
                      GridView.builder(
                        gridDelegate:
                            const SliverGridDelegateWithMaxCrossAxisExtent(
                          maxCrossAxisExtent: 200,
                          crossAxisSpacing: 16,
                          mainAxisSpacing: 16,
                        ),
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: 4,
                        itemBuilder: (BuildContext context, int index) {
                          return GestureDetector(
                            onTap: () {
                              selectFile(index);
                            },
                            child: PhotoAnimalComponent(
                              file: listImages[index],
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      const SizedBox(height: 48),
                      ButtonComponent(
                        text: 'Publicar',
                        onPressed: () {
                          // TODO: implementar ação do botão
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
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future selectFile(int? index) async {
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['jpg', 'png'],
      );
      if (result != null) {
        setState(() {
          index != null ? listImages[index] = result.files.first : null;
          _file = result.files.first;
          _imgFirebase = null;
        });
      }
    } catch (e) {
      rethrow;
    }
  }
}
