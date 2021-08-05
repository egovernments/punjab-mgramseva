import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:mgramseva/utils/Locilization/application_localizations.dart';

class MeterReading extends StatelessWidget {
  final label;
  final controller1;
  final controller2;
  final controller3;
  final controller4;
  final controller5;
  MeterReading(this.label, this.controller1, this.controller2, this.controller3, this.controller4, this.controller5);

  _getConatiner(constraints, context) {
    return [
      Container(
          width: constraints.maxWidth > 760
              ? MediaQuery.of(context).size.width / 3
              : MediaQuery.of(context).size.width,
          padding: EdgeInsets.only(top: 18, bottom: 3),
          child: new Align(
              alignment: Alignment.centerLeft,
              child: Text(ApplicationLocalizations.of(context).translate(label),
                  textAlign: TextAlign.left,
                  style: TextStyle(
                      fontWeight: FontWeight.w400,
                      fontSize: 19,
                      color: Colors.black)))),
      Container(
          width: constraints.maxWidth > 760
              ? MediaQuery.of(context).size.width / 2.5
              : MediaQuery.of(context).size.width,
          padding: EdgeInsets.only(top: 18, bottom: 3),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              MeterReadingDigitTextFieldBox(this.controller1, true, false),
              MeterReadingDigitTextFieldBox(this.controller2, false, false),
              MeterReadingDigitTextFieldBox(this.controller3, false, false),
              MeterReadingDigitTextFieldBox(this.controller4, false, false),
              MeterReadingDigitTextFieldBox(this.controller5, false, true),
            ],
          ))
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Material(
        color: Colors.transparent,
        child: LayoutBuilder(builder: (context, constraints) {
          return Container(
              margin: const EdgeInsets.only(
                  top: 5.0, bottom: 5, right: 20, left: 20),
              child: constraints.maxWidth > 760
                  ? Row(children: _getConatiner(constraints, context))
                  : Column(children: _getConatiner(constraints, context)));
        }));
  }
}

class MeterReadingDigitTextFieldBox extends StatelessWidget {
  final bool first;
  final bool last;
  final controller;
  const MeterReadingDigitTextFieldBox( this.controller, this.first, this.last) : super();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60,
      child: AspectRatio(
        aspectRatio: 0.9,
        child: TextFormField(
          controller: controller,
          autofocus: true,
          onChanged: (value) {
            if (value.length == 1 && last == false) {
              FocusScope.of(context).nextFocus();
            }
            if (value.length == 0 && first == false) {
              FocusScope.of(context).previousFocus();
            }
          },
          showCursor: true,
          readOnly: false,
          textAlign: TextAlign.center,
          keyboardType: TextInputType.number,
          maxLength: 1,
          inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'^[0-9]+$'))],
          decoration: InputDecoration(
            // contentPadding: EdgeInsets.all(0),
            counter: Offstage(),
            enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(width: 1),
                borderRadius: BorderRadius.circular(1)),
            focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(width: 1),
                borderRadius: BorderRadius.circular(1)),
            hintText: "",
            // hintStyle: MyStyles.hintTextStyle,
          ),
        ),
      ),
    );
  }
}
