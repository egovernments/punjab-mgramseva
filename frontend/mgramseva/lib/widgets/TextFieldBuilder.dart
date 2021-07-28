import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mgramseva/utils/Locilization/application_localizations.dart';

class BuildTextField extends StatefulWidget {
  final String labelText;
  final TextEditingController controller;
  final bool isRequired;
  final String input;
  final String prefixText;
  final Function(String)? onChange;
  final Function(String)? onSubmit;
  final String pattern;
  final String message;
  final List<FilteringTextInputFormatter>? inputFormatter;
  final Function(String?)? validator;

  BuildTextField(this.labelText, this.controller,
      {this.input = '',
      this.prefixText = '',
      this.onChange,
      this.isRequired = false,
      this.onSubmit,
      this.pattern = '',
      this.message = '', this.inputFormatter, this.validator});
  @override
  State<StatefulWidget> createState() => _BuildTextField();
}

class _BuildTextField extends State<BuildTextField> {
  @override
  Widget build(BuildContext context) {
    // TextForm
    Widget textFormwidget = TextFormField(
        controller: widget.controller,
        keyboardType: TextInputType.name,
        inputFormatters: widget.inputFormatter,
        autofocus: false,
        validator: widget.validator != null ? (val) => widget.validator!(val) :  (value) {
          if (value!.isEmpty && widget.isRequired) {
            return ApplicationLocalizations.of(context)
                .translate(widget.labelText + '_REQUIRED');
          } else if (widget.pattern != '' && widget.isRequired) {
            return (new RegExp(widget.pattern).hasMatch(value))
                ? null
                : ApplicationLocalizations.of(context)
                    .translate(widget.message);
          }
          return null;
        },
        decoration: InputDecoration(
          prefixText: widget.prefixText,
          prefixStyle: TextStyle(color: Colors.black),
          contentPadding:
              new EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(1.0)),
        ),
        onChanged: widget.onChange);
// Label Text
    Widget textLabelwidget = Row(children: <Widget>[
      Text(ApplicationLocalizations.of(context).translate(widget.labelText),
          textAlign: TextAlign.left,
          style: TextStyle(
              fontWeight: FontWeight.w400, fontSize: 19, color: Colors.black)),
      Text(widget.isRequired ? '* ' : ' ',
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
