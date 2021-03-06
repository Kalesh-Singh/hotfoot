import 'package:equatable/equatable.dart';
import 'package:hotfoot/features/runs/data/models/run_model.dart';
import 'package:meta/meta.dart';

abstract class NavigationScreenEvent extends Equatable {
  final RunModel runModel;

  const NavigationScreenEvent({@required this.runModel});

  @override
  List<Object> get props => [this.runModel];
}

class EnteredPurchaseFlow extends NavigationScreenEvent {
  const EnteredPurchaseFlow({@required RunModel runModel})
      : super(runModel: runModel);
}

class EnteredRunPlaced extends NavigationScreenEvent {
  final bool isRunner;

  const EnteredRunPlaced({@required RunModel runModel, @required this.isRunner})
      : super(runModel: runModel);
}

class EnteredLogin extends NavigationScreenEvent {}

class EnteredSettings extends NavigationScreenEvent {}

class EnteredHome extends NavigationScreenEvent {}

class EnteredAcceptRun extends NavigationScreenEvent {
  const EnteredAcceptRun({@required RunModel runModel})
      : super(runModel: runModel);
}
