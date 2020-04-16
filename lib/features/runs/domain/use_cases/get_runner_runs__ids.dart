import 'package:dartz/dartz.dart';
import 'package:hotfoot/core/error/failures.dart';
import 'package:hotfoot/core/use_cases/use_case.dart';
import 'package:hotfoot/features/runs/domain/repositories/runs_repository.dart';
import 'package:meta/meta.dart';

class GetRunnerRunsIds implements UseCase<List<String>, NoParams> {
  final IRunsRepository runsRepository;

  const GetRunnerRunsIds({@required this.runsRepository});

  @override
  Future<Either<Failure, List<String>>> call(NoParams params) async {
    return await runsRepository.getRunsIdsWhereUserIsRunner();
  }
}
