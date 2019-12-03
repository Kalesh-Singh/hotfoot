import 'package:flutter/material.dart';
import '../navigation/nav_bar.dart';
import '../blocs/navigation_bloc.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: null,
        automaticallyImplyLeading: false,
        title: Center(
          child: Text('Pending Request Screen'),
        ),
      ),
      body: buildRequestList(context),
      bottomNavigationBar: NavBar.build(),
    );
  }
}

class RequestModel {
  String from;
  String to;
  String who;
  String what;

  RequestModel(this.from, this.to, this.who, this.what);
}

Widget buildRequestList(BuildContext context) {
  List<Widget> requests = [];

  for (int i = 0; i < 30; i++) {
    requests.add(
      buildTile(
        context,
        RequestModel('McDonald\'s', 'West Towers', 'John Doe',
            'Crispy Buttermilk Sandwich Combo'),
      ),
    );
  }

  return ListView(children: requests);
}

Widget buildTile(BuildContext context, RequestModel place) {
  return Column(
    children: <Widget>[
      ListTile(
        title: Text(place.from),
        subtitle: Text(place.to),
        onTap: () {
          navBloc.changeNavigationIndex(Navigation.RUN);
        },
      ),
      Divider(),
    ],
  );
}
