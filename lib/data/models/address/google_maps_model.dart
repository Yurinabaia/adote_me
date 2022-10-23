// To parse this JSON data, do
//
//     final googleMaps = googleMapsFromJson(jsonString);

import 'dart:convert';

GoogleMaps googleMapsFromJson(String str) =>
    GoogleMaps.fromJson(json.decode(str));

String googleMapsToJson(GoogleMaps data) => json.encode(data.toJson());

class GoogleMaps {
  List<String>? destinationAddresses;
  List<String>? originAddresses;
  List<Row>? rows;
  String? status;

  GoogleMaps({
    this.destinationAddresses,
    this.originAddresses,
    this.rows,
    this.status,
  });

  factory GoogleMaps.fromJson(Map<String, dynamic> json) => GoogleMaps(
        destinationAddresses:
            List<String>.from(json["destination_addresses"].map((x) => x)),
        originAddresses:
            List<String>.from(json["origin_addresses"].map((x) => x)),
        rows: List<Row>.from(json["rows"].map((x) => Row.fromJson(x))),
        status: json["status"],
      );

  Map<String, dynamic> toJson() => {
        "destination_addresses":
            List<dynamic>.from(destinationAddresses!.map((x) => x)),
        "origin_addresses": List<dynamic>.from(originAddresses!.map((x) => x)),
        "rows": List<dynamic>.from(rows!.map((x) => x.toJson())),
        "status": status,
      };
}

class Row {
  Row({
    required this.elements,
  });

  List<Element> elements;

  factory Row.fromJson(Map<String, dynamic> json) => Row(
        elements: List<Element>.from(
            json["elements"].map((x) => Element.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "elements": List<dynamic>.from(elements.map((x) => x.toJson())),
      };
}

class Element {
  Distance? distance;
  Distance? duration;
  String? status;

  Element({
    this.distance,
    this.duration,
    this.status,
  });

  factory Element.fromJson(Map<String, dynamic> json) => Element(
        distance: Distance.fromJson(json["distance"]),
        duration: Distance.fromJson(json["duration"]),
        status: json["status"],
      );

  Map<String, dynamic> toJson() => {
        "distance": distance?.toJson(),
        "duration": duration?.toJson(),
        "status": status,
      };
}

class Distance {
  String? text;
  int? value;

  Distance({
    this.text,
    this.value,
  });

  factory Distance.fromJson(Map<String, dynamic> json) => Distance(
        text: json["text"],
        value: json["value"],
      );

  Map<String, dynamic> toJson() => {
        "text": text,
        "value": value,
      };
}
