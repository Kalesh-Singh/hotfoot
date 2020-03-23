import 'package:hotfoot/features/places/data/models/place_model.dart';
import 'package:meta/meta.dart';

abstract class IPlacesLocalDataSource {
  Future<List<String>> getPlacesIds();

  Future<PlaceModel> getPlaceById({@required String id});

  Future<void> savePlace({@required PlaceModel placeModel});
}

class PlacesLocalDataSource implements IPlacesLocalDataSource {

  // TODO: Add sembast dependency

  @override
  Future<PlaceModel> getPlaceById({String id}) {
    // TODO: implement getPlaceById
    return null;
  }

  @override
  Future<List<String>> getPlacesIds() {
    // TODO: implement getPlacesIds
    return null;
  }

  @override
  Future<void> savePlace({PlaceModel placeModel}) {
    // TODO: implement savePlace
    return null;
  }
}
