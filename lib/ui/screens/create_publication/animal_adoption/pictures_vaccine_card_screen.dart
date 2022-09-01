import 'dart:convert';
import 'dart:io';

import 'package:adoteme/data/models/animal_model.dart';
import 'package:adoteme/data/service/create_publication.dart';
import 'package:adoteme/data/service/login_firebase_service.dart';
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
    LoadingModalComponent loadingModalComponent = LoadingModalComponent();
    loadingModalComponent.showModal(context);
    List<String> vaccineseAnimal = [];
    final animalModel = context.read<AnimalModel>();

    for (var element in file) {
      if (element != null) {
        final bytes = File(element.path.toString()).readAsBytesSync();
        vaccineseAnimal.add(base64Encode(bytes));
      }
    }
    animalModel.setPicturesVaccineCard(vaccineseAnimal);
    final DateTime currentPhoneDate = DateTime.now();
    animalModel.setCreateDate(Timestamp.fromDate(currentPhoneDate));
    animalModel.setIdUser(_idUser.value);
    animalModel.setStatus('in_progress');
    CreatePublicationService createPublicationService =
        CreatePublicationService();
    var resultFirebase =
        await createPublicationService.createPublication(animalModel.toJson());
    if (resultFirebase) {
      //TODO INFORMANDO QUE DEU CERTO
    } else {
      const snack = SnackBar(
        behavior: SnackBarBehavior.floating,
        content:
            Text('Erro ao gravar dados, carregue novamente outras imagens'),
        backgroundColor: Colors.red,
      );
      ScaffoldMessenger.of(context).showSnackBar(snack);
    }
    Navigator.of(context, rootNavigator: true).pop();
  }
}
