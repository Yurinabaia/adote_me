import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

Map<String, String> enumTypePublication = {
  'Adoção': 'animal_adoption',
  'Perdido': 'animal_lost',
  'Informativo': 'informative'
};

class FilterProvider extends ChangeNotifier {
  String _typeAnimal = 'Todos';
  String _typePublication = 'Todos';
  String _sex = 'Todos';
  double _distance = 40;
  DateTime _initialDate = DateTime(2022, 9);
  DateTime _finalDate = DateTime.now();

  get typeAnimal => _typeAnimal;

  set typeAnimal(value) => _typeAnimal = value;

  get typePublication => _typePublication;

  set typePublication(value) => _typePublication = value;

  get sex => _sex;

  set sex(value) => _sex = value;

  get distance => _distance;

  set distance(value) => _distance = value;

  get initialDate => _initialDate;

  set initialDate(value) => _initialDate = value;

  get finalDate => _finalDate;

  set finalDate(value) => _finalDate = value;

  filterDefault() {
    _typeAnimal = 'Todos';
    _typePublication = 'Todos';
    _sex = 'Todos';
    _distance = 40;
    _initialDate = DateTime(2022, 9);
    _finalDate = DateTime.now();
  }

  Map<String, dynamic> objFilter() {
    return {
      'typeAnimal': typeAnimal == 'Todos' ? ['Cachorro', 'Gato', 'Ave', 'Réptil', 'Outros'] : [typeAnimal],
      'typePublication': typePublication == 'Todos'
          ? ['animal_adoption', 'animal_lost', 'informative']
          : [enumTypePublication[typePublication]],
      'sex': sex == 'Todos' ? ['Macho', 'Fêmea'] : [sex],
      'distance': distance,
      'initialDate': Timestamp.fromDate(initialDate),
      'finalDate': Timestamp.fromDate(finalDate)
    };
  }
}
