import 'package:flutter/material.dart';
import 'package:hotfoot/src/utils/style.dart';

class PlaceName extends StatelessWidget {
  final String name;

  const PlaceName({Key key, this.name}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 16.0, bottom: 16.0),
      child: Text(
        name,
        style: style.copyWith(fontWeight: FontWeight.bold),
      ),
    );
  }
}
