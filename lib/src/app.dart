import 'package:flutter/material.dart';
import 'screens/login.dart';
import 'screens/home.dart';
import 'screens/request_run.dart';
import 'screens/run_status.dart';
import 'screens/profile.dart';

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
        builder: (BuildContext context) {
          return LoginScreen();
        },
      );
    case '/home':
      return MaterialPageRoute(
        builder: (BuildContext context) {
          return HomeScreen();
        },
      );
    case '/request_run':
      return MaterialPageRoute(
        builder: (BuildContext context) {
          return RequestRunScreen();
        },
      );
    case '/run_status':
      return MaterialPageRoute(
        builder: (BuildContext context) {
          return RunStatusScreen();
        },
      );
    case '/profile':
      return MaterialPageRoute(
        builder: (BuildContext context) {
          return ProfileScreen();
        },
      );
  }
  if (settings.name == '/') {
    return MaterialPageRoute(
      builder: (BuildContext context) {
        return LoginScreen();
      },
    );
  } else {
    return MaterialPageRoute(
      builder: (BuildContext context) {
        return HomeScreen();
      },
    );
  }
}