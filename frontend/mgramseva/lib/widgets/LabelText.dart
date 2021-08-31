import 'package:flutter/material.dart';
import 'package:mgramseva/utils/Locilization/application_localizations.dart';

class LabelText extends StatelessWidget {
  final input;
  LabelText(this.input);
  @override
  Widget build(BuildContext context) {
    return Align(
        alignment: Alignment.centerLeft,
        child: Container(
            child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            ApplicationLocalizations.of(context).translate(input),
            style: TextStyle(fontSize: 32, fontWeight: FontWeight.w700, fontFamily: 'Roboto Condensed', fontStyle: FontStyle.normal),
            textAlign: TextAlign.left,
          ),
        )));
  }
}
