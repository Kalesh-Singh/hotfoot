import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

abstract class SearchMapEvent extends Equatable {
  const SearchMapEvent();

  @override
  List<Object> get props => [];
}

class SearchItemSelectedForMap extends SearchMapEvent {
  final String placeId;

  const SearchItemSelectedForMap({@required this.placeId});
}
