import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hotfoot/features/run_map/presentation/blocs/runner_location/runner_location_bloc.dart';
import 'package:hotfoot/features/run_map/presentation/ui/widgets/customer_run_map.dart';
import 'package:hotfoot/injection_container.dart';

class CustomerMapWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider<RunnerLocationBloc>(
      create: (context) => sl<RunnerLocationBloc>(),
      child: Container(
        child: CustomerRunMap(),
      ),
    );
  }
}
