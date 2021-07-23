import 'dart:math';

import 'package:flutter/material.dart';
import 'package:mgramseva/model/localization/language.dart';

import 'package:mgramseva/utils/Locilization/application_localizations.dart';
import 'package:mgramseva/widgets/BackgroundContainer.dart';
import 'package:mgramseva/widgets/Button.dart';
import 'package:mgramseva/widgets/LanguageCard.dart';
import 'package:mgramseva/widgets/ListLabelText.dart';

class LanguageSelectionDesktopView extends StatelessWidget {
  final StateInfo stateInfo;
  Function changeLanguage;
  LanguageSelectionDesktopView(this.stateInfo, this.changeLanguage);

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
                            stateInfo.logoUrl!,
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
                        for (Languages language in stateInfo.languages ?? [])
                          Row(
                            children: [
                              Text('${language.label}'),
                              Text("  |  ")
                            ],
                          )
                      ])),
              Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        for (var language in stateInfo.languages ?? [])
                          LanguageCard(language, stateInfo.languages ?? [], 12,
                              10, 10, changeLanguage)
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
