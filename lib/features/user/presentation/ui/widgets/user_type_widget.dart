import 'package:flutter/material.dart';
import 'package:hotfoot/features/user/presentation/ui/widgets/user_type_toggle_switch.dart';
import 'package:hotfoot/core/style/style.dart';

class UserTypeWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Expanded(child: Text('Runner:', style: style.copyWith(fontSize: 16),)),
        UserTypeSwitch(),
      ],
    );
  }
}
