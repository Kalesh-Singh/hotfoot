import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hotfoot/features/navigation_screen/presentation/bloc/navigation_screen_bloc.dart';
import 'package:hotfoot/features/navigation_screen/presentation/bloc/navigation_screen_event.dart';
import 'package:hotfoot/features/runs/data/data_sources/runs_remote_data_source.dart';
import 'package:hotfoot/features/runs/data/models/run_model.dart';

class RequestRunScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final IRunsRemoteDataSource remoteDataSource =
        RunsRemoteDataSource(firestore: Firestore.instance);

    remoteDataSource.insertOrUpdateRun(
      runModel: RunModel(
        id: 'fakeId',
        order: 'fake order',
        destinationPlaceId: 'fake dest place id',
        customerId: 'fake customer id',
        runnerId: 'fake runner id',
        timePlaced: DateTime.now().toUtc(),
        timeDelivered: DateTime.now().toUtc(),
        cost: 0,
        status: 'Pending',
        pickupPlaceIdOrCustomPlace: Left('Fake pick up place id'),
      ),
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('Run Request'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () =>
              BlocProvider.of<NavigationScreenBloc>(context).add(EnteredHome()),
        ),
      ),
      body: WillPopScope(
        onWillPop: () {
          return Future.value(false);
        },
        child: SafeArea(
          child: ListView(
            padding: EdgeInsets.symmetric(horizontal: 15.0, vertical: 10.0),
            children: <Widget>[
              // Card placeholder for the store the user will be ordering from
              buildCard(
                  context,
                  PlaceModel('Chipotle\'s', 'Georgia Ave',
                      'https://patch.com/img/cdn20/users/714975/20170530/020320/styles/raw/public/article_images/20160256bb4a4a41646-1496163356-6008.jpg')),
              SizedBox(height: 15.0),
              TextField(
                autocorrect: true,
                decoration: InputDecoration(
                  labelText: 'What do you want?',
                  filled: true,
                ),
              ),
              SizedBox(
                height: 15.0,
              ),
              // On click of these buttons the suggested tip prompt in the text
              // bar will change value for the user to see, this will require
              // some form of state manipulation though
              Row(
                children: <Widget>[
                  RaisedButton(
                    onPressed: () {},
                    child: Text('5\%'),
                  ),
                  RaisedButton(
                    onPressed: () {},
                    child: Text('10\%'),
                  ),
                  RaisedButton(
                    onPressed: () {},
                    child: Text('20\%'),
                  )
                ],
              ),
              suggestedTip(context, 20.0),
              SizedBox(
                height: 45.0,
              ),
              submitButton(context),
            ],
          ),
        ),
      ),
    );
  }
}

class PlaceModel {
  String name;
  String address;
  String imageUrl;

  PlaceModel(this.name, this.address, this.imageUrl);
}

Widget buildCard(BuildContext context, PlaceModel place) {
  return Center(
    child: Card(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Image(
            image: NetworkImage(place.imageUrl),
            fit: BoxFit.fill,
            height: 250.0,
          ),
          ListTile(
            title: Text(
              place.name,
              style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
            ),
            subtitle: Text(place.address, style: TextStyle(fontSize: 12.0)),
          ),
        ],
      ),
    ),
  );
}

Widget suggestedTip(context, double cost) {
  // Suggested Tip should be 20% of purchase amount
  double tipValue = (cost * 20) / 100;
  return TextField(
    autocorrect: true,
    decoration: InputDecoration(
      labelText: 'Suggested Tip: \$' + tipValue.toString() + '0',
      filled: true,
    ),
  );
}

Widget submitButton(context) {
  return RaisedButton(
    onPressed: () {
      // Navigator.pushNamed(context, '/run_status');
      // TODO: (Use navigation_screen bloc to move to next screen)
    },
    child: Text('Place Run Request'),
    color: Colors.amber,
  );
}
