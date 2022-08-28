import 'package:adoteme/data/models/address/via_cep_model.dart';
import 'package:adoteme/data/service/address/via_cep_service.dart';
import 'package:get/state_manager.dart';

class ViaCepController {
  var isLoading = true.obs;
  var viaCep = ViaCepModel().obs;
  Future<ViaCepModel> fetchViaCep(String cep) async {
    try {
      isLoading(true);
      viaCep = ViaCepModel().obs;
      var adress = await ViaCepService.getEndereco(cep);
      if (adress != null) {
        return viaCep.value = adress;
      }
    } finally {
      isLoading(false);
    }
    return ViaCepModel();
  }
}
