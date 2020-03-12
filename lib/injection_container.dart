import 'package:get_it/get_it.dart';

import 'features/authentication/domain/use_cases/sign_in_with_google.dart';
import 'features/authentication/presentation/bloc/login/login_bloc.dart';

final sl = GetIt.instance;

void init() {
  // Bloc
  sl.registerFactory(() => LoginBloc(
    signInWithGoogle: sl(),
    signInWithCredentials: sl(),
  ));

  // Use cases
  sl.registerLazySingleton(() => SignInWithGoogle());

  // Repository

  // Data Sources TODO: None as of yet

  // External Dependencies

  // Core
}