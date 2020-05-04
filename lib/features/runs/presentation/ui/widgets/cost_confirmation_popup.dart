import 'package:flutter/material.dart';
import 'package:hotfoot/core/style/style.dart';

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
        style: style.copyWith(fontWeight: FontWeight.bold, fontSize: 20),
      ),
      content: Text(
          'The run will cost \$${cost.toStringAsFixed(2)}. Confirm?',
          style: style.copyWith(fontSize: 14),),
      actions: <Widget>[
        FlatButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: Text('Confirm',
            style: style.copyWith(fontSize:16, fontWeight: FontWeight.bold),
            )
          ),
        FlatButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text('Cancel',
            style: style.copyWith(fontSize:16, fontWeight: FontWeight.bold)
          )
        ),
      ],
    );
  }
}
