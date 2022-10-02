import 'package:adoteme/data/service/address/calculate_distance.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:adoteme/utils/extension.dart';

class SearchPublicationService {
  static Future<List<Map<String, dynamic>>> getSuccessCaseSearch(
      String search, Map<String, dynamic> objFilter) async {
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

      List<Map<String, dynamic>> listPublications = [];
      for (var element in docPublication.docChanges) {
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

  static Future<List<Map<String, dynamic>>> getInformativePublicationsAll(
      {String? idUser,
      String? titleSeach,
      required Map<String, dynamic> objFilter}) async {
    try {
      var docPublication =
          FirebaseFirestore.instance.collection('informative_publication');
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
        if (objFilter['typePublication']
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

  static Future<List<Map<String, dynamic>>> getAnimalPublicationsAll(
      {String? idUser,
      double? latUser,
      double? longUser,
      String? nameSeach,
      required Map<String, dynamic> objFilter}) async {
    try {
      var docPublication =
          FirebaseFirestore.instance.collection('publications_animal');
      if (idUser != null) {
        docPublication.where('idUser', isEqualTo: idUser);
      }
      var listDocument = await docPublication
          .where('name', isGreaterThanOrEqualTo: nameSeach?.capitalize())
          .where('name', isLessThan: "${nameSeach?.capitalize()}z")
          .get();

      List<Map<String, dynamic>> listPublications = [];
      double distance = 0.0;
      for (var element in listDocument.docChanges) {
        var documents = element.doc.data();
        if (idUser != null) {
          if (documents == null) {
            continue;
          }
        } else if (documents == null || element.doc['status'] == "finished") {
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
          if (latUser != null && longUser != null) {
            distance = CalculateDistance.calculateDistance(latUser, longUser,
                element.doc['address']['lat'], element.doc['address']['long']);
          }

          if (dateValidator &&
              validatorFilter &&
              distance <= objFilter['distance']) {
            listPublications.add({
              ...documents,
              'id': element.doc.id,
              "distance": distance.toStringAsFixed(2)
            });
          }
        }
      }
      return listPublications;
    } catch (e) {
      rethrow;
    }
  }
}
