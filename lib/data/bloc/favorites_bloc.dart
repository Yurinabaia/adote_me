import 'package:adoteme/data/bloc/generic_bloc.dart';
import 'package:adoteme/data/service/publication_service.dart';

class FavoritesBloc extends GenericBloc<List<Map<String, dynamic>>> {
  getPublicationsAll(String nomeCollection, List<String?> listIdSupplicated,
      double latUser, double longUser, Map<String, dynamic> objFilter) async {
    try {
      var publicationsOne = await PublicationService.getFavorites(
          nomeCollection, listIdSupplicated, latUser, longUser, objFilter);
      add(publicationsOne);
    } catch (e) {
      return e;
    }
  }

  get streams => stream;
}
