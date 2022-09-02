import 'package:adoteme/data/models/animal_model.dart';
import 'package:adoteme/data/service/create_publication.dart';
import 'package:adoteme/ui/components/appbars/appbar_to_back_component.dart';
import 'package:adoteme/ui/components/buttons/button_component.dart';
import 'package:adoteme/ui/components/buttons/button_outline_component.dart';
import 'package:adoteme/ui/components/texts/detail_text_component.dart';
import 'package:adoteme/ui/components/texts/textarea_component.dart';
import 'package:adoteme/ui/components/texts/title_three_component.dart';
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

  void startData() async {
    var dataPublication =
        await CreatePublicationService.getPublication('OMV59MpLx31zpIBMhDf2');
    if (dataPublication.data() != null) {
      _descriptionController.text = dataPublication.data()!['description'];
    }
  }

  @override
  void initState() {
    startData();
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
                    TextareaComponent(
                      controller: _descriptionController,
                      hint: 'Descreva o animal',
                      maxLength: 255,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 64),
              ButtonComponent(
                text: 'Continuar',
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    final animalModel = context.read<AnimalModel>();
                    animalModel.setDescription(_descriptionController.text);
                    Navigator.pushNamed(context, '/animal_photos');
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
        ));
  }
}
