import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get_it/get_it.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:hotfoot/core/database/app_database.dart';
import 'package:hotfoot/core/network/network_info.dart';
import 'package:hotfoot/core/validators/validators.dart';
import 'package:hotfoot/features/location/data/repositories/location_repository_impl.dart';
import 'package:hotfoot/features/location/domain/repositories/location_repository.dart';
import 'package:hotfoot/features/location/domain/use_cases/get_current_place.dart';
import 'package:hotfoot/features/location/domain/use_cases/get_place_from_query.dart';
import 'package:hotfoot/features/location/presentation/bloc/location_bloc.dart';
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
import 'package:hotfoot/features/places/data/data_sources/data_access_objects/place_dao.dart';
import 'package:hotfoot/features/places/data/data_sources/data_access_objects/place_photo_dao.dart';
import 'package:hotfoot/features/places/data/data_sources/places_local_data_source.dart';
import 'package:hotfoot/features/places/data/data_sources/places_remote_data_source.dart';
import 'package:hotfoot/features/places/data/repositories/places_repositories_impl.dart';
import 'package:hotfoot/features/places/domain/repositories/places_repository.dart';
import 'package:hotfoot/features/places/domain/use_cases/get_place_by_id.dart';
import 'package:hotfoot/features/places/domain/use_cases/get_place_photo.dart';
import 'package:hotfoot/features/places/domain/use_cases/get_places_ids.dart';
import 'package:hotfoot/features/places/presentation/blocs/place_details/place_details_bloc.dart';
import 'package:hotfoot/features/places/presentation/blocs/place_photo/place_photo_bloc.dart';
import 'package:hotfoot/features/places/presentation/blocs/places_ids/places_ids_bloc.dart';
import 'package:hotfoot/features/registration/data/repositories/registration_repository_impl.dart';
import 'package:hotfoot/features/registration/domain/repositories/registration_repository.dart';
import 'package:hotfoot/features/registration/domain/use_cases/sign_up.dart';
import 'package:hotfoot/features/registration/presentation/bloc/registration_bloc.dart';
import 'package:hotfoot/features/run_map/data/repositories/route_repository_impl.dart';
import 'package:hotfoot/features/run_map/data/repositories/runner_location_repository_impl.dart';
import 'package:hotfoot/features/run_map/domain/repositories/route_repository.dart';
import 'package:hotfoot/features/run_map/domain/repositories/runner_location_repository.dart';
import 'package:hotfoot/features/run_map/domain/use_cases/get_route_between_points.dart';
import 'package:hotfoot/features/run_map/domain/use_cases/get_runner_location_stream.dart';
import 'package:hotfoot/features/run_map/domain/use_cases/insert_or_update_runner_location.dart';
import 'package:hotfoot/features/run_map/presentation/blocs/other_user_details/other_user_details_bloc.dart';
import 'package:hotfoot/features/run_map/presentation/blocs/runner_location/runner_location_bloc.dart';
import 'package:hotfoot/features/run_placed/presentation/blocs/qr_code/qr_code_bloc.dart';
import 'package:hotfoot/features/run_placed/presentation/blocs/run_update/run_update_bloc.dart';
import 'package:hotfoot/features/runs/data/data_sources/data_access_objects/run_dao.dart';
import 'package:hotfoot/features/runs/data/data_sources/runs_local_data_source.dart';
import 'package:hotfoot/features/runs/data/data_sources/runs_remote_data_source.dart';
import 'package:hotfoot/features/runs/data/repositories/runs_repositories_impl.dart';
import 'package:hotfoot/features/runs/domain/repositories/runs_repository.dart';
import 'package:hotfoot/features/runs/domain/use_cases/get_customer_runs_ids.dart';
import 'package:hotfoot/features/runs/domain/use_cases/get_pending_runs_ids.dart';
import 'package:hotfoot/features/runs/domain/use_cases/get_run_by_id.dart';
import 'package:hotfoot/features/runs/domain/use_cases/get_runner_runs_ids.dart';
import 'package:hotfoot/features/runs/domain/use_cases/init_run.dart';
import 'package:hotfoot/features/runs/domain/use_cases/update_or_insert_run.dart';
import 'package:hotfoot/features/runs/presentation/blocs/accept_run/accept_run_bloc.dart';
import 'package:hotfoot/features/runs/presentation/blocs/customer_runs_ids/customer_runs_ids_bloc.dart';
import 'package:hotfoot/features/runs/presentation/blocs/pending_runs_ids/pending_runs_ids_bloc.dart';
import 'package:hotfoot/features/runs/presentation/blocs/run_details/run_details_bloc.dart';
import 'package:hotfoot/features/runs/presentation/blocs/runner_runs_ids/runner_runs_ids_bloc.dart';
import 'package:hotfoot/features/search/presentation/blocs/search_bottom_drawer/drawer_contents/drawer_contents_bloc.dart';
import 'package:hotfoot/features/search/presentation/blocs/search_bottom_drawer/search_bottom_drawer_bloc.dart';
import 'package:hotfoot/features/search/presentation/blocs/search_handler_screen/search_handler_screen_bloc.dart';
import 'package:hotfoot/features/search/presentation/blocs/search_map/search_map_bloc.dart';
import 'package:hotfoot/features/search/presentation/blocs/unknown_place_screen/unknown_place_screen_bloc.dart';
import 'package:hotfoot/features/user/data/data_sources/data_access_objects/user_photo_dao.dart';
import 'package:hotfoot/features/user/domain/repositories/user_repository.dart';
import 'package:hotfoot/features/user/data/repositories/user_repositories_impl.dart';
import 'package:hotfoot/features/user/data/data_sources/user_local_data_source.dart';
import 'package:hotfoot/features/user/data/data_sources/user_remote_data_source.dart';
import 'package:hotfoot/features/user/data/data_sources/data_access_objects/user_dao.dart';
import 'package:hotfoot/features/user/domain/use_cases/get_customer_rating.dart';
import 'package:hotfoot/features/user/domain/use_cases/add_user_funds.dart';
import 'package:hotfoot/features/user/domain/use_cases/get_user_funds.dart';
import 'package:hotfoot/features/user/domain/use_cases/get_user_id.dart';
import 'package:hotfoot/features/user/domain/use_cases/get_user_info_by_id.dart';
import 'package:hotfoot/features/user/domain/use_cases/get_user_type.dart';
import 'package:hotfoot/features/user/domain/use_cases/init_user.dart';
import 'package:hotfoot/features/user/domain/use_cases/subtract_user_funds.dart';
import 'package:hotfoot/features/user/domain/use_cases/toggle_user_type.dart';
import 'package:hotfoot/features/user/presentation/blocs/user_ratings/user_ratings_bloc.dart';
import 'package:hotfoot/features/user/presentation/blocs/user_funds/user_funds_bloc.dart';
import 'package:hotfoot/features/user/domain/use_cases/get_user_photo.dart';
import 'package:hotfoot/features/user/domain/use_cases/insert_or_update_user_photo.dart';
import 'package:hotfoot/features/user/presentation/blocs/user_photo/user_photo_bloc.dart';
import 'package:hotfoot/features/user/presentation/blocs/user_type/user_type_bloc.dart';
import 'package:path_provider/path_provider.dart';
import 'features/search/data/data_sources/search_results_data_source.dart';
import 'features/search/data/repositories/search_results_repository_impl.dart';
import 'features/search/domain/repositories/search_results_repository.dart';
import 'features/search/domain/use_cases/get_results_with_matching_address.dart';
import 'features/search/presentation/blocs/results_with_matching_address/results_with_matching_address_bloc.dart';
import 'package:hotfoot/features/runs/domain/use_cases/get_run_stream.dart';
import 'package:hotfoot/features/search/data/data_sources/search_results_data_source.dart';
import 'package:hotfoot/features/search/data/repositories/search_results_repository_impl.dart';
import 'package:hotfoot/features/search/domain/repositories/search_results_repository.dart';
import 'package:hotfoot/features/search/domain/use_cases/get_results_with_matching_address.dart';
import 'package:hotfoot/features/search/presentation/blocs/results_with_matching_address/results_with_matching_address_bloc.dart';

final sl = GetIt.instance;

Future<void> init() async {
  // Bloc
  sl.registerFactory(() => LoginBloc(
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
  sl.registerFactory(() => NavigationScreenBloc(
        initRun: sl(),
        updateOrInsertRun: sl(),
      ));
  sl.registerFactory(() => PlacesIdsBloc(
        getPlacesIds: sl(),
      ));
  sl.registerFactory(() => PlaceDetailsBloc(
        getPlaceById: sl(),
      ));
  sl.registerFactory(() => PlacePhotoBloc(
        getPlacePhoto: sl(),
      ));
  sl.registerFactory(() => LocationBloc(
        getCurrentPlace: sl(),
        getPlaceFromQuery: sl(),
      ));
  sl.registerFactory(() => UserTypeBloc(
        toggleUserType: sl(),
        getUserType: sl(),
      ));
  sl.registerFactory(() => ResultsWithMatchingAddressBloc(
        getResultsWithMatchingAddress: sl(),
      ));
  sl.registerFactory(() => SearchMapBloc(
        getPlaceById: sl(),
      ));
  sl.registerFactory(() => DrawerContentsBloc(
        getPlaceById: sl(),
        getPlacePhoto: sl(),
      ));
  sl.registerFactory(() => SearchBottomDrawerBloc());
  sl.registerFactory(() => CustomerRunsIdsBloc(
        getCustomerRunsIds: sl(),
      ));
  sl.registerFactory(() => RunnerRunsIdsBloc(
        getRunnerRunsIds: sl(),
      ));
  sl.registerFactory(() => PendingRunsIdsBloc(
        getPendingRunsIds: sl(),
      ));
  sl.registerFactory(() => RunDetailsBloc(
        getRunById: sl(),
      ));
  sl.registerFactory(() => SearchHandlerScreenBloc());
  sl.registerFactory(() => UnknownPlaceScreenBloc());
  sl.registerFactory(() => RunnerLocationBloc(
        insertOrUpdateRunnerLocation: sl(),
        updateOrInsertRun: sl(),
        getPlaceById: sl(),
        getRouteBetweenPoints: sl(),
      ));
  sl.registerFactory(() => RunUpdateBloc());
  sl.registerFactory(() => AcceptRunBloc(
        getUserId: sl(),
        updateOrInsertRun: sl(),
      ));
  sl.registerFactory(() => QRCodeBloc(
        updateOrInsertRun: sl(),
        addUserFunds: sl(),
        subtractUserFunds: sl(),
      ));
  sl.registerFactory(() => UserFundsBloc(
        getUserFunds: sl(),
        addUserFunds: sl(),
      ));
  sl.registerFactory(() => OtherUserDetailsBloc(
        getUserInfoById: sl(),
      ));
  sl.registerFactory(() => UserPhotoBloc(
        insertOrUpdateUserPhoto: sl(),
        getUserPhoto: sl(),
      ));
  sl.registerFactory(() => UserRatingsBloc(
        getCustomerRating: sl(),
      ));

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
  sl.registerLazySingleton(() => GetPlacesIds(
        placesRepository: sl(),
      ));
  sl.registerLazySingleton(() => GetPlaceById(
        placesRepository: sl(),
      ));
  sl.registerLazySingleton(() => GetPlacePhoto(
        placesRepository: sl(),
      ));
  sl.registerLazySingleton(() => InitUser(
        userRepository: sl(),
      ));
  sl.registerLazySingleton(() => GetCurrentPlace(
        locationRepository: sl(),
      ));
  sl.registerLazySingleton(() => GetPlaceFromQuery(
        locationRepository: sl(),
      ));
  sl.registerLazySingleton(() => InitRun(
        runsRepository: sl(),
      ));
  sl.registerLazySingleton(() => GetUserId(
        userRepository: sl(),
      ));
  sl.registerLazySingleton(() => UpdateOrInsertRun(
        runsRepository: sl(),
      ));
  sl.registerLazySingleton(() => ToggleUserType(
        userRepository: sl(),
      ));
  sl.registerLazySingleton(() => GetUserType(
        userRepository: sl(),
      ));
  sl.registerLazySingleton(() => GetUserInfoById(
        userRepository: sl(),
      ));
  sl.registerLazySingleton(() => GetResultsWithMatchingAddress(
        searchResultsRepository: sl(),
      ));
  sl.registerLazySingleton(() => GetRunStream(
        runsRepository: sl(),
      ));
  sl.registerLazySingleton(() => GetCustomerRunsIds(
        runsRepository: sl(),
      ));
  sl.registerLazySingleton(() => GetRunnerRunsIds(
        runsRepository: sl(),
      ));
  sl.registerLazySingleton(() => GetPendingRunsIds(
        runsRepository: sl(),
      ));
  sl.registerLazySingleton(() => GetRunById(
        runsRepository: sl(),
      ));
  sl.registerLazySingleton(() => InsertOrUpdateRunnerLocation(
        runnerLocationRepository: sl(),
      ));
  sl.registerLazySingleton(() => GetRunnerLocationStream(
        runnerLocationRepository: sl(),
      ));
  sl.registerLazySingleton(() => GetRouteBetweenPoints(
        routeRepository: sl(),
      ));
  sl.registerLazySingleton(() => GetUserFunds(
        userRepository: sl(),
      ));
  sl.registerLazySingleton(() => AddUserFunds(
        userRepository: sl(),
      ));
  sl.registerLazySingleton(() => SubtractUserFunds(
        userRepository: sl(),
      ));
  sl.registerLazySingleton(() => GetUserPhoto(
        userRepository: sl(),
      ));
  sl.registerLazySingleton(() => InsertOrUpdateUserPhoto(
        userRepository: sl(),
      ));
  sl.registerLazySingleton(() => GetCustomerRating(
        userRepository: sl(),
      ));

  // Repositories
  sl.registerLazySingleton<ILoginRepository>(() => LoginRepository(
        firebaseAuth: sl(),
        googleSignIn: sl(),
      ));
  sl.registerLazySingleton<IRegistrationRepository>(
      () => RegistrationRepository(
            firebaseAuth: sl(),
            initUser: sl(),
          ));
  sl.registerLazySingleton<INavigationAuthRepository>(
      () => NavigationAuthRepository(
            firebaseAuth: sl(),
            googleSignIn: sl(),
          ));
  sl.registerLazySingleton<IPlacesRepository>(() => PlacesRepository(
        placesLocalDataSource: sl(),
        placesRemoteDataSource: sl(),
        networkInfo: sl(),
      ));
  sl.registerLazySingleton<IUserRepository>(() => UserRepository(
        networkInfo: sl(),
        userLocalDataSource: sl(),
        userRemoteDataSource: sl(),
      ));
  sl.registerLazySingleton<ILocationRepository>(() => LocationRepository(
        geolocator: sl(),
      ));
  sl.registerLazySingleton<IRunsRepository>(() => RunsRepository(
        runsLocalDataSource: sl(),
        runsRemoteDataSource: sl(),
        getUserId: sl(),
        networkInfo: sl(),
      ));
  sl.registerLazySingleton<ISearchResultsRepository>(
      () => SearchResultsRepository(
            searchResultsDataSource: sl(),
            networkInfo: sl(),
          ));
  sl.registerLazySingleton<IRunnerLocationRepository>(
      () => RunnerLocationRepository(
            firestore: sl(),
          ));
  sl.registerLazySingleton<IRouteRepository>(() => RouteRepository());

  // Data Sources
  sl.registerLazySingleton<IPlacesLocalDataSource>(() => PlacesLocalDataSource(
        placeDao: sl(),
        placePhotoDao: sl(),
      ));
  sl.registerLazySingleton<IPlacesRemoteDataSource>(
      () => PlacesRemoteDataSource(
            firestore: sl(),
            firebaseStorage: sl(),
            tempPhotosDir: sl(),
            cacheManager: sl(),
          ));
  sl.registerLazySingleton<IUserLocalDataSource>(() => UserLocalDataSource(
        userDao: sl(),
        userPhotoDao: sl(),
      ));
  sl.registerLazySingleton<IUserRemoteDataSource>(() => UserRemoteDataSource(
        firestore: sl(),
        firebaseAuth: sl(),
        tempPhotosDir: sl(),
        firebaseStorage: sl(),
      ));
  sl.registerLazySingleton<IRunsLocalDataSource>(() => RunsLocalDataSource(
        runDao: sl(),
      ));
  sl.registerLazySingleton<IRunsRemoteDataSource>(() => RunsRemoteDataSource(
        firestore: sl(),
        getUserId: sl(),
      ));
  sl.registerLazySingleton<ISearchResultsDataSource>(
      () => SearchResultsDataSource(
            firestore: sl(),
          ));

  // Data Access Objects
  sl.registerLazySingleton<IPlaceDao>(() => PlaceDao(
        database: sl(),
      ));
  sl.registerLazySingleton<IPlacePhotoDao>(() => PlacePhotoDao(
        photosDir: sl(),
      ));

  sl.registerLazySingleton<IUserDao>(() => UserDao(
        database: sl(),
      ));
  sl.registerLazySingleton<IUserPhotoDao>(() => UserPhotoDao(
        photosDir: sl(),
      ));
  sl.registerLazySingleton<IRunDao>(() => RunDao(
        database: sl(),
      ));

  // Local Dependencies
  final appDatabase = await AppDatabase.instance.database;
  sl.registerLazySingleton(() => appDatabase);

  final photosDir = await getApplicationDocumentsDirectory();
  sl.registerLazySingleton(() => photosDir);

  // External Dependencies
  sl.registerLazySingleton(() => FirebaseAuth.instance);
  sl.registerLazySingleton(() => GoogleSignIn());
  sl.registerLazySingleton(() => DataConnectionChecker());
  sl.registerLazySingleton(() => Firestore.instance);
  sl.registerLazySingleton(() => FirebaseStorage.instance);
  sl.registerLazySingleton(() => DefaultCacheManager());
  sl.registerLazySingleton(() => Geolocator());

  // Core
  sl.registerLazySingleton(() => Validators());
  sl.registerLazySingleton<INetworkInfo>(() => NetworkInfo(sl()));
}
