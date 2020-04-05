import 'package:dartz/dartz.dart';
import 'package:hotfoot/core/error/failures.dart';
import 'package:hotfoot/core/use_cases/use_case.dart';
import 'package:hotfoot/features/runs/data/models/run_model.dart';
import 'package:hotfoot/features/runs/domain/entities/run_entity.dart';
import 'package:hotfoot/features/runs/domain/repositories/runs_repository.dart';
import 'package:meta/meta.dart';

class UpdateOrInsertRun implements UseCase<RunEntity, RunModel> {
  final IRunsRepository runsRepository;

  const UpdateOrInsertRun({@required this.runsRepository});

  @override
  Future<Either<Failure, RunEntity>> call(RunModel params) async {
    return await runsRepository.updateOrInsertRun(runModel: params);
  }
}
