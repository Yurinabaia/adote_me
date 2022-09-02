import 'package:cloud_firestore/cloud_firestore.dart';

class CreatePublicationService {
  static Future<bool> createPublication(
      Map<String, dynamic> publication) async {
    final docPublication =
        FirebaseFirestore.instance.collection('animal_publication').doc();
    try {
      await docPublication.set(publication);
    } catch (e) {
      return false;
    }
    return true;
  }

  static Future<bool> updatePublication(
      String idPublication, Map<String, dynamic> publication) async {
    final docPublication = FirebaseFirestore.instance
        .collection('animal_publication')
        .doc(idPublication);
    try {
      await docPublication.set(publication);
    } catch (e) {
      return false;
    }
    return true;
  }

  //TODO: implementar o método de criação de publicação
  void deletePublication(String idPublication) {}

  Future<DocumentSnapshot<Map<String, dynamic>>> getPublicationAll() async {
    final docPublication =
        FirebaseFirestore.instance.collection('animal_publication').doc();
    return await docPublication.get();
  }

  //TODO: implementar o método de criação de publicação
  static Future<DocumentSnapshot<Map<String, dynamic>>> getPublication(
      String idPublication) async {
    final docPublication = FirebaseFirestore.instance
        .collection('animal_publication')
        .doc(idPublication);
    return await docPublication.get();
  }
}