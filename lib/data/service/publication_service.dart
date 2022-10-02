import 'package:adoteme/data/providers/filter_provider.dart';
import 'package:adoteme/data/service/address/calculate_distance.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class PublicationService {
  static Future<bool> createPublication(Map<String, dynamic> publication, String collection) async {
    if (publication['address'] != null) {
      String addressAdvertiser =
          "${publication['address']['street']} ${publication['address']['number']}, ${publication['address']['city']}";
      Map<dynamic, dynamic> latLongAdvertiser = await CalculateDistance.addressCordenate(addressAdvertiser);
      publication['address'].addAll({
        'lat': latLongAdvertiser['lat'],
        'long': latLongAdvertiser['long'],
      });
    }

    final docPublication = FirebaseFirestore.instance.collection(collection).doc();
    try {
      await docPublication.set(publication);
    } catch (e) {
      return false;
    }
    return true;
  }

  static Future<bool> updatePublication(
      String idPublication, Map<String, dynamic> publication, String collection) async {
    if (publication['address'] != null) {
      String addressAdvertiser =
          "${publication['address']['street']} ${publication['address']['number']}, ${publication['address']['city']}";
      Map<dynamic, dynamic> latLongAdvertiser = await CalculateDistance.addressCordenate(addressAdvertiser);
      publication['address'].addAll({
        'lat': latLongAdvertiser['lat'],
        'long': latLongAdvertiser['long'],
      });
    }

    final docPublication = FirebaseFirestore.instance.collection(collection).doc(idPublication);
    try {
      await docPublication.update(publication);
    } catch (e) {
      return false;
    }
    return true;
  }

  static void deletePublication(String idPublication, String collection) {
    try {
      final docPublication = FirebaseFirestore.instance.collection(collection).doc(idPublication);
      docPublication.delete();
    } catch (e) {
      rethrow;
    }
  }

  static Future<DocumentSnapshot<Map<String, dynamic>>?>? getPublication(
      String idPublication, String collection) async {
    try {
      final docPublication = FirebaseFirestore.instance.collection(collection).doc(idPublication);
      return await docPublication.get();
    } catch (e) {
      return null;
    }
  }

  static Future<List<Map<String, dynamic>>> getPublicationAll({
    required String nameCollection,
    required double latUser,
    required double longUser,
    required objFilter,
  }) async {
    try {
      List<Map<String, dynamic>> listPublications = [];

      if (nameCollection != 'informative_publication' && objFilter['typePublication'][0] != 'informative') {
        var docPublication = await FirebaseFirestore.instance
            .collection(nameCollection)
            .where('status', isEqualTo: 'in_progress')
            .where('typePublication', whereIn: objFilter['typePublication'])
            .where('updatedAt', isGreaterThanOrEqualTo: objFilter['initialDate'])
            .where('updatedAt', isLessThanOrEqualTo: objFilter['finalDate'])
            .orderBy('updatedAt', descending: true)
            .get();
        for (var element in docPublication.docChanges) {
          var documents = element.doc.data();
          if (documents == null) {
            continue;
          }
          double distance = CalculateDistance.calculateDistance(
              latUser, longUser, element.doc['address']['lat'], element.doc['address']['long']);
          if (distance <= objFilter['distance'] &&
              objFilter['sex'].contains(element.doc['sex']) &&
              objFilter['typeAnimal'].contains(element.doc['animal'])) {
            listPublications.add(
              {
                ...documents,
                'id': element.doc.id,
                "distance": distance.toStringAsFixed(2),
              },
            );
          }
        }
      } else if ( nameCollection == 'informative_publication' && objFilter['typePublication'].contains('informative')) {
        var docPublication = await FirebaseFirestore.instance
            .collection(nameCollection)
            .where('typePublication', isEqualTo: 'informative')
            .where('updatedAt', isGreaterThanOrEqualTo: objFilter['initialDate'])
            .where('updatedAt', isLessThanOrEqualTo: objFilter['finalDate'])
            .orderBy('updatedAt', descending: true)
            .get();

        for (var element in docPublication.docChanges) {
          var documents = element.doc.data();
          if (documents == null) {
            continue;
          }
          listPublications.add({...documents, 'id': element.doc.id});
        }
      }
      return listPublications;
    } catch (e) {
      rethrow;
    }
  }

  static Future<List<Map<String, dynamic>>> getMyPublications(
      {required String nameCollection,
      required String idUser,
      required double latUser,
      required double longUser}) async {
    try {
      var docPublication = await FirebaseFirestore.instance
          .collection(nameCollection)
          .where('idUser', isEqualTo: idUser)
          .orderBy('updatedAt', descending: true)
          .get();
      List<Map<String, dynamic>> listPublications = [];

      for (var element in docPublication.docChanges) {
        var documents = element.doc.data();
        if (documents == null) {
          continue;
        }
        listPublications.add({...documents, 'id': element.doc.id});
      }
      return listPublications;
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

  static Future<List<Map<String, dynamic>>> getFavorites(
      String collections, List<String?> listIdPublications, double latUser, double longUser) async {
    try {
      var docFirebase = await FirebaseFirestore.instance
          .collection(collections)
          .where(FieldPath.documentId, whereIn: listIdPublications.isNotEmpty ? listIdPublications : [' '])
          .get();

      List<Map<String, dynamic>> listPublications = [];

      for (var element in docFirebase.docChanges) {
        var documents = element.doc.data();
        if (documents == null) {
          continue;
        }
        if (element.doc['typePublication'] != 'informative') {
          double distance = CalculateDistance.calculateDistance(
              latUser, longUser, element.doc['address']['lat'], element.doc['address']['long']);
          // if (distance > 0) {
          listPublications.add({...documents, 'id': element.doc.id, "distance": distance.toStringAsFixed(2)});
          // }
        } else {
          listPublications.add({...documents, 'id': element.doc.id});
        }
      }
      return listPublications;
    } catch (e) {
      rethrow;
    }
  }
}
