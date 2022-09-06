import 'dart:io';

import 'package:adoteme/data/models/animal_model.dart';
import 'package:adoteme/data/service/animal_publication_service.dart';
import 'package:adoteme/data/service/login_firebase_service.dart';
import 'package:adoteme/data/service/upload_file_firebase_service.dart';
import 'package:adoteme/ui/components/appbars/appbar_to_back_component.dart';
import 'package:adoteme/ui/components/buttons/button_component.dart';
import 'package:adoteme/ui/components/buttons/button_outline_component.dart';
import 'package:adoteme/ui/components/loading_modal_component.dart';
import 'package:adoteme/ui/components/texts/detail_text_component.dart';
import 'package:adoteme/ui/components/texts/title_three_component.dart';
import 'package:adoteme/ui/screens/create_publication/animal/components/photo_animal_component.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

class AnimalPhotosScreen extends StatefulWidget {
  static const routeName = "/create-publication/animal_photos";

  const AnimalPhotosScreen({Key? key}) : super(key: key);

  @override
  State<AnimalPhotosScreen> createState() => _AnimalPhotosScreenState();
}

class _AnimalPhotosScreenState extends State<AnimalPhotosScreen> {
  List<PlatformFile?> file = List<PlatformFile?>.filled(6, null);
  List<String?> imagesFirebase = List<String?>.filled(6, null);
  String nameCollection = '';
  String nameAppBar = ' ';
  void startData() async {
    var dataPublication = await AnimalPublicationService.getPublication(
        'D4BgUd4AwzANV0Tlcyg3', nameCollection);
    if (dataPublication?.data() != null) {
      var list = dataPublication?.data()!['animalPhotos'];
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
    final animalModel = context.read<AnimalModel>();
    return Scaffold(
      appBar: AppBarToBackComponent(
        title: nameAppBar,
      ),
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
                    imgFirebase: imagesFirebase[index],
                  ),
                );
              },
            ),
            const SizedBox(
              height: 64,
            ),
            ButtonComponent(
              text: animalModel.typePublication == 'animal_adoption'
                  ? 'Continuar'
                  : 'Publicar',
              isDisabled: file.every((element) => element == null) &&
                  imagesFirebase.every((element) => element == null),
              onPressed: () async {
                if (animalModel.typePublication != 'animal_adoption') {
                  savePublication(animalModel);
                } else {
                  proceedPublication(animalModel);
                }
              },
            ),
            const SizedBox(
              height: 16,
            ),
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

  void proceedPublication(animalModel) {
    List<String> animalPhotos = [];

    for (var photo in file) {
      if (photo != null) {
        animalPhotos.add(photo.path!);
      }
    }
    for (var photo in imagesFirebase) {
      if (photo != null) {
        animalPhotos.add(photo);
      }
    }
    animalModel.setAnimalPhotos(animalPhotos);
    Navigator.pushNamed(context, '/create-publication/pictures_vaccine_Card');
  }

  Future<void> savePublication(animalModel) async {
    LoadingModalComponent loadingModalComponent = LoadingModalComponent();
    loadingModalComponent.showModal(context);
    await uploadsImages(animalModel);
    await initPublication(animalModel);
    //TODO implementar o seguinte método abaixo quando estiver criado idPublicação
    // if (_idPublication != null) {
    //   resultFirebase = await CreatePublicationService.updatePublication(
    //       _idPublication!, animalModel);
    // } else {
    //   resultFirebase = await CreatePublicationService.createPublication(
    //       animalModel.toJson());
    // }
    // bool resultFirebase = await AnimalPublicationService.updatePublication(
    //     'D4BgUd4AwzANV0Tlcyg3', animalModel.toJsonLost(), nameCollection);
    bool resultFirebase = await AnimalPublicationService.createPublication(
        animalModel.toJsonLost(), nameCollection);

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
    List<String> animalPhotos = [];
    for (var photo in file) {
      if (photo != null) {
        var uid = uuid.v4();
        var resultImg = await UploadFileFirebaseService.uploadImage(
            File(photo.path!), '${_idUser.value}/photos_animal/$uid');

        if (resultImg) {
          var result = await UploadFileFirebaseService.getImage(
              '${_idUser.value}/photos_animal/$uid');
          animalPhotos.add(result);
        }
      }
    }
    for (var photo in imagesFirebase) {
      if (photo != null) {
        animalPhotos.add(photo);
      }
    }
    animalModel.setAnimalPhotos(animalPhotos);
  }

  Future<void> initPublication(animalModel) async {
    final DateTime currentPhoneDate = DateTime.now();
    //TODO: implementar quando obtiver o id da publicação
    // if (_idPublication != null) {
    //   await animalModel.setUpdateDate(currentPhoneDate);
    // }else {
    //   await animalModel.setCreateDate(Timestamp.fromDate(currentPhoneDate));
    // }
    await animalModel.setCreateDate(Timestamp.fromDate(currentPhoneDate));
    animalModel.setIdUser(_idUser.value);
    animalModel.setStatus('in_progress');
  }
}
