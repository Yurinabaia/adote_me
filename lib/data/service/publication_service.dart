import 'package:adoteme/data/service/address/calculate_distance.dart';
import 'package:adoteme/utils/extension.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class PublicationService {
  static Future<bool> createPublication(
      Map<String, dynamic> publication, String collection) async {
    if (publication['address'] != null) {
      String addressAdvertiser =
          "${publication['address']['street']} ${publication['address']['number']}, ${publication['address']['city']}";
      Map<dynamic, dynamic> latLongAdvertiser =
          await CalculateDistance.addressCoordinate(addressAdvertiser);
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
          await CalculateDistance.addressCoordinate(addressAdvertiser);
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

  static Future<List<Map<String, dynamic>>> getPublicationAll({
    required String nameCollection,
    required double latUser,
    required double longUser,
    required objFilter,
  }) async {
    try {
      List<Map<String, dynamic>> listPublications = [];

      if (nameCollection != 'informative_publication' &&
          objFilter['typePublication'][0] != 'informative') {
        var docPublication = await FirebaseFirestore.instance
            .collection(nameCollection)
            .where('status', isEqualTo: 'in_progress')
            .where('typePublication', whereIn: objFilter['typePublication'])
            .where('updatedAt',
                isGreaterThanOrEqualTo: objFilter['initialDate'])
            .where('updatedAt', isLessThanOrEqualTo: objFilter['finalDate'])
            .orderBy('updatedAt', descending: true)
            .get();
        for (var element in docPublication.docChanges) {
          var documents = element.doc.data();
          if (documents == null) {
            continue;
          }
          double distance = await CalculateDistance.calculateDistance(
              latUser,
              longUser,
              element.doc['address']['lat'],
              element.doc['address']['long']);
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
      } else if (nameCollection == 'informative_publication' &&
          objFilter['typePublication'].contains('informative')) {
        var docPublication = await FirebaseFirestore.instance
            .collection(nameCollection)
            .where('typePublication', isEqualTo: 'informative')
            .where('updatedAt',
                isGreaterThanOrEqualTo: objFilter['initialDate'])
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
      required objFilter}) async {
    try {
      var docPublication = await FirebaseFirestore.instance
          .collection(nameCollection)
          .where('idUser', isEqualTo: idUser)
          .where('typePublication', whereIn: objFilter['typePublication'])
          .where('updatedAt', isGreaterThanOrEqualTo: objFilter['initialDate'])
          .where('updatedAt', isLessThanOrEqualTo: objFilter['finalDate'])
          .orderBy('updatedAt', descending: true)
          .get();
      List<Map<String, dynamic>> listPublications = [];

      for (var element in docPublication.docChanges) {
        var documents = element.doc.data();
        if (documents == null) {
          continue;
        }
        if (nameCollection != 'informative_publication') {
          if (objFilter['sex'].contains(element.doc['sex']) &&
              objFilter['typeAnimal'].contains(element.doc['animal'])) {
            listPublications.add({...documents, 'id': element.doc.id});
          }
        } else {
          listPublications.add({...documents, 'id': element.doc.id});
        }
      }
      return listPublications;
    } catch (e) {
      rethrow;
    }
  }

  static Future<List<Map<String, dynamic>>> getSuccessCaseAll(
      Map<String, dynamic> objFilter) async {
    try {
      final docPublication = await FirebaseFirestore.instance
          .collection('publications_animal')
          .where('status', isEqualTo: 'finished')
          .where('typePublication', whereIn: objFilter['typePublication'])
          .where('updatedAt', isGreaterThanOrEqualTo: objFilter['initialDate'])
          .where('updatedAt', isLessThanOrEqualTo: objFilter['finalDate'])
          .orderBy('updatedAt', descending: true)
          .get();

      List<Map<String, dynamic>> listPublications = [];
      for (var element in docPublication.docChanges) {
        var documents = element.doc.data();
        if (documents == null) {
          continue;
        }
        if (objFilter['sex'].contains(element.doc['sex']) &&
            objFilter['typeAnimal'].contains(element.doc['animal'])) {
          listPublications.add({...documents, 'id': element.doc.id});
        }
      }
      return listPublications;
    } catch (e) {
      rethrow;
    }
  }

  static Future<List<Map<String, dynamic>>> getFavorites(
      String collections,
      List<String?> listIdPublications,
      double latUser,
      double longUser,
      Map<String, dynamic> objFilter) async {
    try {
      List<Map<String, dynamic>> listPublications = [];
      if (listIdPublications.isEmpty) {
        return listPublications;
      }
      var docFirebase = await FirebaseFirestore.instance
          .collection(collections)
          .where(FieldPath.documentId, whereIn: listIdPublications)
          .get();
      for (var element in docFirebase.docChanges) {
        var documents = element.doc.data();
        if (documents == null) {
          continue;
        }
        DateTime dataFirebase = element.doc['updatedAt'].toDate();
        DateTime dataFilterInitial = objFilter['initialDate'].toDate();
        DateTime dataFilterFinal = objFilter['finalDate'].toDate();
        bool isSameDate = dataFirebase.isSameDate(dataFilterInitial) == false
            ? dataFirebase.isSameDate(dataFilterFinal)
            : true;
        bool dateValidator = (dataFirebase.isAfter(dataFilterInitial) &&
                dataFirebase.isBefore(dataFilterFinal)) ||
            isSameDate;
        if (element.doc['typePublication'] != 'informative') {
          bool validatorFilter =
              objFilter['sex'].contains(element.doc['sex']) &&
                  objFilter['typeAnimal'].contains(element.doc['animal']) &&
                  objFilter['typePublication']
                      .contains(element.doc['typePublication']);
          double distance = await CalculateDistance.calculateDistance(
              latUser,
              longUser,
              element.doc['address']['lat'],
              element.doc['address']['long']);
          if (dateValidator &&
              validatorFilter &&
              distance <= objFilter['distance']) {
            listPublications.add({
              ...documents,
              'id': element.doc.id,
              "distance": distance.toStringAsFixed(2)
            });
          }
        } else if (objFilter['typePublication']
                .contains(element.doc['typePublication']) &&
            dateValidator) {
          listPublications.add({...documents, 'id': element.doc.id});
        }
      }
      return listPublications;
    } catch (e) {
      rethrow;
    }
  }
}
