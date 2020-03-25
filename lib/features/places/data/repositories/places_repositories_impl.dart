import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:hotfoot/core/error/failures.dart';
import 'package:hotfoot/core/network/network_info.dart';
import 'package:hotfoot/features/places/data/data_sources/places_local_data_source.dart';
import 'package:hotfoot/features/places/data/data_sources/places_remote_data_source.dart';
import 'package:hotfoot/features/places/data/models/place_model.dart';
import 'package:hotfoot/features/places/domain/repositories/places_repository.dart';
import 'package:meta/meta.dart';

class PlacesRepository implements IPlacesRepository {
  final IPlacesLocalDataSource placesLocalDataSource;
  final IPlacesRemoteDataSource placesRemoteDataSource;
  final INetworkInfo networkInfo;

  PlacesRepository({
    @required this.placesLocalDataSource,
    @required this.placesRemoteDataSource,
    @required this.networkInfo,
    // TODO: Add flutter store dependency here
  })  : assert(placesLocalDataSource != null),
        assert(placesRemoteDataSource != null),
        assert(networkInfo != null);

  // TODO: Assert flutter store != null

  @override
  Future<Either<Failure, PlaceModel>> getPlaceById(
      {@required String id}) async {
    // Get from local data source if present else get from remote data source.

    PlaceModel placeModel = await placesLocalDataSource.getPlaceById(id: id);

    if (placeModel != null) {
      return Right(placeModel);
    }

    if (!(await networkInfo.isConnected)) {
      return Left(DatabaseFailure());
    }

    try {
      placeModel = await placesRemoteDataSource.getPlaceById(id: id);
      await placesLocalDataSource.insertOrUpdatePlace(placeModel: placeModel);
      return Right(placeModel);
    } catch (e) {
      print(e);
      return Left(FirestoreFailure());
    }
  }

  @override
  Future<Either<Failure, File>> getPlacePhoto({String id, String url}) async {
    // Only reach out to remote repository if there is no image
    // cached locally

    File photoFile = await placesLocalDataSource.getPhoto(id: id);

    if (photoFile != null) {
      return Right(photoFile);
    }

    try {
      photoFile = await placesRemoteDataSource.getPhoto(url: url);
      await placesLocalDataSource.insertOrUpdatePhoto(
        id: id,
        photoFile: photoFile,
      );
      return Right(photoFile);
    } catch (e) {
      return Left(FirebaseStorageFailure());
    }
  }

  @override
  Future<Either<Failure, List<String>>> getPlacesIds() async {
    // Always get from remote data source if possible, in order
    // to provide up to date data.
    if (await networkInfo.isConnected) {
      try {
        final placesIds = await placesRemoteDataSource.getPlacesIds();
        return Right(placesIds);
      } catch (e) {
        print(e);
        return Left(FirestoreFailure());
      }
    } else {
      final placesIds = await placesLocalDataSource.getPlacesIds();
      return Right(placesIds);
    }
  }
}
