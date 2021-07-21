import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mgramseva/utils/Locilization/application_localizations.dart';

class BasicDateField extends StatelessWidget {
  final format = DateFormat("yyyy-MM-dd");
  final label;
  final isRequired;

  BasicDateField(this.label, this.isRequired);

  @override
  Widget build(BuildContext context) {
    Widget datePicker = DateTimeField(
      format: format,
      decoration: InputDecoration(
        prefixText: "",
        suffixIcon: Icon(Icons.calendar_today),
        prefixStyle: TextStyle(color: Colors.black),
        contentPadding:
            new EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(1.0)),
      ),
      onShowPicker: (context, currentValue) {
        return showDatePicker(
          context: context,
          firstDate: DateTime(1900),
          initialDate: currentValue ?? DateTime.now(),
          lastDate: DateTime(2100),
        );
      },
    );

    Widget textLabelwidget = Row(children: <Widget>[
      Text(ApplicationLocalizations.of(context).translate(label),
          textAlign: TextAlign.left,
          style: TextStyle(
              fontWeight: FontWeight.w400, fontSize: 19, color: Colors.black)),
      Text(isRequired ? '* ' : ' ',
          textAlign: TextAlign.left,
          style: TextStyle(
              fontWeight: FontWeight.w400, fontSize: 19, color: Colors.black)),
    ]);

    return LayoutBuilder(builder: (context, constraints) {
      if (constraints.maxWidth < 760) {
        return Container(
            margin:
                const EdgeInsets.only(top: 5.0, bottom: 5, right: 20, left: 20),
            child: Column(children: [
              Container(
                  padding: EdgeInsets.only(top: 18, bottom: 3),
                  child: new Align(
                      alignment: Alignment.centerLeft, child: textLabelwidget)),
              datePicker,
            ]));
      } else {
        return Container(
            margin: const EdgeInsets.only(
                top: 20.0, bottom: 5, right: 20, left: 20),
            child: Row(children: [
              Container(
                  padding: EdgeInsets.only(top: 18, bottom: 3),
                  width: MediaQuery.of(context).size.width / 3,
                  child: new Align(
                      alignment: Alignment.centerLeft, child: textLabelwidget)),
              Container(
                  width: MediaQuery.of(context).size.width / 2.5,
                  child: datePicker),
            ]));
      }
    });
  }
}
