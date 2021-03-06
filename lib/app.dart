import 'package:flutter/material.dart';
import 'package:hotfoot/features/login/presentation/ui/screen/login_screen.dart';
import 'package:hotfoot/features/navigation_auth/presentation/bloc/navigation_auth_bloc.dart';
import 'package:hotfoot/features/navigation_auth/presentation/bloc/navigation_auth_state.dart';
import 'package:hotfoot/features/navigation_home/presentation/bloc/navigation_home_bloc.dart';
import 'package:hotfoot/features/navigation_home/presentation/ui/screen/home_screen.dart';
import 'package:hotfoot/features/navigation_screen/presentation/bloc/navigation_screen_bloc.dart';
import 'package:hotfoot/features/navigation_screen/presentation/bloc/navigation_screen_event.dart';
import 'package:hotfoot/features/navigation_screen/presentation/bloc/navigation_screen_state.dart';
import 'package:hotfoot/features/run_placed/presentation/ui/screen/run_placed_screen.dart';
import 'package:hotfoot/features/runs/presentation/blocs/active_run/active_run_bloc.dart';
import 'package:hotfoot/features/runs/presentation/blocs/active_run/active_run_event.dart';
import 'package:hotfoot/features/runs/presentation/blocs/active_run/active_run_state.dart';
import 'package:hotfoot/features/runs/presentation/ui/screens/accept_run_screen.dart';
import 'package:hotfoot/features/runs/presentation/ui/screens/run_details_screen.dart';
import 'package:hotfoot/features/user/domain/entities/user_entity.dart';
import 'package:hotfoot/features/user/presentation/blocs/user_type/user_type_bloc.dart';
import 'package:hotfoot/features/user/presentation/blocs/user_type/user_type_event.dart';
import 'package:hotfoot/features/user/presentation/blocs/user_type/user_type_state.dart';
import 'package:hotfoot/injection_container.dart';
import 'package:hotfoot/features/user/presentation/ui/screens/settings_screen.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hotfoot/features/login/presentation/ui/screen/splash_screen.dart';

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<NavigationHomeBloc>(),
      child: MaterialApp(
        theme: ThemeData(
          primarySwatch: Colors.red,
        ),
        home: BlocBuilder<NavigationAuthBloc, NavigationAuthState>(
          builder: (context, state) {
            if (state is Uninitialized) {
              return SplashScreen();
            } else if (state is Authenticated) {
              print('Authenticated');
              BlocProvider.of<UserTypeBloc>(context).add(UserTypeRequested());

              return BlocBuilder<UserTypeBloc, UserTypeState>(
                builder: (context, state) {
                  if (state is UserTypeLoading) {
                    return Container(
                      child: Center(
                        child: CircularProgressIndicator(),
                      ),
                    );
                  } else {
                    // TODO: Active run BlocBuilder
                    // if (ActiveRunUnknown) {
                    // return ProgressIndicator();
                    // else if (ActiveRun)
                    // Go to run placed screen
                    // else if (NoRunsActive)
                    // return the following bloc builder
                    final UserType userType = (state is RunnerUserType)
                        ? UserType.RUNNER
                        : UserType.CUSTOMER;

                    return BlocBuilder<ActiveRunBloc, ActiveRunState>(
                      builder: (context, state) {
                        if (state is ActiveRunUninitialized) {
                          BlocProvider.of<ActiveRunBloc>(context)
                              .add(ActiveRunRequested(userType: userType));
                          return Container(
                            child: Center(
                              child: CircularProgressIndicator(),
                            ),
                          );
                        } else {
                          if (state is RunActive) {
                            BlocProvider.of<NavigationScreenBloc>(context).add(
                              EnteredRunPlaced(
                                runModel: state.activeRun,
                                isRunner: userType == UserType.RUNNER,
                              ),
                            );
                          }
                          return BlocBuilder<NavigationScreenBloc,
                              NavigationScreenState>(
                            builder: (context, state) {
                              print(
                                  'NAV BLOC STATE TYPE: ${state.runtimeType}');
                              if (state is Home) {
                                print('HOME');
                                return HomeScreen();
                              } else if (state is RunDetails) {
                                print('RUN DETAILS');
                                return RunDetailsScreen();
                              } else if (state is RunPlaced) {
                                print('RUN PLACED');
                                return RunPlacedScreen();
                              } else if (state is Settings) {
                                print('SETTINGS');
                                return SettingsScreen();
                              } else if (state is Login) {
                                print('LOGIN');
                                return LoginScreen();
                              } else if (state is AcceptRun) {
                                print('ACCEPT RUN');
                                return AcceptRunScreen();
                              }
                              return Container();
                            },
                          );
                        }
                      },
                    );
                  }
                },
              );
            } else if (state is Unauthenticated) {
              print('Not logged in');
              return LoginScreen();
            }
            print('Navigation Auth State: $state');
            return SplashScreen();
          },
        ),
      ),
    );
  }
}
