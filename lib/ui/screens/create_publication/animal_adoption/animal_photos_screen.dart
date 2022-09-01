import 'dart:convert';
import 'dart:io';

import 'package:adoteme/data/models/animal_model.dart';
import 'package:adoteme/data/service/upload_file_firebase_service.dart';
import 'package:adoteme/ui/components/appbars/appbar_to_back_component.dart';
import 'package:adoteme/ui/components/buttons/button_component.dart';
import 'package:adoteme/ui/components/buttons/button_outline_component.dart';
import 'package:adoteme/ui/components/loading_modal_component.dart';
import 'package:adoteme/ui/components/texts/detail_text_component.dart';
import 'package:adoteme/ui/components/texts/title_three_component.dart';
import 'package:adoteme/ui/screens/create_publication/animal_adoption/components/photo_animal_component.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'dart:typed_data';

import 'package:provider/provider.dart';

class AnimalPhotosScreen extends StatefulWidget {
  static const routeName = "/animal_photos";

  const AnimalPhotosScreen({Key? key}) : super(key: key);

  @override
  State<AnimalPhotosScreen> createState() => _AnimalPhotosScreenState();
}

class _AnimalPhotosScreenState extends State<AnimalPhotosScreen> {
  List<PlatformFile?> file = List<PlatformFile?>.filled(6, null);
  Uint8List? _imgFirebase;
  Future selectFile(int index) async {
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['jpg', 'png'],
      );
      if (result != null) {
        setState(() {
          file[index] = result.files.first;
          //_imgFirebase = null;
        });
      }
    } catch (e) {
      rethrow;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AppBarToBackComponent(),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: <Widget>[
            const Center(
              child: TitleThreeComponent(text: '3. Fotos do animal'),
            ),
            const Center(
              child: DetailTextComponent(
                  text: 'Envie pelo menos uma foto do animal'),
            ),
            const SizedBox(
              height: 32,
            ),
            GridView.builder(
              gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                maxCrossAxisExtent: 200,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
              ),
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: 6,
              itemBuilder: (BuildContext context, int index) {
                return GestureDetector(
                  onTap: () {
                    selectFile(index);
                  },
                  child: PhotoAnimalComponent(
                    file: file[index],
                  ),
                );
              },
            ),
            const SizedBox(
              height: 64,
            ),
            ButtonComponent(
              text: 'Continuar',
              onPressed: () async {
                List<String> animalPhotos = [];
                final animalModel = context.read<AnimalModel>();
                for (var photo in file) {
                  if (photo != null) {
                    animalPhotos.add(photo.path!);
                  }
                }
                animalModel.setAnimalPhotos(animalPhotos);
                Navigator.pushNamed(context, '/pictures_vaccine_Card');
              },
            ),
            const SizedBox(
              height: 16,
            ),
            ButtonOutlineComponent(
              text: 'Cancelar',
              // TODO: implementar ação de cancelar publicação
              onPressed: () {},
            ),
          ],
        ),
      ),
    );
  }
}
