import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:hotfoot/features/run_map/presentation/blocs/other_user_details/other_user_details_bloc.dart';
import 'package:hotfoot/features/run_map/presentation/blocs/other_user_details/other_user_details_event.dart';
import 'package:hotfoot/features/run_map/presentation/ui/widgets/order_details_popup.dart';
import 'package:hotfoot/features/run_map/presentation/ui/widgets/user_details_popup.dart';
import 'package:hotfoot/features/run_placed/presentation/blocs/run_update/run_update_bloc.dart';
import 'package:hotfoot/features/run_placed/presentation/blocs/run_update/run_update_state.dart';
import 'package:hotfoot/features/user/domain/entities/user_entity.dart';

class MoreInfoSpeedDial extends StatelessWidget {
  final UserType userType;

  const MoreInfoSpeedDial({Key key, @required this.userType}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    OtherUserDetailsBloc _otherUserDetailsBloc =
        BlocProvider.of<OtherUserDetailsBloc>(context);
    final bool isRunner = userType == UserType.RUNNER;

    return BlocBuilder<RunUpdateBloc, RunUpdateState>(
        builder: (BuildContext context, RunUpdateState state) {
      return SpeedDial(
        animatedIcon: AnimatedIcons.menu_close,
        animatedIconTheme: IconThemeData(size: 22.0),
        animationSpeed: 250,
        marginRight: 25.0,
        marginBottom: 30.0,
        curve: Curves.bounceIn,
        children: [
          SpeedDialChild(
            child: Icon(Icons.assignment, color: Colors.white),
            onTap: () => showDialog(
                context: context,
                builder: (context) {
                  return OrderDetailsPopUp();
                }),
            label: 'Order Details',
            labelStyle:
                TextStyle(color: Colors.white, fontWeight: FontWeight.w500),
            labelBackgroundColor: Colors.redAccent,
          ),
          SpeedDialChild(
            child: Icon(Icons.directions_run, color: Colors.white),
            onTap: () {
              if (state is RunUpdateLoadSuccess) {
                _otherUserDetailsBloc.add(OtherUserDetailsRequested(
                    userId: isRunner
                        ? state.runModel.customerId
                        : state.runModel.runnerId));
              }
              showDialog(
                  context: context,
                  builder: (_) {
                    return BlocProvider.value(
                      value: _otherUserDetailsBloc,
                      child: UserDetailsPopUp(userType: userType),
                    );
                  });
            },
            label: '${isRunner ? 'Customer' : 'Runner'} Details',
            labelStyle:
                TextStyle(color: Colors.white, fontWeight: FontWeight.w500),
            labelBackgroundColor: Colors.redAccent,
          ),
        ],
      );
    });
  }
}
