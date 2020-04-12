import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hotfoot/features/user/presentation/blocs/user_type/user_type_bloc.dart';
import 'package:hotfoot/features/user/presentation/blocs/user_type/user_type_event.dart';
import 'package:hotfoot/features/user/presentation/blocs/user_type/user_type_state.dart';

class UserTypeSwitch extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UserTypeBloc, UserTypeState>(
      builder: (BuildContext context, state) {
        final bool switchValue = state is RunnerUserType;
        print('SWITCH VALUE = $switchValue');
        print('STATE is ${state.runtimeType}');
        return Switch(
          onChanged: (_) {
            _toggleUserType(context);
          },
          value: switchValue,
          activeColor: Colors.blue,
          activeTrackColor: Colors.green,
          inactiveThumbColor: Colors.white,
          inactiveTrackColor: Colors.grey,
        );
      },
    );
  }

  void _toggleUserType(BuildContext context) {
    print('TOGGLED USER');
    final _userTypeBloc = BlocProvider.of<UserTypeBloc>(context);
    _userTypeBloc.add(UserTypeToggled());
  }
}
