import 'package:hotfoot/features/places/domain/entities/place_entity.dart';
import 'package:meta/meta.dart';

class SearchResultModel extends PlaceEntity {
  const SearchResultModel({
    @required String id,
    @required String name,
    @required String address,
  }) : super(
          id: id,
          name: name,
          address: address,
        );

  factory SearchResultModel.fromJson(Map json) => json != null
      ? SearchResultModel(
          id: (json['id'] as String),
          name: (json['name'] as String),
          address: (json['address'] as String),
        )
      : null;
}
