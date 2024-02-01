import 'package:flutter/foundation.dart';
import 'package:geolocator/geolocator.dart';

class Location {
  double? latitude;
  double? longitude;

  Future getCurrentLocation() async {
    try {
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
      latitude = position.latitude;
      longitude = position.longitude;
      debugPrint(latitude.toString());
      debugPrint(longitude.toString());
    } catch (e) {
      if (kDebugMode) {
        e.toString();
      }
    }
  }
}
