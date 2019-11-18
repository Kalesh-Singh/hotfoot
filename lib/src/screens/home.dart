import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          leading: null,
          automaticallyImplyLeading: false,
          title: Center(
            child: Text('Popular Near You'),
          ),
          bottom: TabBar(tabs: [
            Tab(
              icon: Icon(Icons.local_dining),
              text: 'Food',
            ),
            Tab(
              icon: Icon(Icons.shopping_basket),
              text: 'Grocery',
            ),
            Tab(
              icon: Icon(Icons.local_convenience_store),
              text: 'Misc',
            )
          ]),
        ),
        body: TabBarView(children: [
          buildNearbyFoodList(context),
          buildNearbyGroceryList(context),
          buildNearbyMiscList(context),
        ]),
        bottomNavigationBar: buildNavBar(),
      ),
    );
  }
}

Widget submitButton(context) {
  return RaisedButton(
    onPressed: () {
      Navigator.pushNamed(context, '/request_run');
    },
    child: Text('Request Run'),
  );
}

Widget profileButton(context) {
  return RaisedButton(
    onPressed: () {
      Navigator.pushNamed(context, '/profile');
    },
    child: Text('Profile'),
  );
}

class PlaceModel {
  String name;
  String address;
  String imageUrl;

  PlaceModel(this.name, this.address, this.imageUrl);
}

Widget buildNearbyGroceryList(BuildContext context) {
  List<PlaceModel> places = [
    PlaceModel('Walmart', 'H Street NW',
        'https://image.cnbcfm.com/api/v1/image/106065680-1565184423722gettyimages-458400477.jpeg'),
    PlaceModel('Target', 'Columbia Heights',
        'https://corporate.target.com/_media/TargetCorp/about/images/stores/Upcoming_stores_hero.jpg'),
    PlaceModel('Giants', 'Park Rd NW',
        'https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcSrfqK-1PMDXUS3qGGKK7cz7TFsjnvpmGOC4L4njyXxGfbH88XQ'),
  ];

  List<Widget> placesCards = [];
  for (int i = 0; i < places.length; i++) {
    placesCards.add(buildCard(context, places[i]));
  }

  return ListView(children: placesCards);
}

Widget buildNearbyFoodList(BuildContext context) {
  List<PlaceModel> places = [
    PlaceModel('McDonalds', 'Georgia Ave',
        'https://timedotcom.files.wordpress.com/2014/10/mcdonalds-sign.jpg'),
    PlaceModel('Howard China', 'Georgia Ave',
        'https://s3-media1.fl.yelpcdn.com/bphoto/0eMSmEGQZ9bw0kvAV-cGkQ/348s.jpg'),
    PlaceModel('Chipotle', 'Georgia Ave',
        'https://patch.com/img/cdn20/users/714975/20170530/020320/styles/raw/public/article_images/20160256bb4a4a41646-1496163356-6008.jpg?'),
  ];

  List<Widget> placesCards = [];
  for (int i = 0; i < places.length; i++) {
    placesCards.add(buildCard(context, places[i]));
  }

  return ListView(children: placesCards);
}

Widget buildNearbyMiscList(BuildContext context) {
  List<PlaceModel> places = [
    PlaceModel('The Information Lab (iLab)', 'Howard University',
        'https://pbs.twimg.com/profile_images/1110511069/ilabfront_400x400.png'),
    PlaceModel('Founders Library', 'Howard University',
        'https://www.afro.com/wp-content/uploads/2016/03/HowardUniversity.jpg'),
  ];

  List<Widget> placesCards = [];
  for (int i = 0; i < places.length; i++) {
    placesCards.add(buildCard(context, places[i]));
  }

  return ListView(children: placesCards);
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
            title: Text(place.name),
            subtitle: Text(place.address),
            onTap: () {
              Navigator.pushNamed(context, '/request_run');
            },
          ),
        ],
      ),
    ),
  );
}

Widget buildNavBar() {
  return BottomNavigationBar(
    items: const <BottomNavigationBarItem>[
      BottomNavigationBarItem(
        icon: Icon(Icons.home),
        title: Text('Home'),
      ),
      BottomNavigationBarItem(
        icon: Icon(Icons.directions_run),
        title: Text('Custom Run'),
      ),
      BottomNavigationBarItem(
        icon: Icon(Icons.account_circle),
        title: Text('Account'),
      ),
    ],
  );
}
