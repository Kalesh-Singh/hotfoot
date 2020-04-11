import 'package:equatable/equatable.dart';
import 'package:hotfoot/features/places/domain/entities/place_entity.dart';
import 'package:meta/meta.dart';

abstract class ResultsWithMatchingAddressState extends Equatable {
  const ResultsWithMatchingAddressState();

  @override
  List<Object> get props => [];
}

class ResultsWithMatchingAddressEmpty extends ResultsWithMatchingAddressState {}

class ResultsWithMatchingAddressSearching
    extends ResultsWithMatchingAddressState {}

class ResultsWithMatchingAddressSearched
    extends ResultsWithMatchingAddressState {
  final List<PlaceEntity> resultsWithMatchingAddress;

  const ResultsWithMatchingAddressSearched(
      {@required this.resultsWithMatchingAddress});

  @override
  List<Object> get props => [resultsWithMatchingAddress];
}

class ResultsWithMatchingAddressFailure
    extends ResultsWithMatchingAddressState {
  final String message;

  const ResultsWithMatchingAddressFailure({@required this.message});

  @override
  List<Object> get props => [message];
}
