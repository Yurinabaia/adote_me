import 'package:adoteme/data/bloc/generic_bloc.dart';
import 'package:adoteme/data/service/publication_service.dart';
import 'package:adoteme/data/service/search_publication_service.dart';

class MyPublicationsBloc extends GenericBloc<List<Map<String, dynamic>>> {
  getPublicationsAll(String nomeCollection, String idUser,
      Map<String, dynamic> objFilter) async {
    try {
      var publicationsOne = await PublicationService.getMyPublications(
          nameCollection: nomeCollection, idUser: idUser, objFilter: objFilter);
      add(publicationsOne);
    } catch (e) {
      return e;
    }
  }

  getPublicationsAnimalSearch(
      String idUser, String search, Map<String, dynamic> objFilter) async {
    try {
      var publications =
          await SearchPublicationService.getAnimalPublicationsAll(
              idUser: idUser, nameSeach: search, objFilter: objFilter);
      add(publications);
    } catch (e) {
      return e;
    }
  }

  getPublicationsInformativeSearch(
      String idUser, String search, Map<String, dynamic> objFilter) async {
    try {
      var publications =
          await SearchPublicationService.getInformativePublicationsAll(
              idUser: idUser, titleSeach: search, objFilter: objFilter);
      add(publications);
    } catch (e) {
      return e;
    }
  }

  get streams => stream;
}
