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

  static Future<QuerySnapshot<Map<String, dynamic>>> getPublicationAll(
      String nameCollection) async {
    try {
      final docPublication =
          await FirebaseFirestore.instance.collection(nameCollection).get();
      return docPublication;
    } catch (e) {
      rethrow;
    }
  }

  static Future<String> get_data(DocumentReference doc_ref) async {
    DocumentSnapshot docSnap = await doc_ref.get();
    var doc_id2 = docSnap.reference.id;
    return doc_id2;
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
}
