import 'package:adoteme/data/bloc/generic_bloc.dart';
import 'package:adoteme/data/service/publication_service.dart';
import 'package:adoteme/data/service/search_publication_service.dart';

class HomeBloc extends GenericBloc<List<Map<String, dynamic>>> {
  getPublicationsAll(String nomeCollection, double lat, double long,
      Map<String, dynamic> objFilter) async {
    try {
      var publicationsOne = await PublicationService.getPublicationAll(
        nameCollection: nomeCollection,
        latUser: lat,
        longUser: long,
        objFilter: objFilter,
      );
      add(publicationsOne);
    } catch (e) {
      return e;
    }
  }

  getPublicationsAnimalSearch(double lat, double long, String search,
      Map<String, dynamic> objFilter) async {
    try {
      var publications =
          await SearchPublicationService.getAnimalPublicationsAll(
              latUser: lat,
              longUser: long,
              nameSeach: search,
              objFilter: objFilter);
      add(publications);
    } catch (e) {
      return e;
    }
  }

  getPublicationsInformativeSearch(
      String search, Map<String, dynamic> objFilter) async {
    try {
      var publications =
          await SearchPublicationService.getInformativePublicationsAll(
              titleSeach: search, objFilter: objFilter);
      add(publications);
    } catch (e) {
      return e;
    }
  }

  get streams => stream;
}
