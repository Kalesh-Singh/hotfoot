import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hotfoot/features/run_map/presentation/blocs/other_user_details/other_user_details_bloc.dart';
import 'package:hotfoot/features/run_map/presentation/blocs/runner_location/runner_location_bloc.dart';
import 'package:hotfoot/features/run_map/presentation/ui/widgets/more_info_speed_dial.dart';
import 'package:hotfoot/features/run_map/presentation/ui/widgets/run_map.dart';
import 'package:hotfoot/features/user/domain/entities/user_entity.dart';
import 'package:hotfoot/injection_container.dart';

class RunMapWidget extends StatelessWidget {
  final UserType userType;

  const RunMapWidget({Key key, @required this.userType}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<RunnerLocationBloc>(
            create: (context) => sl<RunnerLocationBloc>()),
        BlocProvider<OtherUserDetailsBloc>(
            create: (context) => sl<OtherUserDetailsBloc>()),
      ],
      child: Container(
        child: Stack(children: <Widget>[
          RunMap(userType: userType),
          MoreInfoSpeedDial(userType: userType),
        ]),
      ),
    );
  }
}
