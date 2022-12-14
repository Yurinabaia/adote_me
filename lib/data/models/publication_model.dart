import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:adoteme/utils/extension.dart';

class PublicationModel extends ChangeNotifier {
  String? name;
  setName(String? name) {
    this.name = name;
    notifyListeners();
  }

  String? animal;
  setAnimal(String? animal) {
    this.animal = animal;
    notifyListeners();
  }

  String? age;
  setAge(String? age) {
    this.age = age;
    notifyListeners();
  }

  String? size;
  setSize(String? size) {
    this.size = size;
    notifyListeners();
  }

  String? sex;
  setSex(String? sex) {
    this.sex = sex;
    notifyListeners();
  }

  String? temperament;
  setTemperament(String? temperament) {
    this.temperament = temperament;
    notifyListeners();
  }

  String? breed;
  setBreed(String? breed) {
    this.breed = breed;
    notifyListeners();
  }

  String? color;
  setColor(String? color) {
    this.color = color;
    notifyListeners();
  }

  String? castrated;
  setCastrated(String? castrated) {
    this.castrated = castrated;
    notifyListeners();
  }

  String? description;
  setDescription(String? description) {
    this.description = description;
    notifyListeners();
  }

  List<String>? animalPhotos;
  setAnimalPhotos(List<String>? animalPhotos) {
    this.animalPhotos = animalPhotos;
    notifyListeners();
  }

  List<String>? picturesVaccineCard;
  setPicturesVaccineCard(List<String>? picturesVaccineCard) {
    this.picturesVaccineCard = picturesVaccineCard;
    notifyListeners();
  }

  String? typePublication;
  setTypePublication(String typePublication) {
    this.typePublication = typePublication;
    notifyListeners();
  }

  String? feedBack;
  setFeedBack(String feedBack) {
    this.feedBack = feedBack;
    notifyListeners();
  }

  String? status;
  setStatus(String status) {
    this.status = status;
    notifyListeners();
  }

  Timestamp? createDate;
  setCreateDate(Timestamp? createDate) {
    this.createDate = createDate;
  }

  Timestamp? updateDate;
  setUpdateDate(Timestamp updateDate) {
    this.updateDate = updateDate;
    notifyListeners();
  }

  String? idUser;
  setIdUser(String? idUser) {
    this.idUser = idUser;
    notifyListeners();
  }

  Map<String, dynamic>? address;
  setAddress(Map<String, dynamic>? address) {
    this.address = address;
    notifyListeners();
  }

  Map<String, dynamic> toJsonAdoption() => {
        "name": name?.capitalize(),
        "animal": animal,
        "age": age,
        "size": size,
        "sex": sex,
        "temperament": temperament,
        "breed": breed,
        "color": color,
        "castrated": castrated,
        "description": description,
        "animalPhotos": animalPhotos,
        "picturesVaccineCard": picturesVaccineCard,
        "typePublication": typePublication,
        "feedback": feedBack,
        "status": status,
        "createdAt": createDate,
        "updatedAt": updateDate,
        "idUser": idUser,
        "address": address,
      };

  Map<String, dynamic> toJsonLost() => {
        "name": name?.capitalize(),
        "animal": animal,
        "size": size,
        "sex": sex,
        "breed": breed,
        "color": color,
        "description": description,
        "animalPhotos": animalPhotos,
        "typePublication": typePublication,
        "feedback": feedBack,
        "status": status,
        "createdAt": createDate,
        "updatedAt": updateDate,
        "idUser": idUser,
        "address": address,
      };
}
