import 'package:flutter/material.dart';
import 'package:mgramseva/utils/Locilization/application_localizations.dart';

class LabelText extends StatelessWidget {
  final input;
  LabelText(this.input);
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
    return Align(
        alignment: Alignment.centerLeft,
        child: Container(
            child: Padding(
          padding: constraints.maxWidth > 760 ? const EdgeInsets.all(20.0) : const EdgeInsets.all(8.0),
          child: Text(
            ApplicationLocalizations.of(context).translate(input),
            style: TextStyle(fontSize: 32, fontWeight: FontWeight.w700, fontFamily: 'Roboto Condensed', fontStyle: FontStyle.normal),
            textAlign: TextAlign.left,
          ),
        )));
  });
  }
}
