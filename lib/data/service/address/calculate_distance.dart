// ignore_for_file: avoid_function_literals_in_foreach_calls

import 'dart:math';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class CalculateDistance {
  PolylinePoints polylinePoints = PolylinePoints();
  String googleAPiKey = "AIzaSyBlbUEqpPXp1U5EvlF1albkPPCjGsqn5vc";
  Map<PolylineId, Polyline> polylines = {}; //polylines to show direction

  static double calculateDistance(lat1, lon1, lat2, lon2) {
    if (lat1 == 0 || lon1 == 0 || lat2 == 0 || lon2 == 0) {
      return 0;
    }
    var p = 0.017453292519943295;
    var a = 0.5 -
        cos((lat2 - lat1) * p) / 2 +
        cos(lat1 * p) * cos(lat2 * p) * (1 - cos((lon2 - lon1) * p)) / 2;
    return 12742 * asin(sqrt(a));
  }

  Future<double> getDirections(latInc, logInc, latFin, logFin) async {
    LatLng startLocation = LatLng(latInc, logInc);
    LatLng endLocation = LatLng(latFin, logFin);
    List<LatLng> polylineCoordinates = [];

    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
      googleAPiKey,
      PointLatLng(startLocation.latitude, startLocation.longitude),
      PointLatLng(endLocation.latitude, endLocation.longitude),
      travelMode: TravelMode.driving,
    );

    if (result.points.isNotEmpty) {
      result.points.forEach((PointLatLng point) {
        polylineCoordinates.add(LatLng(point.latitude, point.longitude));
      });
    }

    //polulineCoordinates is the List of longitute and latidtude.
    double totalDistance = 0;
    for (var i = 0; i < polylineCoordinates.length - 1; i++) {
      totalDistance += calculateDistance(
          polylineCoordinates[i].latitude,
          polylineCoordinates[i].longitude,
          polylineCoordinates[i + 1].latitude,
          polylineCoordinates[i + 1].longitude);
    }
    // print("totalll:: $totalDistance");
    return totalDistance;
  }

  static Future<Map> addressCordenate(String address) async {
    List<Location> placemark = await locationFromAddress(address);
    return {"lat": placemark[0].latitude, "long": placemark[0].longitude};
  }
}
