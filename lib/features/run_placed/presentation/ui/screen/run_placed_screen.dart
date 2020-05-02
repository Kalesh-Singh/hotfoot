import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hotfoot/features/navigation_screen/presentation/bloc/navigation_screen_bloc.dart';
import 'package:hotfoot/features/run_placed/presentation/blocs/qr_code/qr_code_bloc.dart';
import 'package:hotfoot/features/run_map/presentation/ui/widgets/run_map_widget.dart';
import 'package:hotfoot/features/run_placed/presentation/blocs/run_update/run_update_bloc.dart';
import 'package:hotfoot/features/run_placed/presentation/ui/widgets/active_run_info_widget.dart';
import 'package:hotfoot/features/user/domain/entities/user_entity.dart';
import 'package:hotfoot/features/user/presentation/blocs/user_type/user_type_bloc.dart';
import 'package:hotfoot/features/user/presentation/blocs/user_type/user_type_state.dart';
import 'package:hotfoot/injection_container.dart';
import 'package:hotfoot/features/runs/data/models/run_model.dart';

class RunPlacedScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final navScreenBloc = BlocProvider.of<NavigationScreenBloc>(context);
    final currRun = navScreenBloc.state.runModel;
    final bool isRunner =
        BlocProvider.of<UserTypeBloc>(context).state is RunnerUserType;
    final json1 = json.encode(currRun.toJson());
    print('FROM NAV BLOC');
    print(json1);
    return BlocProvider<QRCodeBloc>(
      create: (context) => sl<QRCodeBloc>(),
      child: isRunner
          ? _runnerRunPlacedScreen(context, currRun)
          : _customerRunPlacedScreen(context, currRun),
    );
  }

  Widget _runnerRunPlacedScreen(BuildContext context, RunModel currRun) {
    return Scaffold(
      appBar: AppBar(title: Text('Run Status')),
      body: BlocProvider<RunUpdateBloc>(
        create: (context) => sl<RunUpdateBloc>(),
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Container(
                height: MediaQuery.of(context).size.height / 1.65,
                child: RunMapWidget(userType: UserType.RUNNER),
              ),
              ActiveRunInfoWidget(runModel: currRun),
            ],
          ),
        ),
      ),
    );
  }

  Widget _customerRunPlacedScreen(BuildContext context, RunModel currRun) {
    return Scaffold(
      appBar: AppBar(title: Text('Run Status')),
      body: BlocProvider<RunUpdateBloc>(
        create: (context) => sl<RunUpdateBloc>(),
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Container(
                height: MediaQuery.of(context).size.height / 1.65,
                child: RunMapWidget(userType: UserType.CUSTOMER),
              ),
              ActiveRunInfoWidget(runModel: currRun),
            ],
          ),
        ),
      ),
    );
  }
}
