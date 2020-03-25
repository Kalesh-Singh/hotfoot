import 'dart:io';

import 'package:hotfoot/features/places/data/data_sources/data_access_objects/place_dao.dart';
import 'package:hotfoot/features/places/data/data_sources/data_access_objects/place_photo_dao.dart';
import 'package:hotfoot/features/places/data/models/place_model.dart';
import 'package:meta/meta.dart';

abstract class IPlacesLocalDataSource {
  Future<List<String>> getPlacesIds();

  /// Returns null if key is not found
  Future<PlaceModel> getPlaceById({@required String id});

  /// Returns the inserted File
  Future<void> insertOrUpdatePlace({@required PlaceModel placeModel});

  /// Returns [null] if id is not found.
  Future<File> getPhoto({@required String id});

  Future<void> insertOrUpdatePhoto({
    @required String id,
    @required File photoFile,
  });
}

class PlacesLocalDataSource implements IPlacesLocalDataSource {
  final IPlaceDao placeDao;
  final IPlacePhotoDao placePhotoDao;

  const PlacesLocalDataSource({
    @required this.placeDao,
    @required this.placePhotoDao,
  })  : assert(placeDao != null),
        assert(placePhotoDao != null);

  @override
  Future<PlaceModel> getPlaceById({String id}) async {
    return await placeDao.get(id: id);
  }

  @override
  Future<List<String>> getPlacesIds() async {
    print('Getting place ids from sembast');
    List<PlaceModel> places = await placeDao.getAll();
    print('Got place ids from sembast');
    print('Number of places ${places.length}');
    return places.map((place) => place.id).toList();
  }

  @override
  Future<void> insertOrUpdatePlace({PlaceModel placeModel}) async {
    return await placeDao.insertOrUpdate(placeModel: placeModel);
  }

  @override
  Future<File> getPhoto({String id}) async {
    return await placePhotoDao.get(id: id);
  }

  @override
  Future<void> insertOrUpdatePhoto({String id, File photoFile}) async {
    return await placePhotoDao.insertOrUpdate(
      id: id,
      photoFile: photoFile,
    );
  }
}
