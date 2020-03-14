import 'package:flutter/material.dart';
import 'package:hotfoot/features/login/presentation/ui/screen/login_screen.dart';
import 'package:hotfoot/features/navigation_auth/presentation/bloc/navigation_auth_bloc.dart';
import 'package:hotfoot/features/navigation_auth/presentation/bloc/navigation_auth_state.dart';
import 'package:hotfoot/features/navigation_home/presentation/bloc/navigation_home_bloc.dart';
import 'package:hotfoot/features/navigation_home/presentation/ui/screen/home_screen.dart';
import 'package:hotfoot/injection_container.dart';
import 'screens/run_status.dart';
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
            }
            if (state is Authenticated) {
              print('Authenticated');
              return HomeScreen();
            }
            if (state is Unauthenticated) {
              print('Not logged in');
              return LoginScreen();
            }
            return Container();
          },
        ),
        onGenerateRoute: routes,
      ),
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
        builder: (BuildContext context) => HomeScreen(),
      );
    case '/run_status':
      return MaterialPageRoute(
        builder: (BuildContext context) => RunStatusScreen(),
      );
    default:
      return MaterialPageRoute(
        builder: (BuildContext context) => HomeScreen(),
      );
  }
}
