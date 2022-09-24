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
      'street': 'Avenida Ortocrim',
      'number': '435',
      'complement': '1',
      'district': 'Belo Vale',
      'city': 'Santa Luzia',
      'state': 'MG',
      'zipCode': '12345678',
      'lat': -19.7852938,
      'long': -43.9505989,
    };
    publicationModel.setAddress(address);
    publicationModel.setAge(10);
    publicationModel.setAnimal('Cão');
    publicationModel.setCastrated('Sim');
    publicationModel.setBreed('Raça do animal');
    publicationModel.setName('Cidade Administrativa');
    publicationModel.setSex('Macho');
    publicationModel.setTemperament('Temperamento do animal');
    publicationModel.setIdUser(idUser);
    publicationModel.setColor('11999999999');
    publicationModel.setDescription('Descrição do animal');
    publicationModel.setSize('Mini');
    publicationModel.setTypePublication('animal_adoption');
    publicationModel.setCreateDate(Timestamp.fromDate(DateTime.now()));
    publicationModel.setUpdateDate(Timestamp.fromDate(DateTime.now()));
    publicationModel.setStatus('in_progress');
    publicationModel.setIdUser('DqJMvALZEGSvgBRJXPW3xR7iE8x1');

    Map<String, dynamic> dataInformative = {
      'idUser': idUser,
      'title': 'Cidade Administrativa',
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
      'status': 'in_progress',
    };

    for (var i = 0; i < 6; i++) {
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
