import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hotfoot/features/places/data/repositories/places_repositories_impl.dart';
import 'package:meta/meta.dart';
import 'package:mockito/mockito.dart';

void main() {
  Firestore firestore;
  PlacesRepository repository;
  setUp(() {
    firestore = Firestore.instance;
    repository = PlacesRepository(firestore: firestore);
  });
  
  test('trial', () async {
    // act
    repository.getPlacesIds();
  });
}
