import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hotfoot/features/navigation_screen/presentation/bloc/navigation_screen_bloc.dart';
import 'package:hotfoot/src/app.dart';
import 'features/navigation_auth/presentation/bloc/navigation_auth_bloc.dart';
import 'features/navigation_auth/presentation/bloc/navigation_auth_event.dart';
import 'injection_container.dart' as di;

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  di.init();
  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider<NavigationAuthBloc>(
          create: (context) => di.sl<NavigationAuthBloc>()..add(AppStarted()),
        ),
        BlocProvider<NavigationScreenBloc>(
          create: (context) => di.sl<NavigationScreenBloc>(),
        ),
      ],
      child: App(),
    ),
  );
}
