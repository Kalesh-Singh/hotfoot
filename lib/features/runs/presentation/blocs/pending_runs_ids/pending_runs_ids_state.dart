import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

abstract class PendingRunsIdsState extends Equatable {
  const PendingRunsIdsState();

  @override
  List<Object> get props => [];
}

class PendingRunsIdsUninitialized extends PendingRunsIdsState {}

class PendingRunsIdsLoadSuccess extends PendingRunsIdsState {
  final List<String> pendingRunsIds;

  const PendingRunsIdsLoadSuccess({@required this.pendingRunsIds});

  @override
  List<Object> get props => [pendingRunsIds];
}

class PendingRunsIdsLoadFailure extends PendingRunsIdsState {
  final String message;

  const PendingRunsIdsLoadFailure({@required this.message});

  @override
  List<Object> get props => [message];
}
