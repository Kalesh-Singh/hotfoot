import 'package:equatable/equatable.dart';
import 'package:hotfoot/features/runs/data/models/run_model.dart';
import 'package:meta/meta.dart';

abstract class RunUpdateEvent extends Equatable {
  final RunModel runModel;

  const RunUpdateEvent({@required this.runModel});

  @override
  List<Object> get props => [runModel];
}

class RunUpdated extends RunUpdateEvent {
  const RunUpdated({@required RunModel runModel}) : super(runModel: runModel);
}
