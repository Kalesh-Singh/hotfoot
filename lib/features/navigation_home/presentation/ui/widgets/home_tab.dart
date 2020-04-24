import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hotfoot/features/location/presentation/ui/address_widget.dart';
import 'package:hotfoot/features/navigation_home/presentation/ui/widgets/bottom_nav_bar.dart';
import 'package:hotfoot/features/runs/presentation/ui/widgets/runs_list.dart';
import 'package:hotfoot/features/navigation_screen/presentation/bloc/navigation_screen_bloc.dart';
import 'package:hotfoot/features/navigation_screen/presentation/bloc/navigation_screen_event.dart';
import 'package:hotfoot/features/places/presentation/blocs/places_ids/places_ids_bloc.dart';
import 'package:hotfoot/features/places/presentation/ui/widgets/place_list.dart';
import 'package:hotfoot/features/runs/presentation/blocs/pending_runs_ids/pending_runs_ids_bloc.dart';
import 'package:hotfoot/features/runs/presentation/blocs/pending_runs_ids/pending_runs_ids_event.dart';
import 'package:hotfoot/features/runs/presentation/blocs/pending_runs_ids/pending_runs_ids_state.dart';
import 'package:hotfoot/features/user/presentation/blocs/user_type/user_type_bloc.dart';
import 'package:hotfoot/features/user/presentation/blocs/user_type/user_type_state.dart';
import 'package:hotfoot/injection_container.dart';

class HomeTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final bool isRunner =
        BlocProvider.of<UserTypeBloc>(context).state is RunnerUserType;
    return isRunner ? _runnerHomeTab(context) : _customerHomeTab(context);
  }

  Widget _customerHomeTab(BuildContext context) {
    return BlocProvider<PlacesIdsBloc>(
      create: (context) => sl<PlacesIdsBloc>(),
      child: Scaffold(
        appBar: AppBar(
          title: Center(
            child: Text('Popular Near You'),
          ),
          actions: <Widget>[
            Padding(
                padding: EdgeInsets.only(right: 20.0),
                child: GestureDetector(
                  onTap: () {
                    BlocProvider.of<NavigationScreenBloc>(context)
                        .add(EnteredSettings());
                  },
                  child: Icon(
                    Icons.settings,
                    size: 26.0,
                  ),
                )),
          ],
        ),
        body: Column(
          children: <Widget>[
            AddressWidget(),
            Expanded(child: PlacesList()),
          ],
        ),
        bottomNavigationBar: BottomNavBar(),
      ),
    );
  }

  Widget _runnerHomeTab(BuildContext context) {
    return BlocProvider<PendingRunsIdsBloc>(
      create: (context) => sl<PendingRunsIdsBloc>(),
      child: Scaffold(
        appBar: AppBar(
          title: Center(
            child: Text('Requested Runs'),
          ),
          actions: <Widget>[
            Padding(
                padding: EdgeInsets.only(right: 20.0),
                child: GestureDetector(
                  onTap: () {
                    BlocProvider.of<NavigationScreenBloc>(context)
                        .add(EnteredSettings());
                  },
                  child: Icon(
                    Icons.settings,
                    size: 26.0,
                  ),
                )),
          ],
        ),
        body: Container(
          child: Center(
            child: BlocBuilder<PendingRunsIdsBloc, PendingRunsIdsState>(
              builder: (BuildContext context, PendingRunsIdsState state) {
                if (state is PendingRunsIdsLoadSuccess) {
                  if (state.pendingRunsIds.length == 0) {
                    return Text('No pending runs.');
                  } else {
                    return RunsList(
                      runsIds: state.pendingRunsIds,
                      isRunner: true,
                      isPending: true,
                    );
                  }
                } else if (state is PendingRunsIdsLoadFailure) {
                  return Text(state.message);
                } else if (state is PendingRunsIdsUninitialized) {
                  BlocProvider.of<PendingRunsIdsBloc>(context)
                      .add(PendingRunsRequested());
                  return CircularProgressIndicator();
                } else {
                  return Container();
                }
              },
            ),
          ),
        ),
        bottomNavigationBar: BottomNavBar(),
      ),
    );
  }
}
