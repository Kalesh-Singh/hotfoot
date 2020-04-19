import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hotfoot/features/runs/presentation/ui/widgets/run_card.dart';
import 'package:hotfoot/features/runs/presentation/blocs/run_details/run_details_bloc.dart';
import 'package:hotfoot/features/runs/presentation/blocs/run_details/run_details_event.dart';
import 'package:hotfoot/features/runs/presentation/blocs/run_details/run_details_state.dart';
import 'package:hotfoot/injection_container.dart';

class RunListTile extends StatelessWidget {
  final String runId;
  final bool isRunner;
  final bool isPending;

  const RunListTile({
    Key key,
    @required this.runId,
    @required this.isRunner,
    @required this.isPending,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider<RunDetailsBloc>(
      create: (context) => sl<RunDetailsBloc>(),
      child: Container(
        child: BlocBuilder<RunDetailsBloc, RunDetailsState>(
          builder: (BuildContext context, RunDetailsState state) {
            if (state is RunDetailsUninitialized) {
              BlocProvider.of<RunDetailsBloc>(context)
                  .add(RunDetailsRequested(runId: runId));
              return Container(
                height: 50,
                child: Center(
                  child: Text('Loading'),
                ),
              );
            } else if (state is RunDetailsLoadSuccess) {
              return RunCard(
                runEntity: state.runEntity,
                isRunner: isRunner,
                isPending: false,
              );
            } else {
              return Container();
            }
          },
        ),
      ),
    );
  }
}
