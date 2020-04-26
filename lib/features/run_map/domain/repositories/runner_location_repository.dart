import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:hotfoot/core/error/failures.dart';
import 'package:hotfoot/features/location/domain/entities/location_entity.dart';
import 'package:meta/meta.dart';

abstract class IRunnerLocationRepository {
  Future<Either<Failure, void>> insertOrUpdateLocation({
    @required String runId,
    @required LocationEntity runnerLocation,
  });

  Future<Either<Failure, Stream<QuerySnapshot>>> getRunnerLocationStream(
      {@required String runId});
}
