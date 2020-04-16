import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

abstract class CustomerRunsIdsState extends Equatable {
  const CustomerRunsIdsState();

  @override
  List<Object> get props => [];
}

class CustomerRunsIdsUninitialized extends CustomerRunsIdsState {}

class CustomerRunsIdsLoadSuccess extends CustomerRunsIdsState {
  final List<String> customerRunsIds;

  const CustomerRunsIdsLoadSuccess({@required this.customerRunsIds});

  @override
  List<Object> get props => [customerRunsIds];
}

class CustomerRunsIdsLoadFailure extends CustomerRunsIdsState {
  final String message;

  const CustomerRunsIdsLoadFailure({@required this.message});

  @override
  List<Object> get props => [message];
}
