import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:adoteme/utils/string_extension.dart';

class SearchPublicationService {
  static Future<QuerySnapshot<Map<String, dynamic>>> getPublicationsAnimalSearch(
      String nameCollection, String search, String idUser) async {
    try {
      final docPublication = await FirebaseFirestore.instance
          .collection(nameCollection)
          .where('name', isGreaterThanOrEqualTo: search.capitalize())
          .where('name', isLessThan: "${search.capitalize()}z")
          .where('idUser', isEqualTo: idUser)
          .get();
      return docPublication;
    } catch (e) {
      rethrow;
    }
  }

  static Future<QuerySnapshot<Map<String, dynamic>>> getPublicationsInformativeSearch(
      String nameCollection, String search, String idUser) async {
    try {
      final docPublication = await FirebaseFirestore.instance
          .collection(nameCollection)
          .where('title', isGreaterThanOrEqualTo: search.capitalize())
          .where('title', isLessThan: "${search.capitalize()}z")
          .where('idUser', isEqualTo: idUser)
          .get();
      return docPublication;
    } catch (e) {
      rethrow;
    }
  }

  static Future<QuerySnapshot<Map<String, dynamic>>> getSuccessCaseSearch(String search) async {
    try {
      final docPublication = await FirebaseFirestore.instance
          .collection('publications_animal')
          .where(
            'name',
            isGreaterThanOrEqualTo: search.capitalize(),
          )
          .where('name', isLessThan: "${search.capitalize()}z")
          .where('status', isEqualTo: 'finished')
          .get();
      return docPublication;
    } catch (e) {
      rethrow;
    }
  }

}
