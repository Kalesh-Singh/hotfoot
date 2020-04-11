import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

abstract class MatchingAddressesState extends Equatable {
  const MatchingAddressesState();

  @override
  List<Object> get props => [];
}

class MatchingAddressesEmpty extends MatchingAddressesState {}

class MatchingAddressesSearching extends MatchingAddressesState {}

class MatchingAddressesSearched extends MatchingAddressesState {
  final List<String> matchingAddresses;

  const MatchingAddressesSearched({@required this.matchingAddresses});

  @override
  List<Object> get props => [matchingAddresses];
}

class MatchingAddressesFailure extends MatchingAddressesState {
  final String message;

  const MatchingAddressesFailure({@required this.message});

  @override
  List<Object> get props => [message];
}
