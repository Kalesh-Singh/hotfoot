import 'package:dartz/dartz.dart';
import 'package:hotfoot/core/error/failures.dart';
import 'package:hotfoot/core/use_cases/use_case.dart';
import 'package:hotfoot/features/runs/domain/entities/run_entity.dart';
import 'package:hotfoot/features/runs/domain/repositories/runs_repository.dart';
import 'package:meta/meta.dart';

class GetRunById implements UseCase<RunEntity, String> {
  final IRunsRepository runsRepository;

  const GetRunById({@required this.runsRepository});

  @override
  Future<Either<Failure, RunEntity>> call(String params) async {
    return await runsRepository.getRunById(id: params);
  }
}
