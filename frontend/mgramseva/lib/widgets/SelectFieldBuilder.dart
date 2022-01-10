import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:mgramseva/providers/language.dart';
import 'package:mgramseva/utils/Locilization/application_localizations.dart';
import 'package:mgramseva/utils/common_widgets.dart';
import 'package:mgramseva/widgets/SearchSelectFieldBuilder.dart';
import 'package:provider/provider.dart';

class SelectFieldBuilder extends StatelessWidget {
  final String labelText;
  final dynamic value;
  final String input;
  final String prefixText;
  final Function(dynamic) widget;
  final List<DropdownMenuItem<Object>> options;
  final bool isRequired;
  final String? hint;
  final bool? readOnly;
  final bool? isEnabled;
  final String? requiredMessage;
  final GlobalKey? contextkey;
  final TextEditingController? controller;
  final Key? key;

  SelectFieldBuilder(this.labelText, this.value, this.input, this.prefixText,
      this.widget, this.options, this.isRequired,
      {this.hint,
      this.isEnabled,
      this.readOnly,
      this.requiredMessage,
      this.contextkey,
      this.controller, this.key});

  var suggestionCtrl = new SuggestionsBoxController();
  @override
  Widget build(BuildContext context) {
// Label Text
    Widget textLabelwidget =
        Wrap(direction: Axis.horizontal, children: <Widget>[
      Text(ApplicationLocalizations.of(context).translate(labelText),
          textAlign: TextAlign.left,
          style: TextStyle(
              fontWeight: FontWeight.w400,
              fontSize: 16,
              color: (isEnabled ?? true)
                  ? Theme.of(context).primaryColorDark
                  : Colors.grey)),
      Visibility(
        visible: isRequired,
        child: Text('* ',
            textAlign: TextAlign.left,
            style: TextStyle(
                fontWeight: FontWeight.w400,
                fontSize: 16,
                color: (isEnabled ?? true)
                    ? Theme.of(context).primaryColorDark
                    : Colors.grey)),
      ),
    ]);

    // //DropDown
    // Widget dropDown = DropdownButtonFormField(
    //   decoration: InputDecoration(
    //     prefixText: prefixText,
    //     prefixStyle: TextStyle(color: Theme.of(context).primaryColorDark),
    //     contentPadding:
    //         new EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
    //     border: OutlineInputBorder(borderRadius: BorderRadius.circular(1.0)),
    //   ),
    //   value: value,
    //   validator: (val) {
    //     if (isRequired != null && isRequired && val == null) {
    //       return ApplicationLocalizations.of(context)
    //           .translate(requiredMessage ?? '${labelText}_REQUIRED');
    //     }
    //     return null;
    //   },
    //   items: [],
    //   onChanged: !(isEnabled ?? true) || readOnly == true
    //       ? null
    //       : (value) => widget(value),
    // );

    return LayoutBuilder(builder: (context, constraints) {
      if (constraints.maxWidth > 760) {
        return Container(
          key: contextkey,
          margin:
              const EdgeInsets.only(top: 5.0, bottom: 5, right: 20, left: 20),
          child: Row(children: [
            Container(
                alignment: Alignment.centerLeft,
                width: MediaQuery.of(context).size.width / 3,
                padding: EdgeInsets.only(top: 18, bottom: 3),
                child: textLabelwidget),
            Container(
                width: MediaQuery.of(context).size.width / 2.5,
                padding: EdgeInsets.only(top: 18, bottom: 3),
                child: Column(
                  children: [
                    Consumer<LanguageProvider>(
                        builder: (_, consumerProvider, child) =>
                            SearchSelectField(
                                labelText,
                                options,
                                controller,
                                widget,
                                value,
                                isEnabled,
                                isRequired,
                                requiredMessage)),
                    CommonWidgets().buildHint(
                      hint,
                      context,
                    )
                  ],
                )),
          ]),
        );
      } else {
        return Container(
          key: contextkey,
          margin: const EdgeInsets.only(top: 5.0, bottom: 5, right: 8, left: 8),
          child: Column(children: [
            Container(
                padding: EdgeInsets.only(top: 18, bottom: 3),
                child: new Align(
                    alignment: Alignment.centerLeft, child: textLabelwidget)),
            Consumer<LanguageProvider>(builder: (_, consumerProvider, child) {
              return SearchSelectField(labelText, options, controller, widget,
                  value, isEnabled, isRequired, requiredMessage);
            }),
            CommonWidgets().buildHint(hint, context)
          ]),
        );
      }
    });
  }
}
