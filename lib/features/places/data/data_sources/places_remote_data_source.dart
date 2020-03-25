import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:hotfoot/features/places/data/models/place_model.dart';
import 'package:meta/meta.dart';

abstract class IPlacesRemoteDataSource {
  Future<List<String>> getPlacesIds();

  Future<PlaceModel> getPlaceById({@required String id});

  Future<File> getPhoto({@required String url});
}

class PlacesRemoteDataSource implements IPlacesRemoteDataSource {
  final Firestore firestore;
  final DefaultCacheManager cacheManager;

  CollectionReference _placesCollection;

  PlacesRemoteDataSource({
    @required this.firestore,
    @required this.cacheManager,
  })  : assert(firestore != null),
        assert(cacheManager != null),
        this._placesCollection = firestore.collection('places');

  // TODO: Register default cache manager in service locator.

  @override
  Future<PlaceModel> getPlaceById({String id}) async {
    final placeJson = (await _placesCollection.document(id).get()).data;
    return PlaceModel.fromJson(placeJson);
  }

  @override
  Future<List<String>> getPlacesIds() async {
    final Stream<QuerySnapshot> placesStream = _placesCollection.snapshots();
    List<String> placesIds = List<String>();

    placesStream.listen((snapshot) {
      snapshot.documents.forEach((document) {
        placesIds.add(document.documentID);
      });
      print(placesIds);
    });

    return placesIds;
  }

  @override
  Future<File> getPhoto({String url}) async {
    final fileInfo = await cacheManager.downloadFile(url);
    return fileInfo.file;
  }
}
