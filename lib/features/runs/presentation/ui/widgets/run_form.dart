import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hotfoot/features/places/domain/entities/place_entity.dart';
import 'package:hotfoot/features/runs/presentation/blocs/current_run/current_run_bloc.dart';
import 'package:hotfoot/features/runs/presentation/ui/widgets/place_name.dart';
import 'package:hotfoot/features/runs/presentation/ui/widgets/place_run_button.dart';
import 'package:hotfoot/features/runs/presentation/ui/widgets/run_photo.dart';

class RunForm extends StatefulWidget {
  final PlaceEntity placeEntity;

  const RunForm({Key key, @required this.placeEntity}) : super(key: key);

  State<RunForm> createState() => _RunFormState();
}

class _RunFormState extends State<RunForm> {
  final TextEditingController _orderController = TextEditingController();
  final FocusNode _orderFocus = FocusNode();

  CurrentRunBloc _currentRunBloc;

  @override
  void initState() {
    super.initState();
    _currentRunBloc = BlocProvider.of<CurrentRunBloc>(context);
  }

  bool isPlaceRunEnabled() {
    return _orderController.text.isNotEmpty;
  }

  void _onFormSubmitted() {
    // TODO: Update run and navigate to new screen.
  }

  @override
  Widget build(BuildContext context) {
    final line = MediaQuery.of(context).size.height ~/ (4 * 16);
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Form(
        child: ListView(
          children: <Widget>[
            RunPhoto(placeEntity: this.widget.placeEntity),
            Center(child: PlaceName(name: this.widget.placeEntity.name)),
            TextFormField(
              maxLines: 5,
              minLines: 5,
              textInputAction: TextInputAction.done,
              focusNode: _orderFocus,
              onFieldSubmitted: (_) {
                _orderFocus.unfocus();
              },
              controller: _orderController,
              decoration: InputDecoration(
                labelText: 'What would you like to request',
                border: new OutlineInputBorder(
                  borderRadius: new BorderRadius.circular(25.0),
                  borderSide: new BorderSide(),
                ),
              ),
              autovalidate: true,
              autocorrect: false,
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 20),
              child: PlaceRunBotton(
                onPressed: isPlaceRunEnabled() ? _onFormSubmitted : null,
              ),
            ),
            SizedBox(
              height: MediaQuery.of(context).viewInsets.bottom,
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _orderController.dispose();
    super.dispose();
  }
}
