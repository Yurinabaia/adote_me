import 'package:adoteme/data/bloc/generic_bloc.dart';
import 'package:adoteme/data/service/publication_service.dart';
import 'package:adoteme/data/service/search_publication_service.dart';

class SuccessCaseBloc extends GenericBloc<List<Map<String, dynamic>>> {
  getSuccessCaseAll(Map<String, dynamic> objFilter) async {
    try {
      var publications = await PublicationService.getSuccessCaseAll(objFilter);
      add(publications);
    } catch (e) {
      return e;
    }
  }

  getSuccessCaseSearch(String search, Map<String, dynamic> objFilter) async {
    try {
      var publications = await SearchPublicationService.getSuccessCaseSearch(
          search, objFilter);
      add(publications);
    } catch (e) {
      return e;
    }
  }

  get streams => stream;
}
