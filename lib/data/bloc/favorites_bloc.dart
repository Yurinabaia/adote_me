import 'package:adoteme/data/bloc/generic_bloc.dart';
import 'package:adoteme/data/service/publication_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FavoritesBloc extends GenericBloc<QuerySnapshot<Map<String, dynamic>>> {
  getPublicationsAll(
      String nomeCollection, List<String?>? listIdPublicated) async {
    try {
      var publicationsOne = await PublicationService.getFavorites(
          nomeCollection, listIdPublicated);
      add(publicationsOne);
    } catch (e) {
      return e;
    }
  }

  get streams => stream;
}
