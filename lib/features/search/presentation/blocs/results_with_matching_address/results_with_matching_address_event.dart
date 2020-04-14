import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';

abstract class ResultsWithMatchingAddressEvent extends Equatable {
  const ResultsWithMatchingAddressEvent();

  @override
  List<Object> get props => [];
}

class AddressEntered extends ResultsWithMatchingAddressEvent {
  final String placeAddress;

  const AddressEntered({@required this.placeAddress});
}

class ListEntryClicked extends ResultsWithMatchingAddressEvent {}
