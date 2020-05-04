import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class OtherUserCancelledPopUp extends StatelessWidget {
  final bool isRunner;

  const OtherUserCancelledPopUp({Key key, @required this.isRunner}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        'Run cancelled by ${isRunner?'customer':'runner'}',
      ),
      content: Text('Please close the notification to return to home screen'),
      actions: <Widget>[
        FlatButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('Close')),
      ],
    );
  }
}
