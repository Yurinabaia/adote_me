import 'package:adoteme/data/models/address/via_cep_model.dart';
// ignore: depend_on_referenced_packages
import 'package:http/http.dart' as http;

class ViaCepService {
  static Future<ViaCepModel?> getEndereco(String cep) async {
    var url = Uri.http("viacep.com.br", "/ws/$cep/json/");
    final response = await http.get(url);
    if (response.statusCode == 200) {
      var jsonRespose = response.body;
      var result = viaCepModelFromJson(jsonRespose);
      return result;
    } else {
      return null;
    }
  }
}
