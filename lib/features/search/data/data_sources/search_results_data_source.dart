import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:meta/meta.dart';

abstract class ISearchResultsDataSource {
  Future<List<String>> getMatchingAddresses({@required String address});
}

class SearchResultsDataSource implements ISearchResultsDataSource {
  final Firestore firestore;

  final CollectionReference _placesCollection;

  SearchResultsDataSource({
    @required this.firestore,
  })  : assert(firestore != null),
        this._placesCollection = firestore.collection('places');

  @override
  Future<List<String>> getMatchingAddresses({String address}) async {
    print('Getting matching addresses from firestore');
    List<String> placeAddresses = List<String>();
    final QuerySnapshot placesSnapshot = await _placesCollection
        .where('address', isGreaterThanOrEqualTo: address)
        .getDocuments();
    placesSnapshot.documents.forEach((document) {
      placeAddresses.add(document.data['address']);
    });
    print('Got search results from firestore');
    print('Number of results ${placeAddresses.length}');
    return placeAddresses;
  }
}
