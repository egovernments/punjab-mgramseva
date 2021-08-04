import 'package:flutter/material.dart';
import 'package:mgramseva/utils/Locilization/application_localizations.dart';
import 'package:mgramseva/utils/common_styles.dart';
import 'package:mgramseva/utils/common_widgets.dart';
import 'package:mgramseva/utils/models.dart';

class SelectFieldBuilder extends StatelessWidget {
  final String labelText;
  final dynamic value;
  final String input;
  final String prefixText;
  final Function(dynamic) widget;
  final List<DropdownMenuItem<Object>> options;
  final bool isRequired;
  final String? hint;

  SelectFieldBuilder(this.labelText, this.value, this.input, this.prefixText,
      this.widget, this.options, this.isRequired, {this.hint});

  @override
  Widget build(BuildContext context) {
// Label Text
    Widget textLabelwidget = Wrap(children: <Widget>[
      Text(ApplicationLocalizations.of(context).translate(labelText),
          textAlign: TextAlign.left,
          style: TextStyle(
              fontWeight: FontWeight.w400, fontSize: 19, color: Colors.black)),
      Visibility(
        visible: isRequired,
        child: Text('* ',
            textAlign: TextAlign.left,
            style: TextStyle(
                fontWeight: FontWeight.w400, fontSize: 19, color: Colors.black)),
      ),
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
      value: value,
      validator: (val) {
        if (isRequired != null && isRequired && val == null) {
          return ApplicationLocalizations.of(context)
              .translate(labelText + '_REQUIRED');
        }
        return null;
      },
      items: options,
      onChanged: (value) => widget(value),
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
                child: Column(
                  children: [
                    dropDown,
                    CommonWidgets().buildHint(hint)
                  ],
                )),
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
            CommonWidgets().buildHint(hint)
          ]),
        );
      }
    });
  }
}
