import 'package:adoteme/data/bloc/generic_bloc.dart';
import 'package:adoteme/data/service/publication_service.dart';
import 'package:adoteme/data/service/search_publication_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class MyPublicationsBloc extends GenericBloc<QuerySnapshot<Map<String, dynamic>>> {

  getPublicationsAll(String nomeCollection, String idUser) async {
    try {
      var publicationsOne = await PublicationService.getMyPublications(nomeCollection, idUser);
      add(publicationsOne);
    } catch (e) {
      return e;
    }
  }

  getPublicationsAnimalSearch(String nomeCollection, String idUser, String search) async {
    try {
      var publications = await SearchPublicationService.getPublicationsAnimalSearch(nomeCollection, search, idUser);
      add(publications);
    } catch (e) {
      return e;
    }
  }

  getPublicationsInformativeSearch(String nomeCollection, String idUser, String search) async {
    try {
      var publications = await SearchPublicationService.getPublicationsInformativeSearch(nomeCollection, search, idUser);
      add(publications);
    } catch (e) {
      return e;
    }
  }

  get streams => stream;
}
