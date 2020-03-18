import 'package:firebase_auth/firebase_auth.dart';
import 'package:get_it/get_it.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:hotfoot/core/validators/validators.dart';
import 'package:hotfoot/features/login/data/repositories/login_repository_impl.dart';
import 'package:hotfoot/features/login/domain/repositories/login_repository.dart';
import 'package:hotfoot/features/login/domain/use_cases/sign_in_with_credentials.dart';
import 'package:hotfoot/features/login/domain/use_cases/sign_in_with_google.dart';
import 'package:hotfoot/features/login/presentation/bloc/login_bloc.dart';
import 'package:hotfoot/features/navigation_home/presentation/bloc/navigation_home_bloc.dart';
import 'package:hotfoot/features/navigation_auth/data/repositories/navigation_auth_repository_impl.dart';
import 'package:hotfoot/features/navigation_auth/domain/repositories/navigation_auth_repository.dart';
import 'package:hotfoot/features/navigation_auth/domain/use_cases/get_user.dart';
import 'package:hotfoot/features/navigation_auth/domain/use_cases/is_signed_in.dart';
import 'package:hotfoot/features/navigation_auth/domain/use_cases/sign_out.dart';
import 'package:hotfoot/features/navigation_auth/presentation/bloc/navigation_auth_bloc.dart';
import 'package:hotfoot/features/navigation_screen/presentation/bloc/navigation_screen_bloc.dart';
import 'package:hotfoot/features/registration/data/repositories/registration_repository_impl.dart';
import 'package:hotfoot/features/registration/domain/repositories/registration_repository.dart';
import 'package:hotfoot/features/registration/domain/use_cases/sign_up.dart';
import 'package:hotfoot/features/registration/presentation/bloc/registration_bloc.dart';

final sl = GetIt.instance;

void init() {
  // Bloc
  sl.registerFactory(() => LoginBloc(
        signInWithGoogle: sl(),
        signInWithCredentials: sl(),
        validators: sl(),
      ));
  sl.registerFactory(() => RegistrationBloc(
        signUp: sl(),
        validators: sl(),
      ));
  sl.registerFactory(() => NavigationAuthBloc(
        isSignedIn: sl(),
        getUser: sl(),
        signOut: sl(),
      ));
  sl.registerFactory(() => NavigationHomeBloc());
  sl.registerFactory(() => NavigationScreenBloc());

  // Use cases
  sl.registerLazySingleton(() => SignInWithGoogle(
        loginRepository: sl(),
      ));
  sl.registerLazySingleton(() => SignInWithCredentials(
        loginRepository: sl(),
      ));
  sl.registerLazySingleton(() => SignUp(
        registrationRepository: sl(),
      ));
  sl.registerLazySingleton(() => IsSignedIn(
        navigationAuthRepository: sl(),
      ));
  sl.registerLazySingleton(() => GetUser(
        navigationAuthRepository: sl(),
      ));
  sl.registerLazySingleton(() => SignOut(
        navigationAuthRepository: sl(),
      ));

  // Repositories
  sl.registerLazySingleton<ILoginRepository>(() => LoginRepository(
        firebaseAuth: sl(),
        googleSignIn: sl(),
      ));
  sl.registerLazySingleton<IRegistrationRepository>(
      () => RegistrationRepository(
            firebaseAuth: sl(),
          ));
  sl.registerLazySingleton<INavigationAuthRepository>(
      () => NavigationAuthRepository(
            firebaseAuth: sl(),
            googleSignIn: sl(),
          ));

  // External Dependencies
  sl.registerLazySingleton(() => FirebaseAuth.instance);
  sl.registerLazySingleton(() => GoogleSignIn());

  // Core
  sl.registerLazySingleton(() => Validators());
}
