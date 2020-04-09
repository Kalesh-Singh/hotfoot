import 'package:equatable/equatable.dart';
import 'package:hotfoot/features/runs/data/models/run_model.dart';
import 'package:meta/meta.dart';

abstract class NavigationScreenState extends Equatable {
  final RunModel runModel;

  const NavigationScreenState({@required this.runModel});

  @override
  List<Object> get props => [this.runModel];
}

class RunDetails extends NavigationScreenState {
  const RunDetails({@required RunModel runModel}) : super(runModel: runModel);
}

class RunPlaced extends NavigationScreenState {}

class Login extends NavigationScreenState {}

class Home extends NavigationScreenState {
  const Home({@required RunModel runModel}) : super(runModel: runModel);
}

class Settings extends NavigationScreenState {}
