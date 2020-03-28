import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:hotfoot/core/error/failures.dart';
import 'package:hotfoot/core/use_cases/use_case.dart';
import 'package:hotfoot/features/places/domain/repositories/places_repository.dart';
import 'package:meta/meta.dart';

class GetPlacePhoto implements UseCase<File, GetPlacePhotoParams> {
  final IPlacesRepository placesRepository;

  const GetPlacePhoto({@required this.placesRepository});

  @override
  Future<Either<Failure, File>> call(GetPlacePhotoParams params) async {
    return await placesRepository.getPlacePhoto(
      id: params.id,
      url: params.url,
    );
  }
}

class GetPlacePhotoParams {
  final String id;
  final String url;

  const GetPlacePhotoParams({
    @required this.id,
    @required this.url,
  });
}
