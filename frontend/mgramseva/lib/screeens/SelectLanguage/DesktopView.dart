import 'dart:math';

import 'package:flutter/material.dart';
import 'package:mgramseva/utils/Locilization/application_localizations.dart';
import 'package:mgramseva/widgets/BackgroundContainer.dart';
import 'package:mgramseva/widgets/Button.dart';
import 'package:mgramseva/widgets/LanguageCard.dart';
import 'package:mgramseva/widgets/ListLabelText.dart';

class LanguageSelectionDesktopView extends StatelessWidget {
  final data;
  final String isSelected;
  final Function widgetFun;
  LanguageSelectionDesktopView(this.data, this.isSelected, this.widgetFun);
  @override
  Widget build(BuildContext context) {
    return BackgroundContainer(Center(
        child: new Container(
            height: 340,
            width: 500,
            padding: EdgeInsets.all(15),
            child: Card(
                child: (Column(children: [
              Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image(
                          width: 150,
                          image: NetworkImage(
                            data?['logoUrl'],
                          )),
                      ListLabelText("|"),
                      ListLabelText("STATE_LABEL")
                    ],
                  )),
              Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        for (var language in data?['languages'])
                          Row(
                            children: [
                              Text(ApplicationLocalizations.of(context)
                                  .translate("LANGUAGE_" +
                                      language['value']
                                          .toString()
                                          .toUpperCase())),
                              Text("  |  ")
                            ],
                          )
                      ])),
              Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        for (var language in data?['languages'])
                          LanguageCard(
                              language['label'],
                              language['value'],
                              isSelected == language['value'],
                              this.widgetFun,
                              12,
                              10,
                              10)
                      ])),
              Padding(
                  padding: EdgeInsets.all(15),
                  child: Button('CORE_COMMON_CONTINUE',
                      () => Navigator.pushNamed(context, "login"))),
              SizedBox(
                height: 10,
              )
            ]))))));
  }
}
