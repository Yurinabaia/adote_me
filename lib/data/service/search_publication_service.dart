import 'package:adoteme/data/service/address/calculate_distance.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:adoteme/utils/string_extension.dart';

class SearchPublicationService {
  static Future<QuerySnapshot<Map<String, dynamic>>>
      getPublicationsAnimalSearch(
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

  static Future<QuerySnapshot<Map<String, dynamic>>>
      getPublicationsInformativeSearch(
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

  static Future<QuerySnapshot<Map<String, dynamic>>> getSuccessCaseSearch(
      String search) async {
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

  static Future<List<Map<String, dynamic>>> getInformativePublicationsAll(
      {required String nameCollection,
      String? idUser,
      required double latUser,
      required double longUser,
      String? titleSeach}) async {
    try {
      var docPublication =
          FirebaseFirestore.instance.collection(nameCollection);
      if (idUser != null) {
        docPublication.where('idUser', isEqualTo: idUser);
      }
      var listDocument = await docPublication
          .where('title', isGreaterThanOrEqualTo: titleSeach?.capitalize())
          .where('title', isLessThan: "${titleSeach?.capitalize()}z")
          .get();

      List<Map<String, dynamic>> listPublications = [];

      for (var element in listDocument.docChanges) {
        var documents = element.doc.data();
        if (documents == null) {
          continue;
        } else {
          listPublications.add({...documents, 'id': element.doc.id});
        }
      }
      return listPublications;
    } catch (e) {
      rethrow;
    }
  }

  static Future<List<Map<String, dynamic>>> getAnimalPublicationsAll(
      {required String nameCollection,
      String? idUser,
      required double latUser,
      required double longUser,
      String? nameSeach}) async {
    try {
      var docPublication =
          FirebaseFirestore.instance.collection(nameCollection);
      if (idUser != null) {
        docPublication.where('idUser', isEqualTo: idUser);
      }
      var listDocument = await docPublication
          .where('name', isGreaterThanOrEqualTo: nameSeach?.capitalize())
          .where('name', isLessThan: "${nameSeach?.capitalize()}z")
          .get();

      List<Map<String, dynamic>> listPublications = [];
      for (var element in listDocument.docChanges) {
        var documents = element.doc.data();
        if (documents == null || element.doc['status'] == "finished") {
          continue;
        }
        if (element.doc['typePublication'] != 'informative') {
          double distance = CalculateDistance.calculateDistance(
              latUser,
              longUser,
              element.doc['address']['lat'],
              element.doc['address']['long']);
          // if (distance > 0) {
          listPublications.add({
            ...documents,
            'id': element.doc.id,
            "distance": distance.toStringAsFixed(2)
          });
          // }
        }
      }
      return listPublications;
    } catch (e) {
      rethrow;
    }
  }
}
