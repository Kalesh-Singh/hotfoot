import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hotfoot/features/places/domain/entities/place_entity.dart';
import 'package:hotfoot/features/search/presentation/blocs/search_bottom_drawer/search_bottom_drawer_bloc.dart';
import 'package:hotfoot/features/search/presentation/blocs/search_bottom_drawer/search_bottom_drawer_state.dart';

class SearchBottomDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SearchBottomDrawerBloc, SearchBottomDrawerState>(
      builder: (BuildContext context, SearchBottomDrawerState state) {
        if (state is SearchBottomDrawerLoaded) {
          return DrawerDetails(
              placePhoto: state.photo, placeEntity: state.placeEntity);
        } else {
          // TODO: Handle failure state.
          return Container();
        }
      },
    );
  }
}

class DrawerDetails extends StatelessWidget {
  final File placePhoto;
  final PlaceEntity placeEntity;

  const DrawerDetails({Key key, this.placePhoto, this.placeEntity})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final photoSize = placePhoto.lengthSync();
    print('PHOTO SIZE UI: $photoSize');
    final photoBytes = placePhoto.readAsBytesSync();

    return Container(
      padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
      height: 140,
      width: double.maxFinite,
      child: Card(
        elevation: 5,
        child: Row(
          children: <Widget>[
            Flexible(
                flex: 2,
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Image.memory(
                    photoBytes,
                    width: 140,
                    height: 140,
                    fit: BoxFit.fill,
                  ),
                )),
            Flexible(
              flex: 3,
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Expanded(child: Text(placeEntity.name)),
                    Expanded(child: Text(placeEntity.address)),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
