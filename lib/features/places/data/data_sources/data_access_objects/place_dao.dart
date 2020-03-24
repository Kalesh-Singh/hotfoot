import 'package:hotfoot/features/places/data/models/place_model.dart';
import 'package:meta/meta.dart';
import 'package:sembast/sembast.dart';

abstract class IPlaceDao {
  Future<void> insert({@required PlaceModel placeModel});

  Future<void> update({@required PlaceModel placeModel});

  Future<void> insertOrUpdate({@required PlaceModel placeModel});

  Future<PlaceModel> get({@required String id});

  Future<void> delete({@required String id});

  Future<List<PlaceModel>> getAll();

  /// Returns the number of records deleted
  Future<int> deleteAll();
}

class PlaceDao implements IPlaceDao {
  final Database db;

  static const String _PLACE_STORE_NAME = 'places';

  // A Store with String keys and Map<String, dynamic> values.
  // This Store acts like a persistent map, values of which are Fruit objects converted to Map
  final _placeStore = stringMapStoreFactory.store(_PLACE_STORE_NAME);

  PlaceDao({@required this.db});

  // Private getter to shorten the amount of code needed to get the
  // singleton instance of an opened database.
  // TODO: Register this in the Service Locator
  //Future<Database> get _db async => await AppDatabase.instance.database;

  @override
  Future<void> insert({@required PlaceModel placeModel}) async {
    return await _placeStore.record(placeModel.id).put(db, placeModel.toJson());
  }

  @override
  Future<void> update({@required PlaceModel placeModel}) async {
    // For filtering by key (ID), RegEx, greater than, and many other criteria,
    // we use a Finder.
    final finder = Finder(filter: Filter.byKey(placeModel.id));
    return await _placeStore.update(
      db,
      placeModel.toJson(),
      finder: finder,
    );
  }

  @override
  Future<void> delete({@required String id}) async {
    return await _placeStore.record(id).delete(db);
  }

  @override
  Future<List<PlaceModel>> getAll() async {
    final recordSnapshots = await _placeStore.find(db);

    // Making a List<PlaceModel> out of List<RecordSnapshot>
    return recordSnapshots
        .map((snapshot) => PlaceModel.fromJson(snapshot.value))
        .toList();
  }

  @override
  Future<int> deleteAll() async {
    return await _placeStore.delete(db);
  }

  @override
  Future<PlaceModel> get({String id}) async {
    final record = await _placeStore.record(id).get(db);
    return PlaceModel.fromJson(record);
  }

  @override
  Future<void> insertOrUpdate({PlaceModel placeModel}) async {
    final finder = Finder(filter: Filter.byKey(placeModel.id));
    final key = await _placeStore.findKey(
      db,
      finder: finder,
    );
    if (key != null) {
      await update(placeModel: placeModel);
    } else {
      await insert(placeModel: placeModel);
    }
  }
}
