import 'package:flutter/material.dart';
import 'package:mgramseva/Utils/Validators/Validators.dart';
import 'package:mgramseva/utils/Locilization/application_localizations.dart';

class BuildTextField extends StatefulWidget {
  final BuildContext context;
  final String labelText;
  final TextEditingController controller;
  final bool isRequired;
  final String input;
  final String prefixText;
  final Function widget;
  BuildTextField(this.context, this.labelText, this.controller, this.input,
      this.prefixText, this.widget, this.isRequired);

  @override
  State<StatefulWidget> createState() {
    return _BuildTextField(this.context, this.labelText, this.controller,
        this.input, this.prefixText, this.widget, this.isRequired);
  }
}

class _BuildTextField extends State<BuildTextField> {
  final BuildContext context;
  final String labelText;
  final TextEditingController controller;
  final bool isRequired;
  final String input;
  final String prefixText;
  final Function widget1;

  _BuildTextField(this.context, this.labelText, this.controller, this.input,
      this.prefixText, this.widget1, this.isRequired);

  @override
  Widget build(BuildContext context) {
    // TextForm
    Widget textFormwidget = TextFormField(
        controller: controller,
        keyboardType: TextInputType.name,
        autofocus: false,
        validator: (value) {
          return Validators.validate(value, labelText);
        },
        decoration: InputDecoration(
          prefixText: prefixText,
          prefixStyle: TextStyle(color: Colors.black),
          contentPadding:
              new EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(1.0)),
        ),
        onChanged: (String? value) {
          return widget1(value);
        });

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

    return LayoutBuilder(builder: (context, constraints) {
      if (constraints.maxWidth > 760) {
        return Container(
            margin:
                const EdgeInsets.only(top: 5.0, bottom: 5, right: 20, left: 20),
            child: Row(
              children: [
                Container(
                    width: MediaQuery.of(context).size.width / 3,
                    padding: EdgeInsets.only(top: 18, bottom: 3),
                    child: new Align(
                        alignment: Alignment.centerLeft,
                        child: textLabelwidget)),
                Container(
                    width: MediaQuery.of(context).size.width / 2.5,
                    padding: EdgeInsets.only(top: 18, bottom: 3),
                    child: textFormwidget),
              ],
            ));
      } else {
        return Container(
            margin:
                const EdgeInsets.only(top: 5.0, bottom: 5, right: 20, left: 20),
            child: Column(
              children: [
                Container(
                    padding: EdgeInsets.only(top: 18, bottom: 3),
                    child: new Align(
                        alignment: Alignment.centerLeft,
                        child: textLabelwidget)),
                textFormwidget,
              ],
            ));
      }
    });
  }
}
