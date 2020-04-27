import 'package:dartz/dartz.dart';
import 'package:hotfoot/core/error/failures.dart';
import 'package:hotfoot/core/use_cases/use_case.dart';
import 'package:hotfoot/features/location/domain/entities/location_entity.dart';
import 'package:hotfoot/features/run_map/domain/repositories/runner_location_repository.dart';
import 'package:meta/meta.dart';

class InsertOrUpdateRunnerLocation
    implements UseCase<void, RunnerLocationParams> {
  final IRunnerLocationRepository runnerLocationRepository;

  const InsertOrUpdateRunnerLocation({@required this.runnerLocationRepository});

  @override
  Future<Either<Failure, void>> call(RunnerLocationParams params) async {
    return await runnerLocationRepository.insertOrUpdateLocation(
      runId: params.runId,
      runnerLocation: params.runnerLocation,
    );
  }
}

class RunnerLocationParams {
  final String runId;
  final LocationEntity runnerLocation;

  const RunnerLocationParams({
    @required this.runId,
    @required this.runnerLocation,
  });
}
