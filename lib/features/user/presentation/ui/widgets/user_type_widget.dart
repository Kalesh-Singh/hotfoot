import 'package:flutter/material.dart';
import 'package:hotfoot/features/user/presentation/ui/widgets/user_type_toggle_switch.dart';

class UserTypeWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Expanded(child: Text('Runner:')),
        UserTypeSwitch(),
      ],
    );
  }
}
