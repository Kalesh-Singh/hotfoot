import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hotfoot/core/use_cases/use_case.dart';
import 'package:hotfoot/features/runs/data/models/run_model.dart';
import 'package:hotfoot/features/runs/domain/entities/run_status.dart';
import 'package:hotfoot/features/user/domain/entities/user_entity.dart';
import 'package:hotfoot/features/user/domain/use_cases/get_user_id.dart';
import 'package:hotfoot/features/user/presentation/blocs/user_type/user_type_state.dart';
import 'package:meta/meta.dart';

abstract class IRunsRemoteDataSource {
  Future<List<String>> getRunsIds();

  Future<RunModel> getRunById({@required String id});

  /// Returns the RunModel of the inserted or updated data.
  /// The returned model should now contain an id if it
  /// didn't have one before this call.
  Future<RunModel> insertOrUpdateRun({@required RunModel runModel});

  /// Returns a stream that can be listened to for run updates.
  Future<Stream<QuerySnapshot>> getRunStream(String runId);

  Future<List<String>> getRunsIdsWhereUserIsCustomer();

  Future<List<String>> getRunsIdsWhereUserIsRunner();

  Future<List<String>> getPendingRunsIds();

  Future<RunModel> getActiveRun({@required UserType userType});
}

class RunsRemoteDataSource implements IRunsRemoteDataSource {
  final Firestore firestore;
  final CollectionReference _runsCollection;
  final GetUserId getUserId;

  RunsRemoteDataSource({
    @required this.firestore,
    @required this.getUserId,
  })  : assert(firestore != null),
        assert(getUserId != null),
        this._runsCollection = firestore.collection('runs');

  @override
  Future<RunModel> getRunById({String id}) async {
    final CollectionReference _subCollection =
        _runsCollection.document(id).collection('run');

    final DocumentSnapshot runSnapshot =
        await _subCollection.document(id).get();

    final runModel = RunModel.fromJson(runSnapshot.data);
    print(json.encode(runModel.toJson()));
    return runModel;
  }

  @override
  Future<List<String>> getRunsIds() async {
    final userEither = await (getUserId(NoParams()));
    List<String> runsIds = List<String>();
    await userEither.fold(
      (failure) {
        print('failed to getUser');
      },
      (userId) async {
        final QuerySnapshot runsSnapshot = await firestore
            .collection('users')
            .document(userId)
            .collection('runs')
            .getDocuments();

        runsSnapshot.documents.forEach((document) {
          runsIds.add(document.documentID);
        });
      },
    );

    print('runs id');
    for (final id in runsIds) {
      print(id);
    }
    return runsIds;
  }

  @override
  Future<RunModel> insertOrUpdateRun({RunModel runModel}) async {
    // NOTE: A more generic way to check for existence
    // final placeJson = (await _placesCollection.document(id).get()).data;
    // DocumentSnapshot documentSnapshot = (await _runsCollection.document(
    // runModel.id).get());
    // if (documentSnapshot.exists) {
    // However, I prefer the following null check since it, avoids a
    // network request.
    String runId;
    if (runModel.id == null) {
      runId = _runsCollection.document().documentID;
      runModel = runModel.copyWith(id: runId);
    } else {
      runId = runModel.id;
    }

    _runsCollection
        .document(runId)
        .collection('run')
        .document(runId)
        .setData(runModel.toJson());

    // Add run id to user list if it is not present.
    final userEither = await (getUserId(NoParams()));
    userEither.fold(
      (failure) {
        print('failed to getUser');
      },
      (userId) async {
        firestore
            .collection('users')
            .document(userId)
            .collection('runs')
            .document(runId)
            .setData({'runId': runId});
      },
    );

    return runModel;
  }

  Future<Stream<QuerySnapshot>> getRunStream(String runId) async {
    return _runsCollection.document(runId).collection('run').snapshots();
  }

  Future<List<String>> _getRunsIdsWhereUserIs(
      {@required String userTypeId}) async {
    final userEither = await getUserId(NoParams());
    print('Got user either');
    List<String> _runsIds = List<String>();
    await userEither.fold(
      (failure) {
        print('failed to getUser');
      },
      (userId) async {
        print('Got user id');
        final Query _runsCollectionGroup = firestore.collectionGroup('run');
        print('Created Collection group');
        try {
          final QuerySnapshot _runsSnapshot = await _runsCollectionGroup
              .where(userTypeId, isEqualTo: userId)
              .orderBy('timePlaced', descending: true)
              .orderBy('timeDelivered', descending: true)
              .getDocuments();
          print('Got collection group');
          _runsSnapshot.documents.forEach(
            (document) {
              _runsIds.add(document.documentID);
            },
          );
        } on Exception catch (e) {
          throw e;
        }
      },
    );

    print('$userTypeId runs id');
    for (final id in _runsIds) {
      print(id);
    }
    return _runsIds;
  }

  @override
  Future<List<String>> getRunsIdsWhereUserIsCustomer() async {
    return await _getRunsIdsWhereUserIs(userTypeId: 'customerId');
  }

  @override
  Future<List<String>> getRunsIdsWhereUserIsRunner() async {
    return await _getRunsIdsWhereUserIs(userTypeId: 'runnerId');
  }

  @override
  Future<List<String>> getPendingRunsIds() async {
    // NOTE: A runner should not be able to have a pending order
    // and be a runner at the same time.

    List<String> _runsIds = List<String>();
    final Query _runsCollectionGroup = firestore.collectionGroup('run');
    print('Created Collection group');
    final QuerySnapshot _runsSnapshot = await _runsCollectionGroup
        .where('status', isEqualTo: RunStatus.PENDING)
        .getDocuments();
    print('Got collection group');
    _runsSnapshot.documents.forEach(
      (document) {
        _runsIds.add(document.documentID);
      },
    );

    print('Pending runs id');
    for (final id in _runsIds) {
      print(id);
    }

    return _runsIds;
  }

  Future<List<String>> _getRunsIds({
    @required String userIdField,
    @required String userId,
    @required String runStatus,
  }) async {
    List<String> _runsIds = List<String>();
    final Query _runsCollectionGroup = firestore.collectionGroup('run');
    print('Created Collection group');
    try {
      final QuerySnapshot _runsSnapshot = await _runsCollectionGroup
          .where(userIdField, isEqualTo: userId)
          .where('status', isEqualTo: runStatus)
          .getDocuments();
      print('Got collection group');
      _runsSnapshot.documents.forEach(
        (document) {
          _runsIds.add(document.documentID);
        },
      );
    } on Exception catch (e) {
      throw e;
    }
    print('Runs Ids');
    for (final id in _runsIds) {
      print(id);
    }
    return _runsIds;
  }

  Future<List<String>> _getActiveRunsIds({@required UserType userType}) async {
    final String userIdField =
        (userType == UserType.RUNNER) ? 'runnerId' : 'customerId';
    final userEither = await getUserId(NoParams());
    print('Got user either');
    List<String> _runsIds;
    await userEither.fold(
      (failure) async {
        print('failed to getUser');
      },
      (userId) async {
        try {
          final pendingRunsIds = await _getRunsIds(
            userIdField: userIdField,
            userId: userId,
            runStatus: RunStatus.PENDING,
          );
          final acceptedRunsIds = await _getRunsIds(
            userIdField: userIdField,
            userId: userId,
            runStatus: RunStatus.ACCEPTED,
          );
          final customerConfirmedRuns = await _getRunsIds(
            userIdField: userIdField,
            userId: userId,
            runStatus: RunStatus.CUSTOMER_CONFIRMATION,
          );
          _runsIds = pendingRunsIds + acceptedRunsIds + customerConfirmedRuns;
        } catch (e) {
          print(e);
          throw e;
        }
      },
    );
    return _runsIds;
  }

  @override
  Future<RunModel> getActiveRun({UserType userType}) async {
    final List<String> activeRunsIds =
        await _getActiveRunsIds(userType: userType);
    // NOTE: There should only be one active run at any given time.
    if (activeRunsIds.length > 1) {
      throw Exception(
          'Inconsistent State: Multiple active runs for the same user');
    } else if (activeRunsIds.length == 1) {
      return await getRunById(id: activeRunsIds[0]);
    }
    return null;
  }
}
