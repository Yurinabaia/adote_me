import 'package:adoteme/data/models/address/via_cep_model.dart';
// ignore: depend_on_referenced_packages
import 'package:http/http.dart' as http;

class ViaCepService {
  static Future<ViaCepModel?> getAddress(String cep) async {
    var url = Uri.http("viacep.com.br", "/ws/$cep/json/");
    final response = await http.get(url);
    if (response.statusCode == 200) {
      var jsonResponse = response.body;
      var result = viaCepModelFromJson(jsonResponse);
      return result;
    } else {
      return null;
    }
  }
}
