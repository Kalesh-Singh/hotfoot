import 'dart:io';

import 'package:hotfoot/features/places/data/data_sources/places_local_data_source.dart';
import 'package:hotfoot/features/places/data/data_sources/places_remote_data_source.dart';
import 'package:hotfoot/features/places/data/models/place_model.dart';
import 'package:hotfoot/features/places/domain/repositories/places_repository.dart';
import 'package:meta/meta.dart';

class PlacesRepository implements IPlacesRepository {
  final IPlacesLocalDataSource placesLocalDataSource;
  final IPlacesRemoteDataSource placesRemoteDataSource;

  PlacesRepository({
    @required this.placesLocalDataSource,
    @required this.placesRemoteDataSource,
    // TODO: Add flutter store dependency here
  })  : assert(placesLocalDataSource != null),
        assert(placesRemoteDataSource != null);

  // TODO: Assert flutter store != null

  @override
  Future<PlaceModel> getPlaceById({String id}) {
    // TODO: implement getPlaceById
    return null;
  }

  @override
  Future<File> getPlacePhotoById({String id}) {
    // TODO: implement getPlacePhotoById
    return null;
  }

  @override
  Future<List<String>> getPlacesIds() {
    // TODO: implement getPlacesIds
    return null;
  }
}
