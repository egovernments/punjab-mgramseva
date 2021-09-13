import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:mgramseva/utils/Locilization/application_localizations.dart';
import 'package:mgramseva/utils/common_widgets.dart';

class SelectFieldBuilder extends StatelessWidget {
  final String labelText;
  final dynamic value;
  final String input;
  final String prefixText;
  final Function(dynamic) widget;
  final List<dynamic> options;
  final bool isRequired;
  final String? hint;
  final bool? readOnly;
  final bool? isEnabled;
  final String? requiredMessage;
  final GlobalKey? contextkey;
  final TextEditingController? controller;

  SelectFieldBuilder(this.labelText, this.value, this.input, this.prefixText,
      this.widget, this.options, this.isRequired,
      {this.hint,
      this.isEnabled,
      this.readOnly,
      this.requiredMessage,
      this.contextkey,
      this.controller});

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

    Widget searchDropDown = TypeAheadFormField(
      key: contextkey,
      // autoFlipDirection: true,
      // suggestionsBoxDecoration:
      // SuggestionsBoxDecoration(constraints: BoxConstraints(minHeight: 200)),
      suggestionsBoxController: suggestionCtrl,
      textFieldConfiguration: TextFieldConfiguration(
          controller: controller,
          style: TextStyle(
              color: (isEnabled ?? true)
                  ? Theme.of(context).primaryColorDark
                  : Colors.grey,
              fontSize: 16),
          decoration: InputDecoration(
              suffixIcon: Icon(Icons.arrow_drop_down),
              border: OutlineInputBorder(borderRadius: BorderRadius.zero))),
      suggestionsCallback: (pattern) {
        print(pattern);
        // suggestionCtrl.open();
        print(suggestionCtrl);
        print(pattern);
        // suggestionCtrl.close();
        // suggestionCtrl.open();
        // suggestionCtrl.resize();
        return options.map((e) => e.value).toList();

        // if (pattern.trim().isEmpty) return options.map((e) => e.value).toList();
        // return options.map((e) => e.value).toList().where((e) {
        //   if ((e.toString().toLowerCase())
        //       .contains(pattern.toString().toLowerCase())) {
        //     return true;
        //   } else {
        //     return false;
        //   }
        // }).toList();
      },
      itemBuilder: (context, suggestion) {
        print("function called");
        return Ink(
            color: Colors.white,
            child: ListTile(
              tileColor: Colors.white,
              title: Text(ApplicationLocalizations.of(context)
                  .translate(suggestion.toString())),
            ));
      },
      onSuggestionSelected: (suggestion) {
        widget(suggestion);
        controller?.text = ApplicationLocalizations.of(context)
            .translate(suggestion.toString());
      },
      validator: isRequired == null || !isRequired
          ? null
          : (val) {
              if (val == null || val.trim().isEmpty) {
                return ApplicationLocalizations.of(context)
                    .translate(requiredMessage ?? '${labelText}_REQUIRED');
              } else if (options
                  .where((element) =>
                      element.value.toLowerCase() == val.trim().toLowerCase())
                  .toList()
                  .isEmpty)
                return ApplicationLocalizations.of(context)
                    .translate(requiredMessage ?? '${labelText}_invalid');
              else
                return null;
            },
    );

    return LayoutBuilder(builder: (context, constraints) {
      if (constraints.maxWidth > 760) {
        return Container(
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
                    searchDropDown,
                    CommonWidgets().buildHint(hint, context)
                  ],
                )),
          ]),
        );
      } else {
        return Container(
          margin: const EdgeInsets.only(top: 5.0, bottom: 5, right: 8, left: 8),
          child: Column(children: [
            Container(
                padding: EdgeInsets.only(top: 18, bottom: 3),
                child: new Align(
                    alignment: Alignment.centerLeft, child: textLabelwidget)),
            searchDropDown,
            CommonWidgets().buildHint(hint, context)
          ]),
        );
      }
    });
  }
}
