import 'dart:async';

import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sembast/sembast.dart';
import 'package:sembast/sembast_io.dart';

class AppDatabase {
  // Database name
  static const String _HOTFOOT_DB_NAME = 'hotfoot.db';

  // Singleton instance
  static final AppDatabase _singleton = AppDatabase._();

  // A private constructor allows us to create instances of AppDatabase
  // only from within the AppDatabase class itself.
  AppDatabase._();

  // Singleton accessor
  static AppDatabase get instance => _singleton;

  // Completer is used for transforming synchronous code
  // into asynchronous code.
  Completer<Database> _dbOpenCompleter;

  // Database object accessor
  Future<Database> get database async {
    // If completer is null, AppDatabase class is newly instantiated
    // so database is not yet open.
    if (_dbOpenCompleter == null) {
      _dbOpenCompleter = Completer();
      // Calling _openDatabase will also complete the completer
      // with database instance.
      _openDatabase();
    }
    // If the database is already opened, awaiting the future will happen instantly.
    // Otherwise, awaiting the returned future will take some time - until complete() is called
    // on the Completer in _openDatabase() below.
    return _dbOpenCompleter.future;
  }

  Future<void> _openDatabase() async {
    // Get a platform specific directory where persistent app data can be stored.
    final appDocumentDirectory = await getApplicationDocumentsDirectory();

    // Path with the form /platform-specific-directory/places.db
    final dbPath = join(appDocumentDirectory.path, _HOTFOOT_DB_NAME);

    final database = await databaseFactoryIo.openDatabase(dbPath);

    // Any code awaiting the Completer's future will now start executing
    _dbOpenCompleter.complete(database);
  }
}
