import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hotfoot/features/location/presentation/bloc/location_bloc.dart';
import 'package:hotfoot/features/location/presentation/bloc/location_event.dart';
import 'package:hotfoot/features/navigation_home/presentation/bloc/navigation_home_bloc.dart';
import 'package:hotfoot/features/navigation_home/presentation/bloc/navigation_home_state.dart';
import 'package:hotfoot/features/navigation_home/presentation/ui/widgets/home_tab.dart';
import 'package:hotfoot/features/navigation_home/presentation/ui/widgets/runs_tab.dart';
import 'package:hotfoot/features/navigation_home/presentation/ui/widgets/search_tab.dart';
import 'package:hotfoot/features/user/presentation/blocs/user_type/user_type_bloc.dart';
import 'package:hotfoot/features/user/presentation/blocs/user_type/user_type_state.dart';
import 'package:hotfoot/injection_container.dart';

// Run Placed Screen at

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider<LocationBloc>(
      create: (context) => sl<LocationBloc>()..add(CurrentPlaceRequested()),
      child: BlocBuilder<UserTypeBloc, UserTypeState>(
        builder: (BuildContext context, UserTypeState state) {
          if (state is UserTypeLoading) {
            return Container(
              child: Center(
                child: CircularProgressIndicator(),
              ),
            );
          } else {
            return Container(
              child: BlocBuilder<NavigationHomeBloc, NavigationHomeState>(
                  builder: (context, state) {
                switch (state.runtimeType) {
                  case HomeIconTab:
                    return HomeTab();
                  case SearchIconTab:
                    return SearchTab();
                  case RunsIconTab:
                    return RunsTab();
                  default:
                    return HomeTab();
                }
              }),
            );
          }
        },
      ),
    );
  }
}
