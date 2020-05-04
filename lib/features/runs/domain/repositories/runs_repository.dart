import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:hotfoot/core/error/failures.dart';
import 'package:hotfoot/features/runs/data/models/run_model.dart';
import 'package:hotfoot/features/runs/domain/entities/run_entity.dart';
import 'package:hotfoot/features/user/domain/entities/user_entity.dart';
import 'package:meta/meta.dart';

abstract class IRunsRepository {
  /// Initializes a Run object.
  Future<Either<Failure, RunEntity>> initRun();

  /// Returns all runs that the user placed.
  Future<Either<Failure, List<String>>> getRunsIds();

  /// Returns the updated or inserted run.
  Future<Either<Failure, RunEntity>> updateOrInsertRun(
      {@required RunModel runModel});

  /// Returns the run details for the given id.
  Future<Either<Failure, RunEntity>> getRunById({@required String id});

  /// Returns a stream that can be listened to for run updates.
  Future<Either<Failure, Stream<QuerySnapshot>>> getRunStream(
      {@required String runId});

  Future<Either<Failure, List<String>>> getRunsIdsWhereUserIsCustomer();

  Future<Either<Failure, List<String>>> getRunsIdsWhereUserIsRunner();

  Future<Either<Failure, List<String>>> getPendingRunsIds();

  /// Returns [Right(null)] if there is no active run.
  Future<Either<Failure, RunModel>> getActiveRun({@required UserType userType});
}
