import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hotfoot/features/navigation_screen/presentation/bloc/navigation_screen_bloc.dart';
import 'package:hotfoot/features/navigation_screen/presentation/bloc/navigation_screen_state.dart';

class OrderDetailsPopUp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NavigationScreenBloc, NavigationScreenState>(
        builder: (BuildContext context, NavigationScreenState state) {
      final String cost = ((state.runModel.cost) ?? 0.0).toStringAsFixed(2);
      return AlertDialog(
        title: Text(
          'Order Details',
          textAlign: TextAlign.center,
        ),
        content: Column(
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
                  child: Text(state.runModel.order),
                ),
              ],
            ),
          ],
        ),
        actions: <Widget>[
          FlatButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Close')),
        ],
      );
    });
  }
}
