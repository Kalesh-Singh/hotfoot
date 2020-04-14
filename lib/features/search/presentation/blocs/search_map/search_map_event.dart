import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

abstract class SearchMapEvent extends Equatable {
  const SearchMapEvent();

  @override
  List<Object> get props => [];
}

class SearchItemSelected extends SearchMapEvent {
  final String placeId;

  const SearchItemSelected({@required this.placeId});
}
