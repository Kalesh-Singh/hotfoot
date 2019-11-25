import 'package:flutter/material.dart';

class RequestRunScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Run Request'),
      ),
      body: SafeArea(
        child: ListView(
          padding: EdgeInsets.symmetric(horizontal: 15.0, vertical: 10.0),
          children: <Widget>[
            // Card placeholder for the store the user will be ordering from
            buildCard(context, PlaceModel('McDonald\'s', 'Georgia Ave', 'https://timedotcom.files.wordpress.com/2014/10/mcdonalds-sign.jpg')),
            SizedBox(height: 15.0),
            TextField(
              autocorrect: true,
              decoration: InputDecoration(
                labelText: 'What do you want?',
                filled: true,
              ),
            ),
            SizedBox(height: 15.0,),
            // On click of these buttons the suggested tip prompt in the text
            // bar will change value for the user to see, this will require
            // some form of state manipulation though
            Row(
              children: <Widget>
              [
                RaisedButton(
                  onPressed: () {
                  },
                child: Text('5\%'),
                ),
                RaisedButton(
                  onPressed: () {
                  },
                  child: Text('10\%'),
                ),
                RaisedButton(
                  onPressed: () {
                },
                child: Text('20\%'),
                )
              ],
            ),
            suggestedTip(context, 20.0),
            SizedBox(height: 45.0,),
            submitButton(context),
          ],
        )
      )
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
            title: Text(place.name, style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),),
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
      Navigator.pushNamed(context, '/run_status');
    },
    child: Text('Place Run Request'),
    color: Colors.amber,
  );
}
