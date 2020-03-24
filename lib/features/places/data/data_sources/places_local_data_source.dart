import 'package:hotfoot/features/places/data/data_sources/data_access_objects/place_dao.dart';
import 'package:hotfoot/features/places/data/models/place_model.dart';
import 'package:meta/meta.dart';

abstract class IPlacesLocalDataSource {
  Future<List<String>> getPlacesIds();

  Future<PlaceModel> getPlaceById({@required String id});
}

class PlacesLocalDataSource implements IPlacesLocalDataSource {
  final PlaceDao placeDao;

  const PlacesLocalDataSource({@required this.placeDao});

  @override
  Future<PlaceModel> getPlaceById({String id}) async {
    return await placeDao.get(id: id);
  }

  @override
  Future<List<String>> getPlacesIds() async {
    List<PlaceModel> places = await placeDao.getAll();
    return places.map((place) => place.id).toList();
  }
}
