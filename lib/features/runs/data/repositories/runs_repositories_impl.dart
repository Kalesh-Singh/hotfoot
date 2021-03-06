import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:hotfoot/core/error/failures.dart';
import 'package:hotfoot/core/network/network_info.dart';
import 'package:hotfoot/core/use_cases/use_case.dart';
import 'package:hotfoot/features/runs/data/data_sources/runs_local_data_source.dart';
import 'package:hotfoot/features/runs/data/data_sources/runs_remote_data_source.dart';
import 'package:hotfoot/features/runs/data/models/run_model.dart';
import 'package:hotfoot/features/runs/domain/entities/run_entity.dart';
import 'package:hotfoot/features/runs/domain/entities/run_status.dart';
import 'package:hotfoot/features/runs/domain/repositories/runs_repository.dart';
import 'package:hotfoot/features/user/domain/entities/user_entity.dart';
import 'package:hotfoot/features/user/domain/use_cases/get_user_id.dart';
import 'package:meta/meta.dart';

class RunsRepository implements IRunsRepository {
  final IRunsLocalDataSource runsLocalDataSource;
  final IRunsRemoteDataSource runsRemoteDataSource;
  final INetworkInfo networkInfo;
  final GetUserId getUserId;

  RunsRepository({
    @required this.runsLocalDataSource,
    @required this.runsRemoteDataSource,
    @required this.networkInfo,
    @required this.getUserId,
  })  : assert(runsLocalDataSource != null),
        assert(runsRemoteDataSource != null),
        assert(networkInfo != null),
        assert(getUserId != null);

  @override
  Future<Either<Failure, RunModel>> getRunById({@required String id}) async {
    // Always get run from the remote data source.
    // Since run status's are updated on both sides and
    // need to be displayed in real time.

    if (await networkInfo.isConnected) {
      try {
        print('getting run from remote data source');
        RunModel runModel = await runsRemoteDataSource.getRunById(id: id);
        print('got run from remote data source');
        await runsLocalDataSource.insertOrUpdateRun(runModel: runModel);
        print('cached runs details locally');
        return Right(runModel);
      } catch (e) {
        print('Exception $e');
        return Left(FirestoreFailure());
      }
    } else {
      print('getting run from local datastore');
      RunModel runModel = await runsLocalDataSource.getRunById(id: id);

      if (runModel != null) {
        print('got run from local data source');
        return Right(runModel);
      }

      return Left(DatabaseFailure());
    }
  }

  @override
  Future<Either<Failure, List<String>>> getRunsIds() async {
    // Always get from remote data source if possible, in order
    // to provide updated data.
    if (await networkInfo.isConnected) {
      try {
        print('getting runs ids from remote data source');
        final runsIds = await runsRemoteDataSource.getRunsIds();
        print('got runs ids from remote data source');
        print('Number of runs ${runsIds.length}');
        return Right(runsIds);
      } catch (e) {
        print('Exception $e');
        return Left(FirestoreFailure());
      }
    } else {
      print('getting runs ids from local datasource');
      final runsIds = await runsLocalDataSource.getRunsIds();
      print('Number of runs ${runsIds.length}');
      if (runsIds.length == 0) {
        return Left(DatabaseFailure());
      }
      print('got runs ids from local data source');
      return Right(runsIds);
    }
  }

  @override
  Future<Either<Failure, RunModel>> updateOrInsertRun(
      {RunModel runModel}) async {
    // The remote data source should always be updated first.
    // The local data source should never be updated directly
    // but rather only synced from the remote data source.
    // Hence this operation is only successful if there is a
    // network connection.
    if (await networkInfo.isConnected) {
      try {
        final updatedRunModel =
            await runsRemoteDataSource.insertOrUpdateRun(runModel: runModel);
        await runsLocalDataSource.insertOrUpdateRun(runModel: updatedRunModel);
        return Right(updatedRunModel);
      } catch (e) {
        print('Exception $e');
        return Left(FirestoreFailure());
      }
    } else {
      return Left(NetworkFailure());
    }
  }

  @override
  Future<Either<Failure, Stream<QuerySnapshot>>> getRunStream(
      {String runId}) async {
    if (await networkInfo.isConnected) {
      final stream = await runsRemoteDataSource.getRunStream(runId);
      return Right(stream);
    } else {
      return Left(NetworkFailure());
    }
  }

  @override
  Future<Either<Failure, RunEntity>> initRun() async {
    RunModel run = RunModel.empty();
    final uidEither = await getUserId(NoParams());
    uidEither.fold(
      (failure) {
        print('FAILED TO GET CUSTOMER ID');
      },
      (uid) {
        run = run.copyWith(
          customerId: uid,
          status: RunStatus.PENDING,
        );
      },
    );
    return Right(run);
  }

  @override
  Future<Either<Failure, List<String>>> getRunsIdsWhereUserIsCustomer() async {
    try {
      final customerRunsIds =
          await runsRemoteDataSource.getRunsIdsWhereUserIsCustomer();
      return Right(customerRunsIds);
    } on Exception catch (e) {
      print(e);
      return Left(FirestoreFailure());
    }
  }

  @override
  Future<Either<Failure, List<String>>> getRunsIdsWhereUserIsRunner() async {
    try {
      final runnerRunsIds =
          await runsRemoteDataSource.getRunsIdsWhereUserIsRunner();
      return Right(runnerRunsIds);
    } on Exception catch (e) {
      print(e);
      return Left(FirestoreFailure());
    }
  }

  @override
  Future<Either<Failure, List<String>>> getPendingRunsIds() async {
    try {
      final pendingRunsIds = await runsRemoteDataSource.getPendingRunsIds();
      return Right(pendingRunsIds);
    } on Exception catch (e) {
      print(e);
      return Left(FirestoreFailure());
    }
  }

  @override
  Future<Either<Failure, RunModel>> getActiveRun({UserType userType}) async {
    try {
      final RunModel activeRun =
          await runsRemoteDataSource.getActiveRun(userType: userType);
      return Right(activeRun);
    } on Exception catch (e) {
      print(e);
      return Left(FirestoreFailure());
    }
  }
}
