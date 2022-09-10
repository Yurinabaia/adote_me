import 'package:adoteme/data/models/publication_model.dart';
import 'package:adoteme/data/service/publication_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class GenereateDataTest {
  final String idUser;
  GenereateDataTest(this.idUser) {
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
    publicationModel.setIdUser(idUser);
    publicationModel.setColor('11999999999');
    publicationModel.setDescription('Descrição do animal');
    publicationModel.setSize('Mini');
    publicationModel.setTypePublication('animal_adoption');
    publicationModel.setCreateDate(Timestamp.fromDate(DateTime.now()));
    publicationModel.setUpdateDate(Timestamp.fromDate(DateTime.now()));

    Map<String, dynamic> dataInformative = {
      'idUser': idUser,
      'title': 'teste',
      'description': '_description',
      'url': 'https://picsum.photos/id/248/200/300',
      'imageCover': 'https://picsum.photos/id/248/200/300',
      'listImages': [
        'https://picsum.photos/id/237/200/300',
        'https://picsum.photos/id/238/200/300',
        'https://picsum.photos/id/239/200/300',
        'https://picsum.photos/id/240/200/300',
      ],
      'createdAt': Timestamp.fromDate(DateTime.now()),
      'updatedAt': Timestamp.fromDate(DateTime.now()),
      'typePublication': 'informative',
    };

    for (var i = 0; i < 5; i++) {
      if (i == 2) {
        publicationModel.setTypePublication('animal_lost');
      }
      publicationModel.setAnimalPhotos([
        'https://picsum.photos/id/237/200/300',
        'https://picsum.photos/id/238/200/300',
        'https://picsum.photos/id/239/200/300',
        'https://picsum.photos/id/240/200/300',
        'https://picsum.photos/id/241/200/300',
        'https://picsum.photos/id/242/200/300',
      ]);
      publicationModel.setPicturesVaccineCard([
        'https://picsum.photos/id/237/200/300',
        'https://picsum.photos/id/238/200/300',
        'https://picsum.photos/id/239/200/300',
        'https://picsum.photos/id/240/200/300',
      ]);
      await PublicationService.createPublication(
          publicationModel.toJsonAdoption(), 'publications_animal');
      await PublicationService.createPublication(
          dataInformative, 'informative_publication');
    }
  }
}
