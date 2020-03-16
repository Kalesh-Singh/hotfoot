import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:meta/meta.dart';

class PlacesRepository {
  final Firestore firestore;

  PlacesRepository({
    @required this.firestore,
  });

  void getPlacesIds() {
    final placesStream = firestore.collection('places').snapshots();
    placesStream.listen((snapshot) {
      print(snapshot.documents[0]);
    });
  }
}
