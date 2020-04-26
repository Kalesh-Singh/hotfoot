import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:hotfoot/core/error/failures.dart';
import 'package:hotfoot/features/location/data/models/location_model.dart';
import 'package:hotfoot/features/location/domain/entities/location_entity.dart';
import 'package:hotfoot/features/run_map/domain/repositories/runner_location_repository.dart';
import 'package:meta/meta.dart';

class RunnerLocationRepository implements IRunnerLocationRepository {
  final Firestore firestore;

  RunnerLocationRepository({@required this.firestore});

  @override
  Future<Either<Failure, void>> insertOrUpdateLocation(
      {String runId, LocationEntity runnerLocation}) async {
    try {
      final runnerLocationCollection =
          _getRunnerLocationCollection(runId: runId);
      final result = await runnerLocationCollection
          .document('location')
          .setData((runnerLocation as LocationModel).toJson());
      return Right(result);
    } catch (e) {
      print(e);
      return Left(FirestoreFailure());
    }
  }

  @override
  Future<Either<Failure, Stream<QuerySnapshot>>> getRunnerLocationStream(
      {String runId}) async {
    try {
      final CollectionReference runnerLocationCollection =
          _getRunnerLocationCollection(runId: runId);
      final Stream<QuerySnapshot> runnerLocationStream =
          runnerLocationCollection.snapshots();
      return Right(runnerLocationStream);
    } catch (e) {
      print(e);
      return Left(FirestoreFailure());
    }
  }

  CollectionReference _getRunnerLocationCollection({@required String runId}) {
    return firestore
        .collection('runs')
        .document(runId)
        .collection('run')
        .document(runId)
        .collection('runnerLocation');
  }
}
