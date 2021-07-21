import 'package:flutter/material.dart';
import 'package:mgramseva/utils/Locilization/application_localizations.dart';

class SelectFieldBuilder extends StatelessWidget {
  final BuildContext context;
  final String labelText;
  final TextEditingController controller;
  final String input;
  final String prefixText;
  final Function widget;
  final List options;
  final bool isRequired;

  SelectFieldBuilder(this.context, this.labelText, this.controller, this.input,
      this.prefixText, this.widget, this.options, this.isRequired);

  @override
  Widget build(BuildContext context) {
// Label Text
    Widget textLabelwidget = Row(children: <Widget>[
      Text(ApplicationLocalizations.of(context).translate(labelText),
          textAlign: TextAlign.left,
          style: TextStyle(
              fontWeight: FontWeight.w400, fontSize: 19, color: Colors.black)),
      Text(isRequired ? '* ' : ' ',
          textAlign: TextAlign.left,
          style: TextStyle(
              fontWeight: FontWeight.w400, fontSize: 19, color: Colors.black)),
    ]);
    //DropDown
    Widget dropDown = DropdownButtonFormField(
      decoration: InputDecoration(
        prefixText: prefixText,
        prefixStyle: TextStyle(color: Colors.black),
        contentPadding:
            new EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(1.0)),
      ),
      items: options.map((value) {
        print(value);
        return DropdownMenuItem<String>(
          value: value['key'],
          child: new Text(value['label']),
        );
      }).toList(),
      onChanged: (_) {},
    );

    return LayoutBuilder(builder: (context, constraints) {
      if (constraints.maxWidth > 760) {
        return Container(
          margin:
              const EdgeInsets.only(top: 5.0, bottom: 5, right: 20, left: 20),
          child: Row(children: [
            Container(
                width: MediaQuery.of(context).size.width / 3,
                padding: EdgeInsets.only(top: 18, bottom: 3),
                child: textLabelwidget),
            Container(
                width: MediaQuery.of(context).size.width / 2.5,
                padding: EdgeInsets.only(top: 18, bottom: 3),
                child: dropDown),
          ]),
        );
      } else {
        return Container(
          margin:
              const EdgeInsets.only(top: 5.0, bottom: 5, right: 20, left: 20),
          child: Column(children: [
            Container(
                padding: EdgeInsets.only(top: 18, bottom: 3),
                child: textLabelwidget),
            dropDown,
          ]),
        );
      }
    });
  }
}
