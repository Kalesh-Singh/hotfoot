import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hotfoot/features/navigation_screen/presentation/bloc/navigation_screen_bloc.dart';
import 'package:hotfoot/features/navigation_screen/presentation/bloc/navigation_screen_state.dart';
import 'package:hotfoot/features/runs/data/models/run_model.dart';
import 'package:hotfoot/features/runs/presentation/ui/screens/accept_run_screen.dart';
import 'package:hotfoot/features/user/domain/entities/user_entity.dart';

class OrderDetailsPopUp extends StatelessWidget {
  final UserType userType;

  const OrderDetailsPopUp({Key key, @required this.userType}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NavigationScreenBloc, NavigationScreenState>(
        builder: (BuildContext context, NavigationScreenState state) {
      final bool isRunner = userType == UserType.RUNNER;
      return AlertDialog(
        title: Text(
          'Order Details',
          textAlign: TextAlign.center,
        ),
        content: _customerOrRunnerWidget(
            isRunner: isRunner, runModel: state.runModel),
        actions: <Widget>[
          FlatButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Close')),
        ],
      );
    });
  }

  Widget _customerOrRunnerWidget(
      {@required bool isRunner, @required RunModel runModel}) {
    final String cost = ((runModel.cost) ?? 0.0).toStringAsFixed(2);
    final String compensation =
        ((calculateRunnerFee(runModel.cost)) ?? 0.0).toStringAsFixed(2);

    if (isRunner) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Text('Compensation: \$$compensation'),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              Text('            Request: '),
              Expanded(
                child: Text(runModel.order),
              ),
            ],
          ),
        ],
      );
    } else {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Text('      Cost: \$$cost'),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              Text('Request: '),
              Expanded(
                child: Text(runModel.order),
              ),
            ],
          ),
        ],
      );
    }
  }
}
