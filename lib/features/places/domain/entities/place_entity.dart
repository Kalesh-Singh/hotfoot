import 'package:equatable/equatable.dart';
import 'package:hotfoot/features/places/domain/entities/location_entity.dart';
import 'package:meta/meta.dart';

class Place extends Equatable {
  final String name;
  final String address;
  final Location location;
  final String photoUrl;

  const Place({
    @required this.name,
    @required this.address,
    @required this.location,
    @required this.photoUrl,
  });

  @override
  String toString() => "$name, $location";

  @override
  List<Object> get props => [name, address, location, photoUrl];
}
