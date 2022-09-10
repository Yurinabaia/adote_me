import 'package:adoteme/data/bloc/generic_bloc.dart';
import 'package:adoteme/data/service/publication_service.dart';
import 'package:adoteme/data/service/search_publication_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SuccessCaseBloc extends GenericBloc<QuerySnapshot<Map<String, dynamic>>> {
  getSuccessCaseAll() async {
    try {
      var publications = await PublicationService.getSuccessCaseAll();
      add(publications);
    } catch (e) {
      return e;
    }
  }

  getSuccessCaseSearch(String search) async {
    try {
      var publications = await SearchPublicationService.getSuccessCaseSearch(search);
      add(publications);
    } catch (e) {
      return e;
    }
  }

  get streams => stream;
}
