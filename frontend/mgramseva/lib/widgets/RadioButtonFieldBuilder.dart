import 'package:flutter/material.dart';
import 'package:mgramseva/utils/Locilization/application_localizations.dart';
import 'package:mgramseva/utils/models.dart';

class RadioButtonFieldBuilder extends StatelessWidget {
  final BuildContext context;
  final String labelText;
  final dynamic? controller;
  final bool isRequired;

  final String input;
  final String prefixText;
  final List<KeyValue> options;
  final ValueChanged widget1;
  final bool? isEnabled;

  RadioButtonFieldBuilder(this.context, this.labelText, this.controller,
      this.input, this.prefixText, this.isRequired, this.options, this.widget1, {this.isEnabled});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      if (constraints.maxWidth > 760) {
        return Container(
            child: Row(children: [
          new Container(
              width: MediaQuery.of(context).size.width / 3,
              padding: EdgeInsets.only(left: 24, top: 10),
              child: Align(
                  alignment: Alignment.centerLeft,
                  child: Row(children: <Widget>[
                    Text(
                        ApplicationLocalizations.of(context)
                            .translate(labelText),
                        textAlign: TextAlign.left,
                        style: TextStyle(
                            fontWeight: FontWeight.w400,
                            fontSize: 19,
                            color: Colors.black)),
                    Text(isRequired ? '* ' : ' ',
                        textAlign: TextAlign.left,
                        style: TextStyle(
                            fontWeight: FontWeight.w400,
                            fontSize: 19,
                            color: Colors.black)),
                  ]))),
          Container(
              width: MediaQuery.of(context).size.width / 2.5,
              padding: EdgeInsets.only(left: 24, top: 10),
              child: Column(
                  children: options.map(
                (data) {
                  return new RadioListTile(
                    title: new Text(data.label),
                    value: data.key,
                    groupValue: controller,
                    onChanged: (isEnabled ?? true) ? widget1 : null,
                  );
                },
              ).toList())),
        ]));
      } else {
        return Container(
            child: Column(children: [
          new Container(
              padding: EdgeInsets.only(left: 24, top: 10),
              child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    ApplicationLocalizations.of(context).translate(labelText),
                    textAlign: TextAlign.left,
                    style: TextStyle(fontWeight: FontWeight.w400, fontSize: 16),
                  ))),
          Column(
              children: options.map(
            (data) {
              return new RadioListTile(
                title: new Text(data.label),
                value: data.key,
                groupValue: controller,
                onChanged: (isEnabled ?? true) ? widget1 : null,
              );
            },
          ).toList()),
        ]));
      }
    });
  }
}
