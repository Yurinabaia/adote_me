import 'package:adoteme/data/service/address/calculate_distance.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:adoteme/utils/string_extension.dart';

class PublicationService {
  static Future<bool> createPublication(
      Map<String, dynamic> publication, String collection) async {
    if (publication['address'] != null) {
      String addressAdvertiser =
          "${publication['address']['street']} ${publication['address']['number']}, ${publication['address']['city']}";
      Map<dynamic, dynamic> latLongAdvertiser =
          await CalculateDistance.addressCordenate(addressAdvertiser);
      publication['address'].addAll({
        'lat': latLongAdvertiser['lat'],
        'long': latLongAdvertiser['long'],
      });
    }

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
    if (publication['address'] != null) {
      String addressAdvertiser =
          "${publication['address']['street']} ${publication['address']['number']}, ${publication['address']['city']}";
      Map<dynamic, dynamic> latLongAdvertiser =
          await CalculateDistance.addressCordenate(addressAdvertiser);
      publication['address'].addAll({
        'lat': latLongAdvertiser['lat'],
        'long': latLongAdvertiser['long'],
      });
    }

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

  static Future<List<Map<String, dynamic>>> getMyPublications({
    required String nameCollection,
    required String idUser,
    required double latUser,
    required double longUser,
    String? nameSeach,
    String? titleSeach,
  }) async {
    try {
      CalculateDistance calculateDistance = CalculateDistance();
      var docPublication = FirebaseFirestore.instance
          .collection(nameCollection)
          .where('idUser', isEqualTo: idUser);
      if (nameSeach != null) {
        docPublication = docPublication
            .where('name', isGreaterThanOrEqualTo: nameSeach.capitalize())
            .where('name', isLessThan: "${nameSeach.capitalize()}z");
      }
      if (titleSeach != null) {
        docPublication = docPublication
            .where('title', isGreaterThanOrEqualTo: titleSeach.capitalize())
            .where('title', isLessThan: "${titleSeach.capitalize()}z");
      }
      if (nameSeach == null && titleSeach == null) {
        docPublication = docPublication.orderBy('updatedAt', descending: true);
      }
      final listDocument = await docPublication.get();
      List<Map<String, dynamic>> listPublicated = [];

      for (var element in listDocument.docChanges) {
        var documents = element.doc.data();
        if (documents == null) {
          continue;
        }
        if (element.doc['typePublication'] != 'informative') {
          double distance = calculateDistance.calculateDistance(
              latUser,
              longUser,
              element.doc['address']['lat'],
              element.doc['address']['long']);
          if (distance > 0) {
            listPublicated.add({...documents, 'id': element.doc.id});
          }
        } else {
          listPublicated.add({...documents, 'id': element.doc.id});
        }
      }
      return listPublicated;
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
