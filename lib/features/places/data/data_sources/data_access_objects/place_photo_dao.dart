import 'dart:io';

import 'package:meta/meta.dart';
import 'package:path/path.dart';

import 'package:flutter_cache_manager/flutter_cache_manager.dart';

abstract class IPlacePhotoDao {
  /// Returns the inserted File
  Future<File> insertOrUpdate({
    @required String id,
    @required File photoFile,
  });

  //TODO: Move this into remote data source getPhoto
  // Than way the Dao only deals with the local data source.
  /// Downloads the photo and returns the File.
  Future<File> downloadPhoto({@required String url});

  /// Gets the photo from the local file system.
  /// Returns [null] if id is not found.
  Future<File> get({@required String id});

  Future<void> delete({@required String id});

  Future<void> deleteAll();
}

class PlacePhotoDao implements IPlacePhotoDao {
  static const String _PLACE_PHOTO_DIR = 'photos';
  final String photosDir;
  final DefaultCacheManager cacheManager;

  PlacePhotoDao({
    @required Directory photosDir,
    @required this.cacheManager,
  })  : assert(photosDir != null),
        assert(cacheManager != null),
        this.photosDir = join(photosDir.path, _PLACE_PHOTO_DIR);

  // TODO: Register application tempDir as the photoDir to be injected
  // TODO: Register default cache manager in service locator.

  @override
  Future<void> delete({String id}) async {
    final String photoPath = join(photosDir, id);
    final File photoFile = File(photoPath);
    return await photoFile.delete(recursive: false);
  }

  @override
  Future<void> deleteAll() async {
    final File photosDirFile = File(photosDir);
    return await photosDirFile.delete(recursive: true);
  }

  @override
  Future<File> get({String id}) async {
    final String photoPath = join(photosDir, id);
    final File photoFile = File(photoPath);

    if (await photoFile.exists()) {
      return photoFile;
    } else {
      return null;
    }
  }

  @override
  Future<File> insertOrUpdate({String id, File photoFile}) async {
    final String photoPath = join(photosDir, id);
    await photoFile.rename(photoPath);
    return await photoFile.create(recursive: true);
  }

  @override
  Future<File> downloadPhoto({String url}) async {
    final fileInfo = await cacheManager.downloadFile(url);
    return fileInfo.file;
  }
}
