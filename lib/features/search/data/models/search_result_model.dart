import 'package:hotfoot/features/search/domain/entities/search_result_entity.dart';
import 'package:meta/meta.dart';

class SearchResultModel extends SearchResultEntity {
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
