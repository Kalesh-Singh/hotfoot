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
    final runJson = (await _runsCollection.document(id).get()).data;
    return RunModel.fromJson(runJson);
  }

  @override
  Future<List<String>> getRunsIds({String userId}) async {
    print('Getting runs ids from firestore');
    final QuerySnapshot runsSnapshot = await _runsCollection
        .where('customerId', isEqualTo: userId)
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
    _runsCollection.document(runId).setData(runModel.toJson());
    return runModel;
  }
}
