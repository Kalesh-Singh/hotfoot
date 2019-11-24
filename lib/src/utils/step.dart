import 'package:google_maps_flutter/google_maps_flutter.dart';

class Steps {
  LatLng startLatLng;
  LatLng endLatLng;

  Steps({this.startLatLng, this.endLatLng});

  factory Steps.fromJson(Map<String, dynamic> json) {
    return new Steps(
        startLatLng: new LatLng(
            json["start_location"]["lat"], json["start_location"]["lng"]),
        endLatLng: new LatLng(
            json["end_location"]["lat"], json["end_location"]["lng"]));
  }
}