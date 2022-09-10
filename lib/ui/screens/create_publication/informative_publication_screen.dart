import 'dart:io';

import 'package:adoteme/data/providers/form_key_provider.dart';
import 'package:adoteme/data/providers/id_publication_provider.dart';
import 'package:adoteme/data/service/login_firebase_service.dart';
import 'package:adoteme/data/service/publication_service.dart';
import 'package:adoteme/data/service/upload_file_firebase_service.dart';
import 'package:adoteme/ui/components/appbars/appbar_to_back_component.dart';
import 'package:adoteme/ui/components/buttons/button_component.dart';
import 'package:adoteme/ui/components/buttons/button_outline_component.dart';
import 'package:adoteme/ui/components/inputs/input_component.dart';
import 'package:adoteme/ui/components/loading_modal_component.dart';
import 'package:adoteme/ui/components/texts/body_text_component.dart';
import 'package:adoteme/ui/components/texts/detail_text_component.dart';
import 'package:adoteme/ui/components/inputs/textarea_component.dart';
import 'package:adoteme/ui/components/texts/title_three_component.dart';
import 'package:adoteme/ui/components/upload_photo_component.dart';
import 'package:adoteme/utils/validator_inputs.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

class InformativePublicationScreen extends StatefulWidget {
  static const routeName = "/create-publication/informative_publication";

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

  PlatformFile? _imgCover;
  String? _imgFirebaseCover;
  final List<String?> _listImgFirebase = List<String?>.filled(4, null);
  final List<PlatformFile?> _listImagesFile =
      List<PlatformFile?>.filled(4, null);

  final ValueNotifier<String> _idUser = ValueNotifier<String>('');
  final ValueNotifier<String?> _idPublicationNotifier = ValueNotifier<String?>(null);
  void startData() async {
    var dataPublication = await PublicationService.getPublication(
        _idPublicationNotifier.value!, 'informative_publication');
    if (dataPublication?.data() != null) {
      _titleController.text = dataPublication?.data()!['title'];
      _descriptionController.text = dataPublication?.data()!['description'];
      _urlController.text = dataPublication!.data()?['url'] ?? '';
      var list = dataPublication.data()!['listImages'];
      if (list != null) {
        for (var i = 0; i < list.length; i++) {
          _listImgFirebase[i] = list[i];
        }
      }
      var imgCover = dataPublication.data()!['imageCover'];
      if (imgCover != null) {
        _imgFirebaseCover = imgCover;
      }
      setState(() {});
    }
  }

  @override
  void initState() {
    var auth = context.read<LoginFirebaseService>();
    _idUser.value = auth.idFirebase();
    final idPublicationProvider = context.read<IdPublicationProvider>();
    _idPublicationNotifier.value = idPublicationProvider.get();
    if (_idUser.value.isNotEmpty && _idPublicationNotifier.value != null) {
      startData();
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final formKeyProvider = context.watch<FormKeyProvider>();
    formKeyProvider.set(_formKey);
    return Scaffold(
      appBar: const AppBarToBackComponent(
        title: 'Criar publicacão informativa',
      ),
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
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const BodyTextComponent(
                          text: 'Capa da Publicação (Opcional)'),
                      const SizedBox(height: 16),
                      GestureDetector(
                        onTap: () {
                          selectFile(null);
                        },
                        child: SizedBox(
                          width: MediaQuery.of(context).size.width * 0.5,
                          height: MediaQuery.of(context).size.width * 0.5,
                          child: UploadPhotoComponent(
                            file: _imgCover,
                            imgFirebase: _imgFirebaseCover,
                          ),
                        ),
                      ),
                    ],
                  ),
                  InputComponent(
                    controller: _titleController,
                    labelTextValue: 'Título da publicação',
                    keyboardType: TextInputType.text,
                    validator: (value) {
                      return ValidatorInputs.validatorText(value);
                    },
                  ),
                  TextareaComponent(
                    controller: _descriptionController,
                    hint: 'Informações adicionais',
                    maxLength: 1000,
                    validator: (value) {
                      return ValidatorInputs.validatorText(value);
                    },
                  ),
                  InputComponent(
                    controller: _urlController,
                    labelTextValue: 'URL (opcional)',
                    isRequired: false,
                    keyboardType: TextInputType.text,
                    validator: (value) {
                      return ValidatorInputs.validatorUrl(value: value ?? '');
                    },
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
                            child: UploadPhotoComponent(
                              file: _listImagesFile[index],
                              imgFirebase: _listImgFirebase[index],
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
                        onPressed: () async {
                          if (_formKey.currentState!.validate()) {
                            LoadingModalComponent loadingModalComponent =
                                LoadingModalComponent();

                            loadingModalComponent.showModal(context);
                            List<String> listImages =
                                await loadingImageOptional();
                            String imgCover = await loadingImageCover();

                            DateTime currentDate = DateTime.now();
                            Timestamp? dataCreated;
                            Timestamp? dateUpdate;
                            if (_idPublicationNotifier.value != null) {
                              dateUpdate = Timestamp.fromDate(currentDate);
                            } else {
                              dataCreated = Timestamp.fromDate(currentDate);
                            }
                            Map<String, dynamic> dataInformative = {
                              'idUser': _idUser.value,
                              'title': _titleController.text,
                              'description': _descriptionController.text,
                              'url': _urlController.text != '' ? _urlController.text : null,
                              'imageCover':
                                  imgCover != '' ? imgCover : _imgFirebaseCover,
                              'listImages': listImages,
                              'createdAt': dataCreated,
                              'updatedAt': dateUpdate,
                              'typePublication': 'informative',
                            };
                            bool resultFirebase = false;
                            if (_idPublicationNotifier.value != null) {
                              resultFirebase = await PublicationService.updatePublication(
                                  _idPublicationNotifier.value!, dataInformative, 'informative_publication');
                            } else {
                              resultFirebase = await PublicationService.createPublication(
                                  dataInformative, 'informative_publication');
                            }
                            
                            if (resultFirebase) {
                              // ignore: use_build_context_synchronously
                              Navigator.pushReplacementNamed(
                                  context, '/my_publications');
                              return;
                            }
                            const snack = SnackBar(
                              behavior: SnackBarBehavior.floating,
                              content: Text(
                                  'Erro ao gravar dados, carregue novamente outras imagens'),
                              backgroundColor: Colors.red,
                            );
                            // ignore: use_build_context_synchronously
                            ScaffoldMessenger.of(context).showSnackBar(snack);
                            // ignore: use_build_context_synchronously
                            Navigator.of(context, rootNavigator: true).pop();
                          }
                        },
                      ),
                      const SizedBox(height: 16),
                      ButtonOutlineComponent(
                        text: 'Cancelar',
                        onPressed: () {
                          Navigator.pushReplacementNamed(context, '/my_publications');
                        },
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
          if (index != null) {
            _listImagesFile[index] = result.files.first;
            _listImgFirebase[index] = null;
          } else {
            _imgCover = result.files.first;
            _imgFirebaseCover = null;
          }
        });
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<List<String>> loadingImageOptional() async {
    Uuid uid = const Uuid();
    List<String> listImages = [];
    for (var photo in _listImagesFile) {
      if (photo != null) {
        var idImg = uid.v4();
        var result = await UploadFileFirebaseService.uploadImage(
            File(photo.path!), '${_idUser.value}/informative/$idImg');

        if (result) {
          var resultImg = await UploadFileFirebaseService.getImage(
              '${_idUser.value}/informative/$idImg');
          listImages.add(resultImg);
        }
      }
    }
    for (var photo in _listImgFirebase) {
      if (photo != null) {
        listImages.add(photo);
      }
    }
    return listImages;
  }

  Future<String> loadingImageCover() async {
    if (_imgCover != null) {
      Uuid uid = const Uuid();
      var idImg = uid.v4();
      var result = await UploadFileFirebaseService.uploadImage(
          File(_imgCover!.path!), '${_idUser.value}/informative/$idImg');

      if (result) {
        var resultImg = await UploadFileFirebaseService.getImage(
            '${_idUser.value}/informative/$idImg');
        return resultImg;
      }
    }
    return '';
  }
}
