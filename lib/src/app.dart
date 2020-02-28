import 'package:flutter/material.dart';
import 'package:hotfoot/src/screens/profile.dart';
import 'screens/run_status.dart';
import 'screens/login.dart';
import 'app_state.dart';
import 'package:hotfoot/src/utils/user_repository.dart';
import 'package:hotfoot/src/blocs/authentication_bloc/authentication_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hotfoot/src/utils/splash_screen.dart';

// class App extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'HotFoot',
//       theme: ThemeData(
//         primarySwatch: Colors.orange,
//       ),
//       onGenerateRoute: routes,
//     );
//   }
// }

class App extends StatelessWidget {
  final UserRepository _userRepository;
  App({Key key, @required UserRepository userRepository})
    : assert(userRepository != null),
      _userRepository = userRepository,
      super(key: key);
  
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: BlocBuilder<AuthenticationBloc, AuthenticationState>(
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
            return LoginScreen(userRepository: _userRepository);
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
        builder: (BuildContext context) => LoginScreen(userRepository: null,),
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
