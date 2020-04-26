import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hotfoot/features/run_map/presentation/blocs/runner_location/runner_location_bloc.dart';
import 'package:hotfoot/features/run_map/presentation/ui/widgets/run_map.dart';
import 'package:hotfoot/features/user/domain/entities/user_entity.dart';
import 'package:hotfoot/injection_container.dart';

class RunMapWidget extends StatelessWidget {
  final UserType userType;

  const RunMapWidget({Key key, @required this.userType}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider<RunnerLocationBloc>(
      create: (context) => sl<RunnerLocationBloc>(),
      child: Container(
        child: RunMap(userType: userType),
      ),
    );
  }
}
