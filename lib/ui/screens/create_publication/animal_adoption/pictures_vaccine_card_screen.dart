import 'dart:convert';
import 'dart:io';

import 'package:adoteme/data/models/animal_model.dart';
import 'package:adoteme/data/service/create_publication.dart';
import 'package:adoteme/data/service/login_firebase_service.dart';
import 'package:adoteme/data/service/upload_file_firebase_service.dart';
import 'package:adoteme/ui/components/appbars/appbar_to_back_component.dart';
import 'package:adoteme/ui/components/buttons/button_component.dart';
import 'package:adoteme/ui/components/buttons/button_outline_component.dart';
import 'package:adoteme/ui/components/loading_modal_component.dart';
import 'package:adoteme/ui/components/texts/detail_text_component.dart';
import 'package:adoteme/ui/components/texts/title_three_component.dart';
import 'package:adoteme/ui/screens/create_publication/animal_adoption/components/photo_animal_component.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'dart:typed_data';
import 'package:uuid/uuid.dart';
import 'package:provider/provider.dart';

class PicturesVaccineCardScreen extends StatefulWidget {
  static const routeName = "/pictures_vaccine_Card";

  const PicturesVaccineCardScreen({Key? key}) : super(key: key);

  @override
  State<PicturesVaccineCardScreen> createState() =>
      _PicturesVaccineCardScreen();
}

class _PicturesVaccineCardScreen extends State<PicturesVaccineCardScreen> {
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

  final ValueNotifier<String> _idUser = ValueNotifier('');
  @override
  void initState() {
    final auth = context.read<LoginFirebaseService>();
    _idUser.value = auth.idFirebase();
    super.initState();
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
              child: TitleThreeComponent(text: '4. Fotos do cartão de vacina'),
            ),
            const Center(
              child: DetailTextComponent(
                  text: 'As fotos do cartão de vacina são opcionais.'),
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
              itemCount: 4,
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
              text: 'Publicar',
              // TODO: Implementar a ação para salvar a publicação
              onPressed: () => savePublication(),
            ),
            const SizedBox(
              height: 16,
            ),
            ButtonOutlineComponent(
              text: 'Cancelar',
              // TODO: implementar ação de cancelar a criação da publicação
              onPressed: () {},
            ),
          ],
        ),
      ),
    );
  }

  savePublication() async {
    var uuid = const Uuid();
    LoadingModalComponent loadingModalComponent = LoadingModalComponent();
    loadingModalComponent.showModal(context);
    CreatePublicationService createPublicationService =
        CreatePublicationService();

    List<String> vaccineseAnimal = [];
    List<String> photosAnimal = [];
    final animalModel = context.read<AnimalModel>();

    if (animalModel.animalPhotos != null) {
      for (var photo in animalModel.animalPhotos!) {
        var uid = uuid.v4();
        var resultImg = await UploadFileFirebaseService.uploadImage(
            File(photo), '${_idUser.value}/photos_animal/$uid');

        if (resultImg) {
          var result = await UploadFileFirebaseService.getImage(
              '${_idUser.value}/photos_animal/$uid');
          photosAnimal.add(result);
        }
      }
    }
    animalModel.setAnimalPhotos(photosAnimal);
    for (var photo in file) {
      if (photo != null) {
        var uid = uuid.v4();
        var resultImg = await UploadFileFirebaseService.uploadImage(
            File(photo.path!), '${_idUser.value}/vaccine_photos/$uid');

        if (resultImg) {
          var result = await UploadFileFirebaseService.getImage(
              '${_idUser.value}/vaccine_photos/$uid');
          vaccineseAnimal.add(result);
        }
      }
    }
    animalModel.setPicturesVaccineCard(vaccineseAnimal);
    final DateTime currentPhoneDate = DateTime.now();
    animalModel.setCreateDate(Timestamp.fromDate(currentPhoneDate));
    animalModel.setIdUser(_idUser.value);
    animalModel.setStatus('in_progress');

    var resultFirebase =
        await createPublicationService.createPublication(animalModel.toJson());

    if (!resultFirebase) {
      const snack = SnackBar(
        behavior: SnackBarBehavior.floating,
        content:
            Text('Erro ao gravar dados, carregue novamente outras imagens'),
        backgroundColor: Colors.red,
      );
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(snack);
    }
    // ignore: use_build_context_synchronously
    Navigator.of(context, rootNavigator: true).pop();
  }
}
