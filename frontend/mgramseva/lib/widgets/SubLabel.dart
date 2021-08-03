import 'package:flutter/material.dart';
import 'package:mgramseva/utils/Locilization/application_localizations.dart';

class SubLabelText extends StatelessWidget {
  final input;
  SubLabelText(this.input);
  @override
  Widget build(BuildContext context) {
    return Align(
        alignment: Alignment.centerLeft,
        child: Container(
            child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Text(
            ApplicationLocalizations.of(context).translate(input),
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
            textAlign: TextAlign.left,
          ),
        )));
  }
}
