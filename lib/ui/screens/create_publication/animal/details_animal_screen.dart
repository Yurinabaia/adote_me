import 'package:adoteme/data/models/publication_model.dart';
import 'package:adoteme/data/providers/form_key_provider.dart';
import 'package:adoteme/data/providers/id_publication_provider.dart';
import 'package:adoteme/data/service/publication_service.dart';
import 'package:adoteme/data/service/login_firebase_service.dart';
import 'package:adoteme/ui/components/appbars/appbar_to_back_component.dart';
import 'package:adoteme/ui/components/buttons/button_component.dart';
import 'package:adoteme/ui/components/buttons/outline_button_component.dart';
import 'package:adoteme/ui/components/texts/detail_text_component.dart';
import 'package:adoteme/ui/components/inputs/textarea_component.dart';
import 'package:adoteme/ui/components/texts/title_three_component.dart';
import 'package:adoteme/utils/validator_inputs.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DetailsAnimalScreen extends StatefulWidget {
  static const routeName = "/create-publication/details_animal";
  const DetailsAnimalScreen({Key? key}) : super(key: key);
  @override
  State<DetailsAnimalScreen> createState() => _DetailsAnimalScreenState();
}

class _DetailsAnimalScreenState extends State<DetailsAnimalScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _descriptionController = TextEditingController();
  String nameCollection = '';
  String nameAppBar = '';
  final ValueNotifier<String> _idUser = ValueNotifier<String>('');
  final ValueNotifier<String?> _idPublication = ValueNotifier<String?>(null);

  void startData() async {
    var dataPublication = await PublicationService.getPublication(
        _idPublication.value!, 'publications_animal');
    if (dataPublication?.data() != null) {
      _descriptionController.text = dataPublication?.data()!['description'];
    }
  }

  @override
  void initState() {
    final auth = context.read<LoginFirebaseService>();
    _idUser.value = auth.idFirebase();
    final animalModel = context.read<PublicationModel>();
    nameCollection = animalModel.typePublication!;
    nameAppBar = animalModel.typePublication == 'animal_adoption'
        ? 'Criar publicação de adoção'
        : 'Criar publicação de animal perdido';

    final idPublication = context.read<IdPublicationProvider>();
    _idPublication.value = idPublication.get();
    if (_idPublication.value != null && _idUser.value.isNotEmpty) {
      startData();
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final formKeyProvider = context.watch<FormKeyProvider>();
    formKeyProvider.set(_formKey);
    return Scaffold(
        appBar: AppBarToBackComponent(
          title: nameAppBar,
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: ListView(
            children: <Widget>[
              const TitleThreeComponent(
                text: '2. Informações adicionais',
              ),
              const SizedBox(height: 16),
              const DetailTextComponent(
                text:
                    'Informações que possam ser relevantes para encontrar um novo lar para o animal, motivo da doação ou mais detalhes sobre o animal perdido.',
              ),
              const SizedBox(height: 32),
              Form(
                key: _formKey,
                child: Wrap(
                  runSpacing: 24,
                  children: <Widget>[
                    TextAreaComponent(
                      controller: _descriptionController,
                      maxLength: 255,
                      validator: (value) {
                        return ValidatorInputs.validatorText(value);
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 64),
              ButtonComponent(
                text: 'Continuar',
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    final animalModel = context.read<PublicationModel>();
                    animalModel.setDescription(_descriptionController.text);
                    Navigator.pushNamed(context, '/create-publication/address');
                  }
                },
              ),
              const SizedBox(height: 16),
              OutlineButtonComponent(
                text: 'Cancelar',
                onPressed: () {
                  Navigator.pushReplacementNamed(context, '/my_publications');
                },
              ),
            ],
          ),
        ));
  }
}
