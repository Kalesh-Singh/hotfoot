import 'package:flutter/material.dart';
import 'package:hotfoot/features/user/domain/entities/user_entity.dart';

class UserDetailsPopUp extends StatelessWidget {
  final UserType userType;

  const UserDetailsPopUp({Key key, @required this.userType}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Runner/Customer Details'),
      content: Text('Runner/Customer Details'),
      actions: <Widget>[
        FlatButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('Close')),
      ],
    );
  }
}
