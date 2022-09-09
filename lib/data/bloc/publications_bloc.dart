import 'package:adoteme/data/bloc/generic_bloc.dart';
import 'package:adoteme/data/service/publication_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class PublicationsBloc
    extends GenericBloc<QuerySnapshot<Map<String, dynamic>>> {
  getPublications(String nomeCollection) async {
    try {
      var publicationsOne =
          await PublicationService.getPublicationAll(nomeCollection);
      add(publicationsOne);
    } catch (e) {
      return e;
    }
  }

  get streams => stream;
}
