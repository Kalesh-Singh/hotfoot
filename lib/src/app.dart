import 'package:flutter/material.dart';
import 'screens/run_status.dart';
import 'screens/login.dart';
import 'app_state.dart';

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'HotFoot',
      theme: ThemeData(
        primarySwatch: Colors.orange,
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
