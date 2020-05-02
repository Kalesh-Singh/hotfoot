import 'package:flutter/material.dart';

class CostConfirmationPopUp extends StatelessWidget {
  final double cost;

  CostConfirmationPopUp({
    @required this.cost,
  }) : assert(cost != null);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        'Run Confirmation',
        textAlign: TextAlign.center,
      ),
      content: Text(
          'The run will cost \$${cost.toStringAsFixed(2)}. Confirm?'),
      actions: <Widget>[
        FlatButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: Text('Confirm')),
        FlatButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text('Cancel')),
      ],
    );
  }
}
