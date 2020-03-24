import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:hotfoot/core/error/failures.dart';
import 'package:hotfoot/features/places/data/models/place_model.dart';
import 'package:meta/meta.dart';

abstract class IPlacesRepository {
  Future<Either<Failure, List<String>>> getPlacesIds();

  Future<Either<Failure, PlaceModel>> getPlaceById({@required String id});

  Future<Either<Failure, File>> getPlacePhotoById({@required String id});
}
