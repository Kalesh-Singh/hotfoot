import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hotfoot/features/runs/data/models/run_model.dart';
import 'package:meta/meta.dart';

abstract class IRunsRemoteDataSource {
  Future<List<String>> getRunsIds({@required String userId});

  Future<RunModel> getRunById({@required String id});

  /// Returns the RunModel of the inserted or updated data.
  /// The returned model should now contain an id if it
  /// didn't have one before this call.
  Future<RunModel> insertOrUpdateRun({@required RunModel runModel});

  /// Returns a stream that can be listened to for run updates.
  Future<Stream<QuerySnapshot>> getRunStream(String runId);
}

class RunsRemoteDataSource implements IRunsRemoteDataSource {
  final Firestore firestore;
  final CollectionReference _runsCollection;

  RunsRemoteDataSource({
    @required this.firestore,
  })  : assert(firestore != null),
        this._runsCollection = firestore.collection('runs');

  @override
  Future<RunModel> getRunById({String id}) async {
    final CollectionReference _subCollection =
        _runsCollection.document(id).collection('run');
    final Map<String, dynamic> runJson = {};

    final QuerySnapshot runSnapshot = await _subCollection.getDocuments();
    runSnapshot.documents.forEach((document) {
      runJson[document.documentID] = document.data;
    });

    final runModel = RunModel.fromJson(runJson);

    print(runModel);

    return runModel;
  }

  @override
  Future<List<String>> getRunsIds({String userId}) async {
    // TODO: Get the ids from the user repo.
    print('Getting runs ids from firestore');
    final QuerySnapshot runsSnapshot = await _runsCollection
        .where('run.customerId', isEqualTo: userId)
        .getDocuments();
    List<String> runsIds = List<String>();

    runsSnapshot.documents.forEach((document) {
      runsIds.add(document.documentID);
    });

    print('got run ids from firestore');
    print('Number of runs ${runsIds.length}');

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

    // TODO: Add run id to user list if it is not present.

    return runModel;
  }

  Future<Stream<QuerySnapshot>> getRunStream(String runId) async {
    return _runsCollection.document(runId).collection('run').snapshots();
  }
}
