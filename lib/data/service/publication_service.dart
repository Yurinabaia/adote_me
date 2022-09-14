import 'package:cloud_firestore/cloud_firestore.dart';

class PublicationService {
  static Future<bool> createPublication(
      Map<String, dynamic> publication, String collection) async {
    final docPublication =
        FirebaseFirestore.instance.collection(collection).doc();
    try {
      await docPublication.set(publication);
    } catch (e) {
      return false;
    }
    return true;
  }

  static Future<bool> updatePublication(String idPublication,
      Map<String, dynamic> publication, String collection) async {
    final docPublication =
        FirebaseFirestore.instance.collection(collection).doc(idPublication);
    try {
      await docPublication.update(publication);
    } catch (e) {
      return false;
    }
    return true;
  }

  static void deletePublication(String idPublication, String collection) {
    try {
      final docPublication =
          FirebaseFirestore.instance.collection(collection).doc(idPublication);
      docPublication.delete();
    } catch (e) {
      rethrow;
    }
  }

  static Future<DocumentSnapshot<Map<String, dynamic>>?>? getPublication(
      String idPublication, String collection) async {
    try {
      final docPublication =
          FirebaseFirestore.instance.collection(collection).doc(idPublication);
      return await docPublication.get();
    } catch (e) {
      return null;
    }
  }

  static Future<QuerySnapshot<Map<String, dynamic>>> getMyPublications(
      String nameCollection, String idUser) async {
    try {
      final docPublication = await FirebaseFirestore.instance
          .collection(nameCollection)
          .where('idUser', isEqualTo: idUser)
          .orderBy('updatedAt', descending: true)
          .get();
      return docPublication;
    } catch (e) {
      rethrow;
    }
  }

  static Future<QuerySnapshot<Map<String, dynamic>>> getSuccessCaseAll() async {
    try {
      final docPublication = await FirebaseFirestore.instance
          .collection('publications_animal')
          .where('status', isEqualTo: 'finished')
          .orderBy('updatedAt', descending: true)
          .get();
      return docPublication;
    } catch (e) {
      rethrow;
    }
  }

  static Future<QuerySnapshot<Map<String, dynamic>>> getFavorites(
      String collecion, List<String?> listIdPublicated) async {
    try {
      var docFirebase = await FirebaseFirestore.instance
          .collection(collecion)
          .where(FieldPath.documentId,
              whereIn: listIdPublicated.isNotEmpty ? listIdPublicated : [' '])
          .get();
      return docFirebase;
    } catch (e) {
      rethrow;
    }
  }
}
