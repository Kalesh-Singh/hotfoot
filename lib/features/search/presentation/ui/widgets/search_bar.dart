import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hotfoot/features/search/presentation/blocs/results_with_matching_address/results_with_matching_address_bloc.dart';
import 'package:hotfoot/features/search/presentation/blocs/search_bottom_drawer/drawer_contents/drawer_contents_bloc.dart';
import 'package:hotfoot/features/search/presentation/blocs/search_bottom_drawer/drawer_contents/drawer_contents_event.dart';
import 'package:hotfoot/features/search/presentation/blocs/search_map/search_map_bloc.dart';
import 'package:hotfoot/features/search/presentation/blocs/search_map/search_map_event.dart';
import 'package:hotfoot/features/search/presentation/ui/screens/search_handler_screen.dart';

class SearchBar extends StatelessWidget with PreferredSizeWidget {
  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 40,
      right: 15,
      left: 15,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5.0),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.grey,
              blurRadius: 1.0,
              offset: Offset(2.0, 2.0), // shadow direction: bottom right
            )
          ],
        ),
        child: Row(
          children: <Widget>[
            IconButton(
              splashColor: Colors.grey,
              icon: Icon(Icons.search),
            ),
            Expanded(
              child: TextField(
                cursorColor: Colors.black,
                keyboardType: TextInputType.text,
                textInputAction: TextInputAction.go,
                decoration: InputDecoration(
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(horizontal: 15),
                    hintText: "Enter the location address..."),
                onTap: () async {
                  final selectedPlaceId = await Navigator.push(context,
                      MaterialPageRoute(builder: (_) {
                    return BlocProvider.value(
                        value: BlocProvider.of<ResultsWithMatchingAddressBloc>(
                            context),
                        child: SearchHandlerScreen());
                  }));
                  if (selectedPlaceId != null) {
                    print("Place Id ($selectedPlaceId) returned from handler");
                    BlocProvider.of<SearchMapBloc>(context).add(
                        SearchItemSelectedForMap(placeId: selectedPlaceId));
                    BlocProvider.of<DrawerContentsBloc>(context).add(
                        SearchItemSelectedForDrawer(placeId: selectedPlaceId));
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}
