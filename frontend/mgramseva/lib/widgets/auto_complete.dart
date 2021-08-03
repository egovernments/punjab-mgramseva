import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:mgramseva/utils/Locilization/application_localizations.dart';

class AutoCompleteView extends StatelessWidget {

  final String labelText;
  final bool? isRequired;
  final Future<List<dynamic>> Function(String) callBack;
  final TextEditingController controller;
  final Function(dynamic) onSuggestionSelected;
  final Widget Function(BuildContext, dynamic) listTile;
  final SuggestionsBoxController? suggestionsBoxController;

  const AutoCompleteView({Key? key, required this.labelText, required this.callBack, required this.onSuggestionSelected, required this.listTile, required this.controller, this.suggestionsBoxController, this.isRequired}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin:
      const EdgeInsets.only(top: 5.0, bottom: 5, right: 20, left: 20),
      child: Column(
        children : [
           Align(
              alignment: Alignment.centerLeft,
              child: Row(children: <Widget>[
                Text(ApplicationLocalizations.of(context).translate(labelText),
                    textAlign: TextAlign.left,
                    style: TextStyle(
                        fontWeight: FontWeight.w400, fontSize: 19, color: Colors.black)),
                Text((isRequired ?? false) ? '* ' : ' ',
                    textAlign: TextAlign.left,
                    style: TextStyle(
                        fontWeight: FontWeight.w400, fontSize: 19, color: Colors.black)),
              ])),
          TypeAheadFormField(
          textFieldConfiguration: TextFieldConfiguration(
              controller: controller,
              decoration: InputDecoration(
                  border: OutlineInputBorder()
              )
          ),
          hideOnEmpty: true,
          suggestionsBoxController: suggestionsBoxController,
          suggestionsCallback: (pattern) async {
            return await callBack(pattern);
          },
          itemBuilder: listTile,
          onSuggestionSelected: onSuggestionSelected,
          validator: isRequired == null || !isRequired! ? null :  (val){
            if(val == null || val!.trim().isEmpty){
              return '${labelText}_REQUIRED';
            }
            return null;
          },
        ),
    ]
      ),
    );
  }
}
