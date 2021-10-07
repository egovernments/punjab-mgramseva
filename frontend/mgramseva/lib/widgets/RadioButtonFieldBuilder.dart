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
  final GlobalKey? contextkey;
  final Widget? secondaryBox;
  final String? refTextRadioBtn;

  RadioButtonFieldBuilder(this.context, this.labelText, this.controller,
      this.input, this.prefixText, this.isRequired, this.options, this.widget1,
      {this.isEnabled, this.contextkey, this.secondaryBox, this.refTextRadioBtn});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      if (constraints.maxWidth > 760) {
        return Container(
            key: contextkey,
            child: Row(children: [
              new Container(
                  width: MediaQuery.of(context).size.width / 3,
                  padding: EdgeInsets.only(top: 5.0, bottom: 5, right: 20, left: 20),
                  child: Align(
                      alignment: Alignment.centerLeft,
                      child: Row(children: <Widget>[
                        Text(
                            ApplicationLocalizations.of(context)
                                .translate(labelText),
                            textAlign: TextAlign.left,
                            style: TextStyle(
                                fontWeight: FontWeight.w400,
                                fontSize: 16,
                            color: Theme.of(context).primaryColorDark)),
                        Text(isRequired ? '*' : '',
                            textAlign: TextAlign.left,
                            style: TextStyle(
                                fontWeight: FontWeight.w400,
                                fontSize: 16,
                            color: Theme.of(context).primaryColorDark)),
                      ]))),
              Container(
                  width: MediaQuery.of(context).size.width / 2.5,
                  padding: EdgeInsets.only(bottom: 3, top: 18),
                  child: Column(
                      children: options.map(
                    (data) {
                      return new RadioListTile(
                        title: new Text(ApplicationLocalizations.of(context)
                            .translate(data.label)),
                        value: data.key,
                        groupValue: controller,
                        onChanged: (isEnabled ?? true) ? widget1 : null,
                        secondary: data.key == refTextRadioBtn ? Container( width: MediaQuery.of(context).size.width / 3.8,
                            child: secondaryBox ) : null,
                      );
                    },
                  ).toList())),
            ]));
      } else {
        return Container(
            margin:
            const EdgeInsets.only(top: 5.0, bottom: 5, right: 8, left: 8),
            key: contextkey,
            child: Column(children: [
              new Container(
                  padding: EdgeInsets.only(top: 18, bottom: 3),
                  child: Align(
                      alignment: Alignment.centerLeft,
                      child: Row(children: <Widget>[
                        Text(
                        ApplicationLocalizations.of(context)
                            .translate(labelText),
                        textAlign: TextAlign.left,
                        style: TextStyle(
                            fontWeight: FontWeight.w400, fontSize: 16,
                            color: Theme.of(context).primaryColorDark),
                      ),
                        Text(isRequired ? '*' : '',
                            textAlign: TextAlign.left,
                            style: TextStyle(
                                fontWeight: FontWeight.w400,
                                fontSize: 16,
                            color: Theme.of(context).primaryColorDark)),]))),
              Column(
                  children: options.map(
                (data) {
                  return new RadioListTile(
                    title: new Text(ApplicationLocalizations.of(context)
                        .translate(data.label)),
                    value: data.key,
                    groupValue: controller,
                    onChanged: (isEnabled ?? true) ? widget1 : null,
                    secondary: data.key == refTextRadioBtn ? Container( width: MediaQuery.of(context).size.width / 2.8,
                        child: secondaryBox ) : null,
                  );
                },
              ).toList()),
            ]));
      }
    });
  }
}


