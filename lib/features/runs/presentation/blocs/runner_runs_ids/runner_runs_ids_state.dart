import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

abstract class RunnerRunsIdsState extends Equatable {
  const RunnerRunsIdsState();

  @override
  List<Object> get props => [];
}

class RunnerRunsIdsUninitialized extends RunnerRunsIdsState {}

class RunnerRunsIdsLoadSuccess extends RunnerRunsIdsState {
  final List<String> runnerRunsIds;

  const RunnerRunsIdsLoadSuccess({@required this.runnerRunsIds});

  @override
  List<Object> get props => [runnerRunsIds];
}

class RunnerRunsIdsLoadFailure extends RunnerRunsIdsState {
  final String message;

  const RunnerRunsIdsLoadFailure({@required this.message});

  @override
  List<Object> get props => [message];
}
