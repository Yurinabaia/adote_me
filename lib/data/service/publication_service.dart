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

  Future<DocumentSnapshot<Map<String, dynamic>>> getPublicationAll(
      String collection) async {
    try {
      final docPublication =
          FirebaseFirestore.instance.collection(collection).doc();
      return await docPublication.get();
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
}