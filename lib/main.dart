import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hotfoot/src/blocs/authentication_bloc/authentication_bloc.dart';
import 'package:hotfoot/src/utils/user_repository.dart';
import 'package:hotfoot/src/app.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  final UserRepository userRepository = UserRepository();
  runApp(
    BlocProvider(
      create: (context) => AuthenticationBloc(userRepository: userRepository)
        ..add(AppStarted()),
      child: App(userRepository: userRepository),
    ),
  );
}

// void main() => runApp(App());

