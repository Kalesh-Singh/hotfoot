import 'package:hotfoot/features/places/data/models/place_model.dart';
import 'package:meta/meta.dart';
import 'package:sembast/sembast.dart';

abstract class IPlaceDao {
  Future<void> insert({@required PlaceModel placeModel});

  Future<void> update({@required PlaceModel placeModel});

  Future<void> insertOrUpdate({@required PlaceModel placeModel});

  /// Returns [null] if key is not found.
  Future<PlaceModel> get({@required String id});

  Future<void> delete({@required String id});

  Future<List<PlaceModel>> getAll();

  /// Returns the number of records deleted
  Future<int> deleteAll();
}

class PlaceDao implements IPlaceDao {
  final Database database;

  static const String _PLACE_STORE_NAME = 'places';

  // A Store with String keys and Map<String, dynamic> values.
  // This Store acts like a persistent map, values of which are Fruit objects converted to Map
  final _placeStore = stringMapStoreFactory.store(_PLACE_STORE_NAME);

  PlaceDao({@required this.database});

  @override
  Future<void> insert({@required PlaceModel placeModel}) async {
    return await _placeStore
        .record(placeModel.id)
        .put(database, placeModel.toJson());
  }

  @override
  Future<void> update({@required PlaceModel placeModel}) async {
    // For filtering by key (ID), RegEx, greater than, and many other criteria,
    // we use a Finder.
    final finder = Finder(filter: Filter.byKey(placeModel.id));
    return await _placeStore.update(
      database,
      placeModel.toJson(),
      finder: finder,
    );
  }

  @override
  Future<void> delete({@required String id}) async {
    return await _placeStore.record(id).delete(database);
  }

  @override
  Future<List<PlaceModel>> getAll() async {
    final recordSnapshots = await _placeStore.find(database);

    // Making a List<PlaceModel> out of List<RecordSnapshot>
    return recordSnapshots
        .map((snapshot) => PlaceModel.fromJson(snapshot.value))
        .toList();
  }

  @override
  Future<int> deleteAll() async {
    return await _placeStore.delete(database);
  }

  @override
  Future<PlaceModel> get({String id}) async {
    final finder = Finder(filter: Filter.byKey(id));
    final recordSnapshots = await _placeStore.find(
      database,
      finder: finder,
    );

    if (recordSnapshots.length == 0) {
      return null;
    }

    final record = recordSnapshots[0];
    return PlaceModel.fromJson(record.value);
  }

  @override
  Future<void> insertOrUpdate({PlaceModel placeModel}) async {
    final finder = Finder(filter: Filter.byKey(placeModel.id));
    final key = await _placeStore.findKey(
      database,
      finder: finder,
    );
    if (key != null) {
      await update(placeModel: placeModel);
    } else {
      await insert(placeModel: placeModel);
    }
  }
}
