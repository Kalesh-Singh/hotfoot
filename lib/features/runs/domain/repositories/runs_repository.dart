import 'package:dartz/dartz.dart';
import 'package:hotfoot/core/error/failures.dart';
import 'package:hotfoot/features/runs/domain/entities/run_entity.dart';
import 'package:meta/meta.dart';

abstract class IRunsRepository {
  /// Returns all runs that the user placed.
  Future<Either<Failure, List<String>>> getRuns({@required String userId});

  /// Returns the updated or inserted run.
  Future<Either<Failure, RunEntity>> updateOrInsertRun(
      {@required RunEntity run});

  /// Returns the run details for the given id.
  Future<Either<Failure, RunEntity>> getRunById({@required String id});
}
