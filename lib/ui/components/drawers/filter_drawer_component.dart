import 'package:adoteme/data/providers/filter_provider.dart';
import 'package:adoteme/data/providers/form_key_provider.dart';
import 'package:adoteme/ui/components/buttons/button_component.dart';
import 'package:adoteme/ui/components/buttons/outline_button_component.dart';
import 'package:adoteme/ui/components/inputs/dropdown_component.dart';
import 'package:adoteme/ui/components/texts/body_text_component.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class FilterDrawerComponent extends StatefulWidget {
  final String routeName;

  const FilterDrawerComponent({Key? key, required this.routeName}) : super(key: key);

  @override
  State<FilterDrawerComponent> createState() => _FilterDrawerComponentState();
}

class _FilterDrawerComponentState extends State<FilterDrawerComponent> {
  final TextEditingController _typeAnimalController = TextEditingController();
  final TextEditingController _typePublicationController = TextEditingController();
  final TextEditingController _sexController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final ValueNotifier<FilterProvider> _filterProvider = ValueNotifier<FilterProvider>(FilterProvider());

  double _distance = 40;
  DateTime _initialDate = DateTime.now();
  DateTime _finalDate = DateTime.now();

  @override
  void initState() {
    var filter = context.read<FilterProvider>();
    _filterProvider.value = filter;
    initFilter();
    super.initState();
  }

  initFilter() {
    _typeAnimalController.text = _filterProvider.value.typeAnimal;
    _typePublicationController.text = _filterProvider.value.typePublication;
    _sexController.text = _filterProvider.value.sex;
    _initialDate = _filterProvider.value.initialDate;
    _finalDate = _filterProvider.value.finalDate;
    _distance = _filterProvider.value.distance;
  }

  @override
  Widget build(BuildContext context) {
    final formKeyProvider = context.watch<FormKeyProvider>();
    formKeyProvider.set(_formKey);
    final filter = context.read<FilterProvider>();

    return SafeArea(
      child: SizedBox(
        width: MediaQuery.of(context).size.width,
        child: Drawer(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Container(
                height: 56,
                decoration: BoxDecoration(
                  color: Theme.of(context).scaffoldBackgroundColor,
                  boxShadow: const [
                    BoxShadow(
                      color: Color.fromARGB(255, 73, 73, 73),
                      spreadRadius: 2,
                      blurRadius: 10,
                      offset: Offset(0, -6),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    const SizedBox(
                      width: 48,
                    ),
                    const Text(
                      'Filtros',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w900,
                        color: Color(0xff334155),
                      ),
                      textAlign: TextAlign.center,
                    ),
                    IconButton(
                      icon: Icon(
                        Icons.close,
                        color: Theme.of(context).primaryColor,
                        size: 32,
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Form(
                  key: _formKey,
                  child: ListView(
                    padding: const EdgeInsets.all(16),
                    children: [
                      DropDownComponent(
                        labelText: 'Tipo de animal',
                        items: const ['Todos', 'Cachorro', 'Gato', 'Ave', 'Réptil', 'Outros'],
                        controller: _typeAnimalController,
                      ),
                      const SizedBox(
                        height: 16,
                      ),
                      BodyTextComponent(
                        text: 'Raio de busca: ${_distance.round()} km',
                        fontWeight: FontWeight.w700,
                      ),
                      Slider(
                        value: _distance,
                        max: 40,
                        activeColor: Theme.of(context).primaryColor,
                        label: _distance.round().toString(),
                        onChanged: (double value) {
                          setState(() {
                            _distance = value;
                          });
                        },
                      ),
                      const SizedBox(
                        height: 16,
                      ),
                      DropDownComponent(
                        labelText: 'Tipo de publicação',
                        items: const [
                          'Todos',
                          'Adoção',
                          'Perdido',
                          'Informativo',
                        ],
                        controller: _typePublicationController,
                      ),
                      const SizedBox(
                        height: 16,
                      ),
                      DropDownComponent(
                        labelText: 'Sexo',
                        items: const [
                          'Todos',
                          'Macho',
                          'Fêmea',
                        ],
                        controller: _sexController,
                      ),
                      const SizedBox(
                        height: 16,
                      ),
                      Row(
                        children: [
                          TextButton.icon(
                            onPressed: () async {
                              DateTime? initialDate = await showDatePicker(
                                context: context,
                                initialDate: _initialDate,
                                firstDate: DateTime(2022, 9),
                                lastDate: DateTime.now(),
                              );
                              if (initialDate != null) {
                                setState(() {
                                  _initialDate = initialDate;

                                  if (_finalDate.isBefore(_initialDate)) {
                                    _finalDate = initialDate;
                                  }
                                });
                              }
                            },
                            icon: const Icon(
                              Icons.date_range_rounded,
                              color: Color(0xff334155),
                            ),
                            label: Text(
                              DateFormat("dd/MM/yyyy").format(_initialDate).toString(),
                              style: const TextStyle(
                                color: Color(0xff334155),
                              ),
                            ),
                            style: TextButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                side: const BorderSide(
                                  color: Color(0xff334155),
                                  width: 1,
                                  style: BorderStyle.solid,
                                ),
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                          ),
                          const SizedBox(
                            width: 40,
                          ),
                          TextButton.icon(
                            onPressed: () async {
                              DateTime? finalDate = await showDatePicker(
                                context: context,
                                initialDate: _finalDate,
                                firstDate: DateTime(2022, _initialDate.month, _initialDate.day),
                                lastDate: DateTime.now(),
                              );
                              if (finalDate != null) {
                                setState(() {
                                  _finalDate = finalDate;
                                });
                              }
                            },
                            icon: const Icon(
                              Icons.date_range_rounded,
                              color: Color(0xff334155),
                            ),
                            label: Text(
                              DateFormat("dd/MM/yyyy").format(_finalDate).toString(),
                              style: const TextStyle(
                                color: Color(0xff334155),
                              ),
                            ),
                            style: TextButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                side: const BorderSide(
                                  color: Color(0xff334155),
                                  width: 1,
                                  style: BorderStyle.solid,
                                ),
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 48,
                      ),
                      ButtonComponent(
                        text: 'Salvar filtro',
                        onPressed: () {
                          filter.typeAnimal = _typeAnimalController.text;
                          filter.sex = _sexController.text;
                          filter.distance = _distance;
                          filter.typePublication = _typePublicationController.text;
                          filter.initialDate = _initialDate;
                          filter.finalDate = _finalDate;

                          Navigator.of(context).pushNamed(
                            widget.routeName,
                          );
                        },
                      ),
                      const SizedBox(
                        height: 16,
                      ),
                      OutlineButtonComponent(
                        text: 'Limpar filtro',
                        onPressed: () {
                          filter.filterDefault();
                          Navigator.of(context).pushNamed(
                            widget.routeName,
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
