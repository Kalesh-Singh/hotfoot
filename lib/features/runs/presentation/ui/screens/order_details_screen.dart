import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:hotfoot/features/location/data/repositories/location_repository_impl.dart';
import 'package:hotfoot/features/location/domain/repositories/location_repository.dart';
import 'package:hotfoot/features/navigation_screen/presentation/bloc/navigation_screen_bloc.dart';
import 'package:hotfoot/features/navigation_screen/presentation/bloc/navigation_screen_event.dart';
import 'package:hotfoot/features/runs/data/data_sources/runs_remote_data_source.dart';
import 'package:hotfoot/features/runs/data/models/run_model.dart';
import 'package:hotfoot/features/runs/data/repositories/runs_repositories_impl.dart';
import 'package:hotfoot/features/runs/domain/repositories/runs_repository.dart';
import 'package:hotfoot/features/user/data/data_sources/data_access_objects/user_dao.dart';
import 'package:hotfoot/features/user/data/data_sources/user_local_data_source.dart';
import 'package:hotfoot/features/user/data/data_sources/user_remote_data_source.dart';
import 'package:hotfoot/features/user/data/repositories/user_repositories_impl.dart';
import 'package:hotfoot/features/user/domain/repositories/user_repository.dart';
import 'package:hotfoot/features/user/domain/use_cases/get_user_id.dart';
import 'package:hotfoot/injection_container.dart';

class RequestRunScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final IUserRepository userRepository = UserRepository(
      networkInfo: sl(),
      userRemoteDataSource: UserRemoteDataSource(
        firebaseAuth: sl(),
        firestore: sl(),
      ),
      userLocalDataSource: UserLocalDataSource(
        userDao: UserDao(
          database: sl(),
        ),
      ),
    );
    final IRunsRemoteDataSource remoteDataSource = RunsRemoteDataSource(
      firestore: sl(),
      getUserId: GetUserId(userRepository: userRepository),
    );

//    remoteDataSource.insertOrUpdateRun(
//      runModel: RunModel(
//        id: null,
//        order: 'fake order',
//        destinationPlaceId: 'fake dest place id',
//        customerId: 'fake customer id',
//        runnerId: 'fake runner id',
//        timePlaced: DateTime.now().toUtc(),
//        timeDelivered: DateTime.now().toUtc(),
//        cost: 0,
//        status: 'Pending',
//        pickupPlaceIdOrCustomPlace: Left('Fake pick up place id'),
//      ),
//    );

    final runIds = remoteDataSource.getRunsIds();

    final ILocationRepository locationRepository = LocationRepository(
      geolocator: Geolocator(),
    );

    final addresses = locationRepository.getCurrentPlace();

    final places =
        locationRepository.getPlaceFromQuery(query: '14620 115th Ave');

    return Scaffold(
      appBar: AppBar(
        title: const Text('Order Details'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          // TODO: This has to account for going back to the pin
          // location screen too.
          onPressed: () =>
              BlocProvider.of<NavigationScreenBloc>(context).add(EnteredHome()),
        ),
      ),
      body: WillPopScope(
        onWillPop: () {
          return Future.value(false);
        },
        child: SafeArea(
          child: Container(),
          // TODO: Insert Body here
        ),
      ),
    );
  }
}
