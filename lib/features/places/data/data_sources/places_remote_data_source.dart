import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hotfoot/features/places/data/models/place_model.dart';
import 'package:meta/meta.dart';

abstract class IPlacesRemoteDataSource {
  Future<List<String>> getPlacesIds();

  Future<PlaceModel> getPlaceById({@required String id});
}

class PlacesRemoteDataSource implements IPlacesRemoteDataSource {
  final Firestore firestore;
  CollectionReference _placesCollection;

  PlacesRemoteDataSource({
    @required this.firestore,
  })  : assert(firestore != null),
        this._placesCollection = firestore.collection('places');

  @override
  Future<PlaceModel> getPlaceById({String id}) async {
    final placeJson = (await _placesCollection.document(id).get()).data;
    return PlaceModel.fromJson(placeJson);
  }

  @override
  Future<List<String>> getPlacesIds() async {
    final Stream<QuerySnapshot> placesStream = _placesCollection.snapshots();
    List<String> placesIds = List<String>();

    placesStream.listen((snapshot) {
      snapshot.documents.forEach((document) {
        placesIds.add(document.documentID);
      });
      print(placesIds);
    });

    return placesIds;
  }
}
