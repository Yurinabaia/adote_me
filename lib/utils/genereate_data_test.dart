import 'package:adoteme/data/models/publication_model.dart';
import 'package:adoteme/data/service/publication_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class GenereateDataTest {
  GenereateDataTest() {
    main();
  }
  main() async {
    PublicationModel publicationModel = PublicationModel();
    Map<String, dynamic> address = {
      'street': 'Rua 1',
      'number': '1',
      'complement': '1',
      'district': 'Vista Alegre',
      'city': 'São Paulo',
      'state': 'SP',
      'zipCode': '12345678',
    };

    publicationModel.setAddress(address);
    publicationModel.setAge(10);
    publicationModel.setAnimal('Nome do animal');
    publicationModel.setCastrated('Sim');
    publicationModel.setBreed('Raça do animal');
    publicationModel.setName('Nome do animal');
    publicationModel.setSex('Macho');
    publicationModel.setTemperament('Temperamento do animal');
    publicationModel.setIdUser('DqJMvALZEGSvgBRJXPW3xR7iE8x1');
    publicationModel.setColor('11999999999');
    publicationModel.setDescription('Descrição do animal');
    publicationModel.setSize('Tamanho do animal');
    publicationModel.setTypePublication('animal_adoption');
    publicationModel.setCreateDate(Timestamp.fromDate(DateTime.now()));
    Map<String, dynamic> dataInformative = {
      'idUser': 'DqJMvALZEGSvgBRJXPW3xR7iE8x1',
      'title': 'teste',
      'description': '_description',
      'url': 'https://picsum.photos/id/248/200/300',
      'imageCover': 'https://picsum.photos/id/248/200/300',
      'listImages': ['https://picsum.photos/id/248/200/300'],
      'createdAt': Timestamp.fromDate(DateTime.now()),
      'updatedAt': Timestamp.fromDate(DateTime.now()),
      'typePublication': 'informative',
    };

    for (var i = 0; i < 500; i++) {
      publicationModel
          .setAnimalPhotos(['https://picsum.photos/id/237/200/300']);
      await PublicationService.createPublication(
          publicationModel.toJsonAdoption(), 'publications_animal');
      await PublicationService.createPublication(
          dataInformative, 'informative_publication');
    }
  }
}
