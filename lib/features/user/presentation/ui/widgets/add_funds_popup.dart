import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hotfoot/core/style/style.dart';
import 'dart:math' as math;

class AddFundsPopUp extends StatelessWidget {
  final TextEditingController _fundsController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: TextFormField(
        textInputAction: TextInputAction.next,
        controller: _fundsController,
        style: style.copyWith(fontSize: 16.0),
        decoration: InputDecoration(
          prefixIcon: Icon(Icons.attach_money),
          labelText: 'Add Hotfoot Funds',
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(5.0)),
        ),
        inputFormatters: [DecimalTextInputFormatter(decimalRange: 2)],
        keyboardType: TextInputType.numberWithOptions(decimal: true),
      ),
      actions: <Widget>[
        FlatButton(
            onPressed: () => Navigator.of(context).pop(_fundsController.text),
            child: Text('Add')),
        FlatButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('Cancel')),
      ],
    );
  }
}

class DecimalTextInputFormatter extends TextInputFormatter {
  DecimalTextInputFormatter({this.decimalRange})
      : assert(decimalRange == null || decimalRange > 0);

  final int decimalRange;

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue, // unused.
    TextEditingValue newValue,
  ) {
    TextSelection newSelection = newValue.selection;
    String truncated = newValue.text;

    if (decimalRange != null) {
      String value = newValue.text;

      if (value.contains(".") &&
          value.substring(value.indexOf(".") + 1).length > decimalRange) {
        truncated = oldValue.text;
        newSelection = oldValue.selection;
      } else if (value == ".") {
        truncated = "0.";

        newSelection = newValue.selection.copyWith(
          baseOffset: math.min(truncated.length, truncated.length + 1),
          extentOffset: math.min(truncated.length, truncated.length + 1),
        );
      }

      return TextEditingValue(
        text: truncated,
        selection: newSelection,
        composing: TextRange.empty,
      );
    }
    return newValue;
  }
}
