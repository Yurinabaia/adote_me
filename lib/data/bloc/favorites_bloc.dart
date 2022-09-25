import 'package:adoteme/data/bloc/generic_bloc.dart';
import 'package:adoteme/data/service/publication_service.dart';

class FavoritesBloc extends GenericBloc<List<Map<String, dynamic>>> {
  getPublicationsAll(String nomeCollection, List<String?> listIdPublicated,
      double latUser, double longUser) async {
    try {
      var publicationsOne = await PublicationService.getFavorites(
          nomeCollection, listIdPublicated, latUser, longUser);
      add(publicationsOne);
    } catch (e) {
      return e;
    }
  }

  get streams => stream;
}
