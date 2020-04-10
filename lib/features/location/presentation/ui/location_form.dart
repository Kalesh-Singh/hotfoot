import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hotfoot/features/location/presentation/bloc/location_bloc.dart';
import 'package:hotfoot/features/location/presentation/bloc/location_event.dart';
import 'package:hotfoot/features/location/presentation/bloc/location_state.dart';

class LocationForm extends StatefulWidget {
  State<LocationForm> createState() => _LocationFormState();
}

class _LocationFormState extends State<LocationForm> {
  final TextEditingController _addressController =
      TextEditingController(text: 'Loading ...');
  final FocusNode _addressFocus = FocusNode();

  LocationBloc _locationBloc;

  @override
  void initState() {
    super.initState();
    _locationBloc = BlocProvider.of<LocationBloc>(context);
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<LocationBloc, LocationState>(
      listener: (context, state) {
        if (state is CurrentPlaceLoadFailure ||
            state is QueriedPlaceLoadFailure) {
          String errMsg;
          if (state is CurrentPlaceLoadFailure) {
            errMsg = state.message;
          } else if (state is QueriedPlaceLoadFailure) {
            errMsg = state.message;
          }
          Scaffold.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              SnackBar(
                content: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [Text(errMsg), Icon(Icons.error)],
                ),
                backgroundColor: Colors.red,
              ),
            );
        }
      },
      child: BlocBuilder<LocationBloc, LocationState>(
        builder: (context, state) {
          if (state is CurrentPlaceLoadSuccess) {
            _addressController.text = state.placeModel.address;
          } else if (state is QueriedPlaceLoadSuccess) {
            _addressController.text = state.placeModel.address;
          }

          return Padding(
            padding: EdgeInsets.all(20.0),
            child: Form(
              child: TextFormField(
                onEditingComplete: () {
                  _onEditingComplete();
                },
                onFieldSubmitted: (_) {
                  _addressFocus.unfocus();
                  // Hide keyboard
                  FocusScope.of(context).requestFocus(FocusNode());
                  // TODO: Hide keyboard;
                },
                controller: _addressController,
                decoration: InputDecoration(
                  icon: Icon(Icons.location_on),
                  labelText: 'Delivery Location',
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10.0)),
                    borderSide: BorderSide(color: Colors.grey),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10.0)),
                    borderSide: BorderSide(color: Colors.grey),
                  ),
                ),
                keyboardType: TextInputType.emailAddress,
                autovalidate: true,
                autocorrect: false,
              ),
            ),
          );
        },
      ),
    );
  }

  @override
  void dispose() {
    _addressController.dispose();
    super.dispose();
  }

  void _onEditingComplete() {
    _locationBloc.add(PlaceQueried(query: _addressController.text));
  }
}
