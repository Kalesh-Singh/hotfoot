import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hotfoot/features/navigation_screen/presentation/bloc/navigation_screen_bloc.dart';
import 'package:hotfoot/features/navigation_screen/presentation/bloc/navigation_screen_event.dart';

import 'bottom_nav_bar.dart';

class HomeTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: Center(
            child: Text('Popular Near You'),
          ),
          actions: <Widget>[
            Padding(
                padding: EdgeInsets.only(right: 20.0),
                child: GestureDetector(
                  onTap: () {
                    BlocProvider.of<NavigationScreenBloc>(context)
                        .add(EnteredSettings());
                  },
                  child: Icon(
                    Icons.settings,
                    size: 26.0,
                  ),
                )),
          ],
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
        bottomNavigationBar: BottomNavBar(),
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
    // Commented this because this image is returning a 404 error which crashes the app
    // PlaceModel('McDonalds', 'Georgia Ave',
    //     'https://timedotcom.files.wordpress.com/2014/10/mcdonalds-sign.jpg'),
    PlaceModel('Howard China', 'Georgia Ave',
        'https://s3-media1.fl.yelpcdn.com/bphoto/0eMSmEGQZ9bw0kvAV-cGkQ/348s.jpg'),
    PlaceModel('Chipotle', 'Georgia Ave',
        'https://patch.com/img/cdn20/users/714975/20170530/020320/styles/raw/public/article_images/20160256bb4a4a41646-1496163356-6008.jpg'),
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
              BlocProvider.of<NavigationScreenBloc>(context)
                  .add(EnteredPurchaseFlow());
            },
          ),
        ],
      ),
    ),
  );
}
