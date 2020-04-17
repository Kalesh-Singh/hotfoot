import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hotfoot/features/runs/presentation/blocs/run_details/run_details_bloc.dart';
import 'package:hotfoot/features/runs/presentation/blocs/run_details/run_details_event.dart';
import 'package:hotfoot/features/runs/presentation/blocs/run_details/run_details_state.dart';
import 'package:hotfoot/injection_container.dart';

class RunListTile extends StatelessWidget {
  final String runId;

  const RunListTile({Key key, this.runId}) : super(key: key);

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
//                return PlaceCard(placeEntity: state.placeEntity);
            // TODO: Run Card
              return Container(
                height: 50,
                child: Center(
                  child: Text(state.runEntity.order),
                ),
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
