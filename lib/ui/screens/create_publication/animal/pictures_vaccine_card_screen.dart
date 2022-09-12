import 'dart:io';

import 'package:adoteme/data/models/publication_model.dart';
import 'package:adoteme/data/providers/id_publication_provider.dart';
import 'package:adoteme/data/service/publication_service.dart';
import 'package:adoteme/data/service/login_firebase_service.dart';
import 'package:adoteme/data/service/upload_file_firebase_service.dart';
import 'package:adoteme/ui/components/appbars/appbar_to_back_component.dart';
import 'package:adoteme/ui/components/buttons/button_component.dart';
import 'package:adoteme/ui/components/buttons/outline_button_component.dart';
import 'package:adoteme/ui/components/loading_modal_component.dart';
import 'package:adoteme/ui/components/texts/detail_text_component.dart';
import 'package:adoteme/ui/components/texts/title_three_component.dart';
import 'package:adoteme/ui/components/upload_image_component.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import 'package:provider/provider.dart';

class PicturesVaccineCardScreen extends StatefulWidget {
  static const routeName = "/create-publication/pictures_vaccine_Card";

  const PicturesVaccineCardScreen({Key? key}) : super(key: key);

  @override
  State<PicturesVaccineCardScreen> createState() =>
      _PicturesVaccineCardScreen();
}

class _PicturesVaccineCardScreen extends State<PicturesVaccineCardScreen> {
  List<PlatformFile?> file = List<PlatformFile?>.filled(4, null);
  List<String?> imagesFirebase = List<String?>.filled(4, null);
  String nameCollection = '';
  final ValueNotifier<String> _idUser = ValueNotifier('');
  final ValueNotifier<String?> _idPublication = ValueNotifier(null);

  void startData() async {
    var dataPublication = await PublicationService.getPublication(
        _idPublication.value!, 'publications_animal');
    if (dataPublication?.data() != null) {
      var list = dataPublication?.data()!['picturesVaccineCard'];
      if (list != null) {
        for (var i = 0; i < list.length; i++) {
          imagesFirebase[i] = list[i];
        }
        setState(() {
          imagesFirebase = imagesFirebase;
        });
      }
    }
  }

  Future selectFile(int index) async {
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['jpg', 'png'],
      );
      if (result != null) {
        setState(() {
          file[index] = result.files.first;
          imagesFirebase[index] = null;
        });
      }
    } catch (e) {
      rethrow;
    }
  }

  @override
  void initState() {
    final auth = context.read<LoginFirebaseService>();
    _idUser.value = auth.idFirebase();
    final animalModel = context.read<PublicationModel>();
    nameCollection = animalModel.typePublication!;
    final idPublication = context.read<IdPublicationProvider>();
    _idPublication.value = idPublication.get();
    if (_idPublication.value != null && _idUser.value.isNotEmpty) {
      startData();
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AppBarToBackComponent(
        title: 'Criar publicação de adoção',
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: <Widget>[
            const Center(
              child: TitleThreeComponent(text: '5. Fotos do cartão de vacina'),
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
                  child: UploadImageComponent(
                    file: file[index],
                    imgFirebase: imagesFirebase[index],
                  ),
                );
              },
            ),
            const SizedBox(
              height: 64,
            ),
            ButtonComponent(
              text: 'Publicar',
              onPressed: () => savePublication(),
            ),
            const SizedBox(
              height: 16,
            ),
            OutlineButtonComponent(
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

  savePublication() async {
    LoadingModalComponent loadingModalComponent = LoadingModalComponent();
    loadingModalComponent.showModal(context);

    final animalModel = context.read<PublicationModel>();
    await uploadsImages(animalModel);
    await initPublication(animalModel);
    bool resultFirebase = false;

    if (_idPublication.value != null) {
      resultFirebase = await PublicationService.updatePublication(
          _idPublication.value!,
          animalModel.toJsonAdoption(),
          'publications_animal');
    } else {
      resultFirebase = await PublicationService.createPublication(
          animalModel.toJsonAdoption(), 'publications_animal');
    }
    if (resultFirebase) {
      // ignore: use_build_context_synchronously
      Navigator.pushReplacementNamed(context, '/my_publications');
      return;
    }
    const snack = SnackBar(
      behavior: SnackBarBehavior.floating,
      content: Text('Erro ao gravar dados, carregue novamente outras imagens'),
      backgroundColor: Colors.red,
    );
    // ignore: use_build_context_synchronously
    ScaffoldMessenger.of(context).showSnackBar(snack);
    // ignore: use_build_context_synchronously
    Navigator.of(context, rootNavigator: true).pop();
  }

  Future<void> uploadsImages(animalModel) async {
    var uuid = const Uuid();
    List<String> vaccineseAnimal = [];
    List<String> photosAnimal = [];

    if (animalModel.animalPhotos != null) {
      for (var photo in animalModel.animalPhotos!) {
        if (photo.contains('http')) {
          photosAnimal.add(photo);
        } else {
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
    for (var photo in imagesFirebase) {
      if (photo != null) {
        vaccineseAnimal.add(photo);
      }
    }
    animalModel.setPicturesVaccineCard(vaccineseAnimal);
  }

  Future<void> initPublication(animalModel) async {
    final DateTime currentDate = DateTime.now();
    if (_idPublication.value != null) {
      await animalModel.setUpdateDate(Timestamp.fromDate(currentDate));
    } else {
      await animalModel.setCreateDate(Timestamp.fromDate(currentDate));
      await animalModel.setUpdateDate(Timestamp.fromDate(currentDate));
    }
    animalModel.setIdUser(_idUser.value);
    animalModel.setStatus('in_progress');
  }
}
