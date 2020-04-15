import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hotfoot/features/navigation_home/presentation/ui/widgets/bottom_nav_bar.dart';
import 'package:hotfoot/features/user/presentation/blocs/user_type/user_type_bloc.dart';
import 'package:hotfoot/features/user/presentation/blocs/user_type/user_type_state.dart';

class RunsTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
        child: Text('No runs requested yet'),
      ),
    );
  }
}
