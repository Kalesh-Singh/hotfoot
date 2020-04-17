import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

abstract class RunDetailsEvent extends Equatable {
  const RunDetailsEvent();

  @override
  List<Object> get props => [];
}

class RunDetailsRequested extends RunDetailsEvent {
  final String runId;

  const RunDetailsRequested({@required this.runId});
}
