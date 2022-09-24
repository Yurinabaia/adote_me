import 'package:geolocator/geolocator.dart';

class CurrentLocation {
  static Future<Map<dynamic, dynamic>> getPosition() async {
    var lat = 0.0;
    var long = 0.0;
    try {
      Position position = await _postionCurrentPosition();
      lat = position.latitude;
      long = position.longitude;
    } catch (e) {
      rethrow;
    }
    return {"lat": lat, "long": long};
  }

  static Future<Position> _postionCurrentPosition() async {
    LocationPermission permission;
    bool isPermission = await Geolocator.isLocationServiceEnabled();
    if (!isPermission) {
      return Future.error('Location services are disabled.');
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Position(
            latitude: 0.0,
            longitude: 0.0,
            accuracy: 0.0,
            altitude: 0.0,
            speed: 0.0,
            timestamp: DateTime.now(),
            heading: 0.0,
            speedAccuracy: 0.0);
      }
    }
    if (permission == LocationPermission.deniedForever) {
      return Position(
          latitude: 0.0,
          longitude: 0.0,
          accuracy: 0.0,
          altitude: 0.0,
          speed: 0.0,
          timestamp: DateTime.now(),
          heading: 0.0,
          speedAccuracy: 0.0);
    }
    //permissionFail = false;
    return await Geolocator.getCurrentPosition();
  }
}
