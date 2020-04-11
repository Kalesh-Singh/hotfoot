import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

class SearchResultEntity extends Equatable {
  final String id;
  final String name;
  final String address;

  const SearchResultEntity({
    @required this.id,
    @required this.name,
    @required this.address,
  });

  @override
  List<Object> get props => [
        id,
        name,
        address,
      ];
}
