import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:convert';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter_google_places/flutter_google_places.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:hotfoot/src/utils/step.dart';

class Atlas extends StatefulWidget {
  @override
  State<Atlas> createState() {
    return _Atlas();
  }
}

class _Atlas extends State<Atlas> {
  // TODO: API Key.
  static const kGoogleApiKey = "";
  GoogleMapsPlaces _places = GoogleMapsPlaces(apiKey: kGoogleApiKey);
  Map<MarkerId, Marker> _markers = <MarkerId, Marker>{};
  Map<MarkerId, Polyline> _polylines = <MarkerId, Polyline>{};
  GoogleMapController _controller;
  MarkerId _prevQueryMarkerId;
  LatLng _userLatLng;
  List<LatLng> _path = List();

  @override
  void initState() {
    // Fetches user's current location.
    Geolocator()
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.high)
        .then((Position position) {
      setState(() {
        _userLatLng = LatLng(position.latitude, position.longitude);
        _addMarker(_userLatLng, "user_current_location", "You are here!");
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: GoogleMap(
          initialCameraPosition: CameraPosition(
            target: LatLng(0, 0),
            zoom: 12,
          ),
          mapType: MapType.normal,
          onMapCreated: (GoogleMapController controller) {
            _controller = controller;
          },
          markers: Set<Marker>.of(_markers.values),
          polylines: Set<Polyline>.of(_polylines.values),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.search),
        onPressed: () async {
          // show input autocomplete with selected mode
          // then get the Prediction selected
          Prediction p = await PlacesAutocomplete.show(
              context: context, apiKey: kGoogleApiKey);
          _updateAtlasWithQuery(p);
        },
      ),
    );
  }

  void _addMarker(markerLatLng, markerIdVal, info) {
    final MarkerId markerId = MarkerId(markerIdVal);

    setState(() {
      _markers[markerId] = Marker(
        markerId: markerId,
        position: markerLatLng,
        infoWindow: InfoWindow(title: info),
      );
      _polylines[markerId] = Polyline(
        polylineId: PolylineId(_userLatLng.toString()),
        visible: true,
        points: _path,
        width: 4,
        color: Colors.black87,
      );
    });

    // Move the camera to the newly added marker.
    _controller.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
      target: markerLatLng,
      zoom: 12,
    )));
  }

  Future<Null> _updateAtlasWithQuery(Prediction p) async {
    if (p != null) {
      PlacesDetailsResponse detail =
          await _places.getDetailsByPlaceId(p.placeId);

      // Remove the previously queried marker from the map.
      if (_prevQueryMarkerId != null) {
        _markers.remove(_prevQueryMarkerId);
        _polylines.remove(_prevQueryMarkerId);
      }
      LatLng markerLatLng = LatLng(detail.result.geometry.location.lat,
          detail.result.geometry.location.lng);
      // Replace the _path with new steps.
      _path = await _getPathBetweenSrcAndDst(_userLatLng, markerLatLng);
      _addMarker(markerLatLng, detail.result.name, detail.result.name);
      _prevQueryMarkerId = MarkerId(detail.result.name);
    }
  }

  Future<List<LatLng>> _getPathBetweenSrcAndDst(srcLatLng, dstLatLng) {
    return http
        .get("https://maps.googleapis.com/maps/api/directions/json?origin=" +
            srcLatLng.latitude.toString() +
            "," +
            srcLatLng.longitude.toString() +
            "&destination=" +
            dstLatLng.latitude.toString() +
            "," +
            dstLatLng.longitude.toString() +
            "&key=$kGoogleApiKey")
        .then((dynamic res) {
      try {
        List<LatLng> path = List();
        List<Steps> steps = (JsonDecoder().convert(res.body)["routes"][0]["legs"]
                [0]["steps"])
            .map<Steps>((json) => new Steps.fromJson(json))
            .toList();
        for (final step in steps) {
          path.add(step.startLatLng);
          path.add(step.endLatLng);
        }
        return path;
      } catch (e) {
        throw new Exception("Cannot parse steps properly!");
      }
    });
  }
}
