// To parse this JSON data, do
//
//     final viaCepModel = viaCepModelFromJson(jsonString);

import 'dart:convert';

ViaCepModel viaCepModelFromJson(String str) =>
    ViaCepModel.fromJson(json.decode(str));

String viaCepModelToJson(ViaCepModel data) => json.encode(data.toJson());

class ViaCepModel {
  String? cep;
  String? logradouro;
  String? complemento;
  String? bairro;
  String? uf;
  String? numero;
  String? localidade;

  ViaCepModel({
    this.cep,
    this.logradouro,
    this.complemento,
    this.bairro,
    this.uf,
    this.numero,
    this.localidade,
  });

  factory ViaCepModel.fromJson(Map<String, dynamic> json) => ViaCepModel(
        cep: json["cep"],
        logradouro: json["logradouro"],
        complemento: json["complemento"],
        bairro: json["bairro"],
        uf: json["uf"],
        localidade: json["localidade"],
      );

  Map<String, dynamic> toJson() => {
        "cep": cep,
        "logradouro": logradouro,
        "complemento": complemento,
        "bairro": bairro,
        "uf": uf,
        "numero": numero,
        "localidade": localidade,
      };
}
