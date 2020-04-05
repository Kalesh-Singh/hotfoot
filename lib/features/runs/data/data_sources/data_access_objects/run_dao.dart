import 'package:hotfoot/features/runs/data/models/run_model.dart';
import 'package:meta/meta.dart';
import 'package:sembast/sembast.dart';

abstract class IRunDao {
  /// NOTE: Only runs for this user should be cached on the device.
  Future<void> insertOrUpdate({@required RunModel runModel});

  /// Returns [null] if key is not found.
  Future<RunModel> get({@required String id});

  Future<void> delete({@required String id});

  Future<List<RunModel>> getAll();

  /// Returns the number of records deleted
  Future<int> deleteAll();
}

class RunDao implements IRunDao {
  final Database database;

  static const String _RUN_STORE_NAME = 'runs';

  // A Store with String keys and Map<String, dynamic> values.
  final _runStore = stringMapStoreFactory.store(_RUN_STORE_NAME);

  RunDao({@required this.database});

  Future<void> _insert({@required RunModel runModel}) async {
    return await _runStore
        .record(runModel.id)
        .put(database, runModel.toJson());
  }

  Future<void> _update({@required RunModel runModel}) async {
    // For filtering by key (ID), RegEx, greater than, and many other criteria,
    // we use a Finder.
    final finder = Finder(filter: Filter.byKey(runModel.id));
    return await _runStore.update(
      database,
      runModel.toJson(),
      finder: finder,
    );
  }

  @override
  Future<void> delete({@required String id}) async {
    return await _runStore.record(id).delete(database);
  }

  @override
  Future<List<RunModel>> getAll() async {
    final recordSnapshots = await _runStore.find(database);

    // Making a List<RunModel> out of List<RecordSnapshot>
    return recordSnapshots
        .map((snapshot) => RunModel.fromJson(snapshot.value))
        .toList();
  }

  @override
  Future<int> deleteAll() async {
    return await _runStore.delete(database);
  }

  @override
  Future<RunModel> get({String id}) async {
    final finder = Finder(filter: Filter.byKey(id));
    final recordSnapshots = await _runStore.find(
      database,
      finder: finder,
    );

    if (recordSnapshots.length == 0) {
      return null;
    }

    final record = recordSnapshots[0];
    return RunModel.fromJson(record.value);
  }

  @override
  Future<void> insertOrUpdate({RunModel runModel}) async {
    final finder = Finder(filter: Filter.byKey(runModel.id));
    final key = await _runStore.findKey(
      database,
      finder: finder,
    );
    if (key != null) {
      await _update(runModel: runModel);
    } else {
      await _insert(runModel: runModel);
    }
  }
}
