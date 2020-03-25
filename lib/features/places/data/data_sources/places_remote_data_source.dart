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

  @override
  Future<PlaceModel> getPlaceById({String id}) async {
    final placeJson = (await _placesCollection.document(id).get()).data;
    return PlaceModel.fromJson(placeJson);
  }

  @override
  Future<List<String>> getPlacesIds() async {
    print('Getting place ids from firestore');
    final QuerySnapshot placesSnapshot = await _placesCollection.getDocuments();
    List<String> placesIds = List<String>();

    placesSnapshot.documents.forEach((document) {
      placesIds.add(document.documentID);
    });

    print('got place ids from firestore');
    print('Number of places ${placesIds.length}');

    return placesIds;
  }

  @override
  Future<File> getPhoto({String url}) async {
    final fileInfo = await cacheManager.downloadFile(url);
    return fileInfo.file;
  }
}
