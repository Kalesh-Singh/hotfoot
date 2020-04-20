import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hotfoot/features/navigation_home/presentation/ui/widgets/bottom_nav_bar.dart';
import 'package:hotfoot/features/runs/presentation/ui/widgets/runs_list.dart';
import 'package:hotfoot/features/runs/presentation/blocs/customer_runs_ids/customer_runs_ids_bloc.dart';
import 'package:hotfoot/features/runs/presentation/blocs/customer_runs_ids/customer_runs_ids_event.dart';
import 'package:hotfoot/features/runs/presentation/blocs/customer_runs_ids/customer_runs_ids_state.dart';
import 'package:hotfoot/features/runs/presentation/blocs/runner_runs_ids/runner_runs_ids_bloc.dart';
import 'package:hotfoot/features/runs/presentation/blocs/runner_runs_ids/runner_runs_ids_event.dart';
import 'package:hotfoot/features/runs/presentation/blocs/runner_runs_ids/runner_runs_ids_state.dart';
import 'package:hotfoot/features/user/presentation/blocs/user_type/user_type_bloc.dart';
import 'package:hotfoot/features/user/presentation/blocs/user_type/user_type_state.dart';
import 'package:hotfoot/injection_container.dart';

class RunsTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<CustomerRunsIdsBloc>(
          create: (context) => sl<CustomerRunsIdsBloc>(),
        ),
        BlocProvider<RunnerRunsIdsBloc>(
          create: (context) => sl<RunnerRunsIdsBloc>(),
        ),
      ],
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Your Runs'),
        ),
        body: BlocBuilder<UserTypeBloc, UserTypeState>(
          builder: (BuildContext context, UserTypeState state) {
            final bool _isRunner = state is RunnerUserType;
            return _isRunner ? _runnerRuns() : _customerRuns();
          },
        ),
        bottomNavigationBar: BottomNavBar(),
      ),
    );
  }

  Widget _runnerRuns() {
    return Container(
      child: Center(
        child: BlocBuilder<RunnerRunsIdsBloc, RunnerRunsIdsState>(
          builder: (BuildContext context, RunnerRunsIdsState state) {
            if (state is RunnerRunsIdsLoadSuccess) {
              if (state.runnerRunsIds.length == 0) {
                return Text('No runs completed yet.');
              } else {
                return RunsList(
                  runsIds: state.runnerRunsIds,
                  isRunner: true,
                  isPending: false,
                );
              }
            } else if (state is RunnerRunsIdsLoadFailure) {
              return Text(state.message);
            } else if (state is RunnerRunsIdsUninitialized) {
              BlocProvider.of<RunnerRunsIdsBloc>(context)
                  .add(RunnerRunsRequested());
              return CircularProgressIndicator();
            } else {
              return Container();
            }
          },
        ),
      ),
    );
  }

  Widget _customerRuns() {
    return Container(
      child: Center(
        child: BlocBuilder<CustomerRunsIdsBloc, CustomerRunsIdsState>(
          builder: (BuildContext context, CustomerRunsIdsState state) {
            if (state is CustomerRunsIdsLoadSuccess) {
              if (state.customerRunsIds.length == 0) {
                return Text('No runs requested yet.');
              } else {
                return RunsList(
                  runsIds: state.customerRunsIds,
                  isRunner: false,
                  isPending: false,
                );
              }
            } else if (state is CustomerRunsIdsLoadFailure) {
              return Text(state.message);
            } else if (state is CustomerRunsIdsUninitialized) {
              BlocProvider.of<CustomerRunsIdsBloc>(context)
                  .add(CustomerRunsRequested());
              return CircularProgressIndicator();
            } else {
              return Container();
            }
          },
        ),
      ),
    );
  }
}
