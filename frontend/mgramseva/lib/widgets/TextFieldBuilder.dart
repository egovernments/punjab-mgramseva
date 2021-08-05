import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mgramseva/utils/Locilization/application_localizations.dart';
import 'package:mgramseva/utils/common_widgets.dart';

class BuildTextField extends StatefulWidget {
  final String labelText;
  final TextEditingController controller;
  final bool isRequired;
  final String input;
  final String prefixText;
  final Function(String)? onChange;
  final Function(String)? onSubmit;
  final String? pattern;
  final String message;
  final List<FilteringTextInputFormatter>? inputFormatter;
  final Function(String?)? validator;
  final int? maxLength;
  final int? maxLines;
  final TextCapitalization? textCapitalization;
  final bool? obscureText;
  final TextInputType? textInputType;
  final bool? isDisabled;
  final bool? readOnly;
  final String? labelSuffix;
  final String? hint;

  BuildTextField(this.labelText, this.controller,
      {this.input = '',
      this.prefixText = '',
      this.onChange,
      this.isRequired = false,
      this.onSubmit,
      this.pattern = '',
      this.message = '', this.inputFormatter, this.validator, this.maxLength, this.maxLines, this.textCapitalization, this.obscureText, this.textInputType, this.isDisabled, this.readOnly, this.labelSuffix, this.hint});
  @override
  State<StatefulWidget> createState() => _BuildTextField();
}

class _BuildTextField extends State<BuildTextField> {
  @override
  Widget build(BuildContext context) {
    // TextForm
    Widget textFormwidget = TextFormField(
        controller: widget.controller,
        keyboardType: widget.textInputType ?? TextInputType.text,
        inputFormatters: widget.inputFormatter,
        autofocus: false,
        maxLength: widget.maxLength,
        maxLines: widget.maxLines,
        textCapitalization: widget.textCapitalization ?? TextCapitalization.none,
        obscureText: widget.obscureText ?? false,
        readOnly: widget.readOnly ?? false,
        validator: widget.validator != null ? (val) => widget.validator!(val) :  (value) {
          if (value!.trim().isEmpty && widget.isRequired) {
            return ApplicationLocalizations.of(context)
                .translate(widget.labelText + '_REQUIRED');
          } else if (widget.pattern != null && widget.pattern != '') {
            return (new RegExp(widget.pattern!).hasMatch(value))
                ? null
                : ApplicationLocalizations.of(context)
                    .translate(widget.message);
          }
          return null;
        },
        decoration: InputDecoration(
          errorMaxLines: 2,
          enabled: widget.isDisabled ?? true,
          fillColor:  widget.isDisabled != null && widget.isDisabled! ? Colors.grey : Colors.white,
          prefixText: widget.prefixText,
        ),
        onChanged: widget.onChange);
// Label Text
    Widget textLabelwidget = Wrap(
        direction: Axis.horizontal,
        children: <Widget>[
      Text('${ApplicationLocalizations.of(context).translate(widget.labelText)} ${widget.labelSuffix ?? ''}',
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
                    child: Column(children: [
                      textFormwidget,
                      CommonWidgets().buildHint(widget.hint)
                    ],)),
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
                CommonWidgets().buildHint(widget.hint)
              ],
            ));
      }
    });
  }
}
