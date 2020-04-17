import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hotfoot/features/navigation_home/presentation/ui/widgets/bottom_nav_bar.dart';
import 'package:hotfoot/features/navigation_home/presentation/ui/widgets/runs_list.dart';
import 'package:hotfoot/features/runs/presentation/blocs/customer_runs_ids/customer_runs_ids_bloc.dart';
import 'package:hotfoot/features/runs/presentation/blocs/customer_runs_ids/customer_runs_ids_event.dart';
import 'package:hotfoot/features/runs/presentation/blocs/customer_runs_ids/customer_runs_ids_state.dart';
import 'package:hotfoot/features/user/presentation/blocs/user_type/user_type_bloc.dart';
import 'package:hotfoot/features/user/presentation/blocs/user_type/user_type_state.dart';
import 'package:hotfoot/injection_container.dart';

class RunsTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<CustomerRunsIdsBloc>(
            create: (context) => sl<CustomerRunsIdsBloc>()),
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
        child: Text('No runs completed yet'),
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
                return RunsList(runsIds: state.customerRunsIds);
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
