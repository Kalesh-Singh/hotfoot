import 'package:hotfoot/features/places/domain/entities/location_entity.dart';
import 'package:meta/meta.dart';

class LocationModel extends Location {
  final double lat;
  final double lng;

  const LocationModel({
    @required this.lat,
    @required this.lng,
  }) : super(lat: lat, lng: lng);

  factory LocationModel.fromJson(Map json) => json != null
      ? LocationModel(
          lat: (json['lat'] as num).toDouble(),
          lng: (json['lng'] as num).toDouble(),
        )
      : null;

  Map<String, dynamic> toJson() {
    Map map = Map<String, dynamic>();
    map['lat'] = lat;
    map['lng'] = lng;
    return map;
  }
}
