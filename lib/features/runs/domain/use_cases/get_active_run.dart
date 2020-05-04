import 'package:dartz/dartz.dart';
import 'package:hotfoot/core/error/failures.dart';
import 'package:hotfoot/core/use_cases/use_case.dart';
import 'package:hotfoot/features/runs/data/models/run_model.dart';
import 'package:hotfoot/features/runs/domain/repositories/runs_repository.dart';
import 'package:hotfoot/features/user/domain/entities/user_entity.dart';
import 'package:meta/meta.dart';

class GetActiveRun implements UseCase<RunModel, UserType> {
  final IRunsRepository runsRepository;

  const GetActiveRun({@required this.runsRepository});

  @override
  Future<Either<Failure, RunModel>> call(UserType params) async {
    return await runsRepository.getActiveRun(userType: params);
  }
}
