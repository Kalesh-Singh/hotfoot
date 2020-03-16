import 'package:hotfoot/features/places/domain/entities/location_entity.dart';
import 'package:hotfoot/features/places/domain/entities/place_entity.dart';
import 'package:meta/meta.dart';

import 'location_model.dart';

class PlaceModel extends Place {
  final LocationModel locationModel;

  const PlaceModel({
    @required String name,
    @required String address,
    @required this.locationModel,
    @required String photoUrl,
  }) : super(
          name: name,
          address: address,
          location: locationModel,
          photoUrl: photoUrl,
        );

  factory PlaceModel.fromJson(Map json) => json != null
      ? PlaceModel(
          name: (json['name'] as String),
          address: (json['address'] as String),
          locationModel: LocationModel.fromJson(json['location']),
          photoUrl: (json['photoUrl'] as String),
        )
      : null;

  Map<String, dynamic> toJson() {
    Map map = Map<String, dynamic>();
    map['name'] = name;
    map['address'] = address;
    map['location'] = locationModel.toJson();
    map['photoUrl'] = photoUrl;
    return map;
  }
}
