import 'package:cloud_firestore/cloud_firestore.dart';

class InformativePublicationService {
  Future<bool> saveInformativePublication(
      Map<String, dynamic> dataInformative) async {
    final docUser =
        FirebaseFirestore.instance.collection('informative_publication').doc();
    try {
      await docUser.set(dataInformative);
    } catch (e) {
      return false;
    }
    return true;
  }

  Future<bool> updateInformativePublication(
      String idInformative, Map<String, dynamic> dataInformative) async {
    final docUser = FirebaseFirestore.instance
        .collection('informative_publication')
        .doc(idInformative);
    try {
      await docUser.set(dataInformative);
    } catch (e) {
      return false;
    }
    return true;
  }

  static void deleteInformativePublication(String idInformative) {
    final docUser = FirebaseFirestore.instance
        .collection('informative_publication')
        .doc(idInformative);
    docUser.delete();
  }

  static Future<DocumentSnapshot<Map<String, dynamic>>>
      getInformativePublication(String idInformative) async {
    final docUser = FirebaseFirestore.instance
        .collection('informative_publication')
        .doc(idInformative);
    return await docUser.get();
  }

  Future<DocumentSnapshot<Map<String, dynamic>>>
      getInformativePublicationAll() async {
    final docUser =
        FirebaseFirestore.instance.collection('informative_publication').doc();
    return await docUser.get();
  }
}
