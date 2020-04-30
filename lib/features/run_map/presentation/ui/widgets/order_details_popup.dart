import 'package:flutter/material.dart';

class OrderDetailsPopUp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Order Details'),
      content: Text('Order Details'),
      actions: <Widget>[
        FlatButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('Close')),
      ],
    );
  }
}
