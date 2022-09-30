import 'package:adoteme/data/bloc/generic_bloc.dart';
import 'package:adoteme/data/service/publication_service.dart';
import 'package:adoteme/data/service/search_publication_service.dart';

class HomeBloc extends GenericBloc<List<Map<String, dynamic>>> {
  getPublicationsAll(String nomeCollection, double lat, double long) async {
    try {
      var publicationsOne = await PublicationService.getPublicationAll(
          nameCollection: nomeCollection, latUser: lat, longUser: long);
      add(publicationsOne);
    } catch (e) {
      return e;
    }
  }

  getPublicationsAnimalSearch(
      String nomeCollection, double lat, double long, String search) async {
    try {
      var publications =
          await SearchPublicationService.getAnimalPublicationsAll(
              nameCollection: nomeCollection,
              latUser: lat,
              longUser: long,
              nameSeach: search);
      add(publications);
    } catch (e) {
      return e;
    }
  }

  getPublicationsInformativeSearch(
      String nomeCollection, double lat, double long, String search) async {
    try {
      var publications =
          await SearchPublicationService.getInformativePublicationsAll(
              nameCollection: nomeCollection,
              latUser: lat,
              longUser: long,
              titleSeach: search);
      add(publications);
    } catch (e) {
      return e;
    }
  }

  get streams => stream;
}