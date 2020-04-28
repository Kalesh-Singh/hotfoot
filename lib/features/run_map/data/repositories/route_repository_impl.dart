import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hotfoot/core/error/failures.dart';
import 'package:hotfoot/features/location/domain/entities/location_entity.dart';
import 'package:hotfoot/features/run_map/domain/repositories/route_repository.dart';
import 'package:http/http.dart' as http;
import 'package:meta/meta.dart';

class RouteRepository implements IRouteRepository {
  // TODO: API Key.
  final String apiKey = "";

  @override
  Future<Either<Failure, List<LatLng>>> getRouteBetweenPoints(
      {@required LocationEntity l1, @required LocationEntity l2}) async {
    try {
      final String request =
          "https://maps.googleapis.com/maps/api/directions/json?" +
              "origin=${l1.lat},${l1.lng}&" +
              "destination=${l2.lat},${l2.lng}&" +
              "key=$apiKey";
      final http.Response response = await http.get(request);
      final String polyline =
          jsonDecode(response.body)["routes"][0]["overview_polyline"]["points"];
      print("Route received from REST call");
      return Right(_convertToLatLng(_decodePolyline(polyline)));
    } catch (e) {
      print(e);
      return Left(GoogleMapsFailure());
    }
  }

  List<LatLng> _convertToLatLng(List decodedPolyline) {
    List<LatLng> result = <LatLng>[];
    for (int i = 0; i < decodedPolyline.length; i++) {
      if (i % 2 != 0) {
        result.add(LatLng(decodedPolyline[i - 1], decodedPolyline[i]));
      }
    }
    return result;
  }

  List _decodePolyline(String encodedPolyline) {
    var list = encodedPolyline.codeUnits;
    var lList = new List();
    int index = 0;
    int c = 0;
    // Repeating until all attributes are decoded
    do {
      var shift = 0;
      int result = 0;
      // For decoding value of one attribute
      do {
        c = list[index] - 63;
        result |= (c & 0x1F) << (shift * 5);
        index++;
        shift++;
      } while (c >= 32);
      // If value is negative then bitwise not the value
      if (result & 1 == 1) {
        result = ~result;
      }
      var result1 = (result >> 1) * 0.00001;
      lList.add(result1);
    } while (index < encodedPolyline.length);
    // Adding to previous value as done in encoding
    for (var i = 2; i < lList.length; i++) lList[i] += lList[i - 2];
    return lList;
  }
}
