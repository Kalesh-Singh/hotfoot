import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';

abstract class MatchingAddressesEvent extends Equatable {
  const MatchingAddressesEvent();

  @override
  List<Object> get props => [];
}

class AddressEntered extends MatchingAddressesEvent {
  final String placeAddress;

  const AddressEntered({@required this.placeAddress});
}
