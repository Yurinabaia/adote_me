import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:adoteme/utils/string_extension.dart';

class SearchPublicationService {
  static Future<QuerySnapshot<Map<String, dynamic>>> getPublicationsAnimal(
      String nameCollection, String search) async {
    try {
      final docPublication = await FirebaseFirestore.instance
          .collection(nameCollection)
          .where('name', isGreaterThanOrEqualTo: search.capitalize())
          .where('name', isLessThan: "${search.capitalize()}z")
          .get();
      return docPublication;
    } catch (e) {
      rethrow;
    }
  }

  static Future<QuerySnapshot<Map<String, dynamic>>> getPublicationsInformative(
      String nameCollection, String search) async {
    try {
      final docPublication = await FirebaseFirestore.instance
          .collection(nameCollection)
          .where(
            'title',
            isGreaterThanOrEqualTo: search.capitalize(),
          )
          .where('title', isLessThan: "${search.capitalize()}z")
          .get();
      return docPublication;
    } catch (e) {
      rethrow;
    }
  }
}
