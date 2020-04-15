import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hotfoot/core/use_cases/use_case.dart';
import 'package:hotfoot/features/run_placed/presentation/ui/widgets/chat_message_list_item.dart';
import 'package:hotfoot/features/runs/data/models/run_model.dart';
import 'package:hotfoot/features/runs/domain/entities/run_entity.dart';
import 'package:hotfoot/features/user/data/models/user_model.dart';
import 'package:hotfoot/features/user/domain/use_cases/get_user_id.dart';
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

    print(runModel);

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

  @override
  Future<List<String>> getRunsIdsWhereUserIsCustomer() async {
    final userEither = await (getUserId(NoParams()));
    List<String> _customerRunsIds = List<String>();
    await userEither.fold(
      (failure) {
        print('failed to getUser');
      },
      (userId) async {
        final Query _runsCollectionGroup = firestore.collectionGroup('run');
        final QuerySnapshot _customerRunsSnapshot = await _runsCollectionGroup
            .where('customerId', isEqualTo: userId)
            .getDocuments();
        _customerRunsSnapshot.documents.forEach(
          (document) {
            _customerRunsIds.add(document.documentID);
          },
        );
      },
    );

    print('Customer runs id');
    for (final id in _customerRunsIds) {
      print(id);
    }
    return _customerRunsIds;
  }

  @override
  Future<List<String>> getRunsIdsWhereUserIsRunner() {
    // TODO: implement getRunsIdsWhereUserIsRunner
    return null;
  }
}
