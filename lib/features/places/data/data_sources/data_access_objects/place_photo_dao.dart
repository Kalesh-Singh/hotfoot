import 'dart:io';

import 'package:meta/meta.dart';
import 'package:path/path.dart';

abstract class IPlacePhotoDao {
  /// Returns the inserted File
  Future<File> insertOrUpdate({
    @required String id,
    @required File photoFile,
  });

  /// Gets the photo from the local file system.
  /// Returns [null] if id is not found.
  Future<File> get({@required String id});

  Future<void> delete({@required String id});

  Future<void> deleteAll();
}

class PlacePhotoDao implements IPlacePhotoDao {
  static const String _PLACE_PHOTO_DIR = 'photos';
  final String _photosDir;

  PlacePhotoDao({
    @required Directory photosDir,
  })  : assert(photosDir != null),
        this._photosDir = join(photosDir.path, _PLACE_PHOTO_DIR);

  // TODO: Register application tempDir as the photoDir to be injected

  @override
  Future<void> delete({String id}) async {
    final String photoPath = join(_photosDir, id);
    final File photoFile = File(photoPath);
    return await photoFile.delete(recursive: false);
  }

  @override
  Future<void> deleteAll() async {
    final File photosDirFile = File(_photosDir);
    return await photosDirFile.delete(recursive: true);
  }

  @override
  Future<File> get({String id}) async {
    final String photoPath = _getPhotoPath(id: id);
    final File photoFile = File(photoPath);

    if (await photoFile.exists()) {
      return photoFile;
    } else {
      return null;
    }
  }

  @override
  Future<File> insertOrUpdate({String id, File photoFile}) async {
    final String photoPath = _getPhotoPath(id: id);
    return await photoFile.rename(photoPath);
  }

  String _getPhotoPath({@required id}) {
    return '$_photosDir/$id.png';
  }
}
