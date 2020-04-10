import 'package:dartz/dartz.dart';
import 'package:hotfoot/core/error/failures.dart';
import 'package:hotfoot/core/use_cases/use_case.dart';
import 'package:hotfoot/features/runs/domain/entities/run_entity.dart';
import 'package:hotfoot/features/runs/domain/repositories/runs_repository.dart';
import 'package:meta/meta.dart';

class InitRun implements UseCase<RunEntity, NoParams> {
  final IRunsRepository runsRepository;

  const InitRun({@required this.runsRepository});

  @override
  Future<Either<Failure, RunEntity>> call(NoParams params) async {
    return await runsRepository.initRun();
  }
}
