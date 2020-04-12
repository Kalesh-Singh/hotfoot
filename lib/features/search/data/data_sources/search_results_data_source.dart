import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hotfoot/features/search/data/models/search_result_model.dart';
import 'package:hotfoot/features/places/domain/entities/place_entity.dart';
import 'package:meta/meta.dart';

abstract class ISearchResultsDataSource {
  Future<List<PlaceEntity>> getResultsWithMatchingAddress(
      {@required String address});
}

class SearchResultsDataSource implements ISearchResultsDataSource {
  // _PUA is a Private Usage Area code that is after most regular characters in
  // Unicode. This is used as a suffix to the search text to upper bound the
  // search results since firestore only supports prefix querying.
  static const String _PUA = '\uf8ff';
  final Firestore firestore;

  final CollectionReference _placesCollection;

  SearchResultsDataSource({
    @required this.firestore,
  })  : assert(firestore != null),
        this._placesCollection = firestore.collection('places');

  @override
  Future<List<PlaceEntity>> getResultsWithMatchingAddress(
      {String address}) async {
    print('Getting results with matching address from firestore');
    List<PlaceEntity> results = List<PlaceEntity>();
    final QuerySnapshot placesSnapshot = await _placesCollection
        .where('address', isGreaterThanOrEqualTo: address)
        .where('address', isLessThanOrEqualTo: address + _PUA)
        .getDocuments();
    placesSnapshot.documents.forEach((document) {
      results.add(SearchResultModel.fromJson(document.data));
    });
    print('Got search results from firestore');
    print('Number of results ${results.length}');
    return results;
  }
}
