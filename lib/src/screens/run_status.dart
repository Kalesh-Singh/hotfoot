import 'package:flutter/material.dart';
import 'dart:async';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter_google_places/flutter_google_places.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:geolocator/geolocator.dart';

class RunStatusScreen extends StatelessWidget {
  static String keyword = "YEET!";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Run Status'),
        ),
        body: Center(
          child: Atlas(keyword),
        ));
  }
}

Widget submitButton(context) {
  return RaisedButton(
    onPressed: () {
      Navigator.pushNamed(context, '/home');
    },
    child: Text('Home'),
  );
}

class Atlas extends StatefulWidget {
  final String keyword;

  Atlas(this.keyword);

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
  GoogleMapController _controller;
  MarkerId _prevQueryMarkerId;

  @override
  void initState() {
    // Fetches user's current location.
    Geolocator()
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.high)
        .then((Position position) {
      setState(() {
        _addMarker(position.latitude, position.longitude,
            "user_current_location", "You are here!");
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

  void _addMarker(lat, lng, markerIdVal, info) {
    final MarkerId markerId = MarkerId(markerIdVal);

    final Marker marker = Marker(
      markerId: markerId,
      position: LatLng(
        lat,
        lng,
      ),
      infoWindow: InfoWindow(title: info),
    );

    setState(() {
      _markers[markerId] = marker;
    });

    // Move the camera to the newly added marker.
    _controller.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
      target: LatLng(lat, lng),
      zoom: 12,
    )));
  }

  Future<Null> _updateAtlasWithQuery(Prediction p) async {
    if (p != null) {
      PlacesDetailsResponse detail =
          await _places.getDetailsByPlaceId(p.placeId);

      double lat = detail.result.geometry.location.lat;
      double lng = detail.result.geometry.location.lng;

      // Remove the previously queried marker from the map.
      if (_prevQueryMarkerId != null) {
        _markers.remove(_prevQueryMarkerId);
      }
      _addMarker(lat, lng, detail.result.name, detail.result.name);
      _prevQueryMarkerId = MarkerId(detail.result.name);
    }
  }
}
