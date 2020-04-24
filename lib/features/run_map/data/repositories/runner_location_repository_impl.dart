import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:hotfoot/core/error/failures.dart';
import 'package:hotfoot/features/location/domain/entities/location_entity.dart';
import 'package:hotfoot/features/run_map/domain/repositories/runner_location_repository.dart';
import 'package:hotfoot/features/runs/data/models/run_model.dart';
import 'package:meta/meta.dart';

class RunnerLocationRepository implements IRunnerLocationRepository {
  final Firestore firestore;

  RunnerLocationRepository({@required this.firestore});

  @override
  Future<Either<Failure, void>> insertOrUpdateLocation(
      {String runId, LocationEntity runnerLocation}) async {
    try {
      final result = await firestore
          .collection('runs')
          .document(runId)
          .collection('run')
          .document(runId)
          .collection('runnerLocation')
          .document('location')
          .setData((runnerLocation as RunModel).toJson());
      return Right(result);
    } catch (e) {
      print(e);
      return Left(FirestoreFailure());
    }
  }
}
