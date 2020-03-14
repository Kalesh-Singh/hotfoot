import 'package:flutter/material.dart';
import 'package:hotfoot/features/login/presentation/ui/screen/login_screen.dart';
import 'package:hotfoot/features/navigation_auth/presentation/bloc/navigation_auth_bloc.dart';
import 'package:hotfoot/features/navigation_auth/presentation/bloc/navigation_auth_state.dart';
import 'package:hotfoot/src/screens/profile.dart';
import 'screens/run_status.dart';
import 'app_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hotfoot/src/utils/splash_screen.dart';

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.red,
      ),
      home: BlocBuilder<NavigationAuthBloc, NavigationAuthState>(
        builder: (context, state) {
          if (state is Uninitialized) {
            return SplashScreen();
          }
          if (state is Authenticated) {
            print('Authenticated');
            return ProfileScreen(name: state.displayName);
          }
          if (state is Unauthenticated) {
            print('Not logged in');
            return LoginScreen();
          }
          return Container();
        },
      ),
      onGenerateRoute: routes,
    );
  }
}

Route routes(RouteSettings settings) {
  String routeName = settings.name;
  switch (routeName) {
    case '/':
      return MaterialPageRoute(
        builder: (BuildContext context) => LoginScreen(),
      );
    case '/app_state':
      return MaterialPageRoute(
        builder: (BuildContext context) => AppState(),
      );
    case '/run_status':
      return MaterialPageRoute(
        builder: (BuildContext context) => RunStatusScreen(),
      );
    default:
      return MaterialPageRoute(
        builder: (BuildContext context) => AppState(),
      );
  }
}
