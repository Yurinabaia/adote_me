import 'package:adoteme/data/bloc/generic_bloc.dart';
import 'package:adoteme/data/service/publication_service.dart';

class MyPublicationsBloc extends GenericBloc<List<Map<String, dynamic>>> {
  getPublicationsAll(
      String nomeCollection, String idUser, double lat, double long) async {
    try {
      var publicationsOne = await PublicationService.getMyPublications(
          nameCollection: nomeCollection,
          idUser: idUser,
          latUser: lat,
          longUser: long);
      add(publicationsOne);
    } catch (e) {
      return e;
    }
  }

  getPublicationsAnimalSearch(String nomeCollection, String idUser, double lat,
      double long, String search) async {
    try {
      var publications = await PublicationService.getMyPublications(
          nameCollection: nomeCollection,
          idUser: idUser,
          latUser: lat,
          longUser: long,
          nameSeach: search);
      add(publications);
    } catch (e) {
      return e;
    }
  }

  getPublicationsInformativeSearch(String nomeCollection, String idUser,
      double lat, double long, String search) async {
    try {
      var publications = await PublicationService.getMyPublications(
          nameCollection: nomeCollection,
          idUser: idUser,
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
