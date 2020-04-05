import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:hotfoot/core/error/failures.dart';
import 'package:hotfoot/core/use_cases/use_case.dart';
import 'package:hotfoot/features/runs/domain/repositories/runs_repository.dart';
import 'package:meta/meta.dart';

class GetRunStream implements UseCase<Stream<QuerySnapshot>, String> {
  final IRunsRepository runsRepository;

  const GetRunStream({@required this.runsRepository});

  @override
  Future<Either<Failure, Stream<QuerySnapshot>>> call(String params) async {
    return await runsRepository.getRunStream(runId: params);
  }
}
