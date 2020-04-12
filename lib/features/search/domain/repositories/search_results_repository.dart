import 'package:dartz/dartz.dart';
import 'package:hotfoot/core/error/failures.dart';
import 'package:hotfoot/features/places/domain/entities/place_entity.dart';
import 'package:meta/meta.dart';

abstract class ISearchResultsRepository {
  Future<Either<Failure, List<PlaceEntity>>>
      getResultsWithMatchingAddress({@required String address});
}
