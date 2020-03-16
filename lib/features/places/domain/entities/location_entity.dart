import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

class Location extends Equatable {
  final double lat;
  final double lng;

  const Location({
    @required this.lat,
    @required this.lng,
  });

  @override
  String toString() => "$lat,$lng";

  @override
  List<Object> get props => [lat, lng];
}
