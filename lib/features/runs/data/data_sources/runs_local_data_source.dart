import 'package:hotfoot/features/runs/data/data_sources/data_access_objects/run_dao.dart';
import 'package:hotfoot/features/runs/data/models/run_model.dart';
import 'package:meta/meta.dart';

abstract class IRunsLocalDataSource {
  Future<List<String>> getRunsIds();

  /// Returns null if key is not found
  Future<RunModel> getRunById({@required String id});

  /// Returns the RunModel of the inserted or updated data.
  Future<RunModel> insertOrUpdateRun({@required RunModel runModel});
}

class PlacesLocalDataSource implements IRunsLocalDataSource {
  final IRunDao runDao;

  const PlacesLocalDataSource({
    @required this.runDao,
  }) : assert(runDao != null);

  @override
  Future<RunModel> getRunById({String id}) async {
    return await runDao.get(id: id);
  }

  @override
  Future<List<String>> getRunsIds() async {
    print('Getting run ids from sembast');
    List<RunModel> runs = await runDao.getAll();
    print('Got run ids from sembast');
    print('Number of runs ${runs.length}');
    return runs.map((run) => run.id).toList();
  }

  @override
  Future<RunModel> insertOrUpdateRun({RunModel runModel}) async {
    await runDao.insertOrUpdate(runModel: runModel);
    return runModel;
  }
}
