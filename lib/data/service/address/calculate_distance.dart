import 'dart:math';
import 'package:adoteme/data/models/address/google_maps_model.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
// ignore: depend_on_referenced_packages
import 'package:http/http.dart' as http;

class CalculateDistance {
  PolylinePoints polylinePoints = PolylinePoints();
  String googleAPiKey = "AIzaSyBlbUEqpPXp1U5EvlF1albkPPCjGsqn5vc";
  Map<PolylineId, Polyline> polylines = {};

  double calculateDistanceOld(lat1, lon1, lat2, lon2) {
    var p = 0.017453292519943295;
    var a = 0.5 -
        cos((lat2 - lat1) * p) / 2 +
        cos(lat1 * p) * cos(lat2 * p) * (1 - cos((lon2 - lon1) * p)) / 2;
    return 12742 * asin(sqrt(a));
  }

  static Future<double> calculateDistance(
      latInc, logInc, latFin, logFin) async {
    var url =
        Uri.https("maps.googleapis.com", "/maps/api/distancematrix/json", {
      "destinations": "$latFin,$logFin",
      "origins": "$latInc,$logInc",
      "key": 'AIzaSyCSCViqmqeh027FArRJBOeXf-XJvYayzr0',
    });
    final response = await http.get(url);
    if (response.statusCode == 200) {
      var jsonRespose = response.body;
      var result = googleMapsFromJson(jsonRespose);

      return result.rows![0].elements[0].distance!.value!.toDouble() / 1000;
    } else {
      return 0.0;
    }
  }

  static Future<Map> addressCoordinate(String address) async {
    List<Location> placemark = await locationFromAddress(address);
    return {"lat": placemark[0].latitude, "long": placemark[0].longitude};
  }
}
