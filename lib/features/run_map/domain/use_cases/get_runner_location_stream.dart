import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:hotfoot/core/error/failures.dart';
import 'package:hotfoot/core/use_cases/use_case.dart';
import 'package:hotfoot/features/run_map/domain/repositories/runner_location_repository.dart';
import 'package:meta/meta.dart';

class GetRunnerLocationStream
    implements UseCase<Stream<QuerySnapshot>, String> {
  final IRunnerLocationRepository runnerLocationRepository;

  const GetRunnerLocationStream({@required this.runnerLocationRepository});

  @override
  Future<Either<Failure, Stream<QuerySnapshot>>> call(String params) async {
    return await runnerLocationRepository.getRunnerLocationStream(
        runId: params);
  }
}
