import 'package:flutter/material.dart';
import 'package:mgramseva/model/localization/language.dart';
import 'package:mgramseva/providers/language.dart';
import 'package:mgramseva/routers/Routers.dart';
import 'package:mgramseva/utils/Constants/I18KeyConstants.dart';
import 'package:mgramseva/utils/Locilization/application_localizations.dart';
import 'package:mgramseva/utils/TestingKeys/testing_keys.dart';
import 'package:mgramseva/widgets/BackgroundContainer.dart';
import 'package:mgramseva/widgets/Button.dart';
import 'package:mgramseva/widgets/LanguageCard.dart';
import 'package:mgramseva/widgets/footerBanner.dart';
import 'package:provider/provider.dart';

class LanguageSelectMobileView extends StatelessWidget {
  final StateInfo stateInfo;
  LanguageSelectMobileView(this.stateInfo);

  @override
  Widget build(BuildContext context) {
    return BackgroundContainer(new Stack(children: <Widget>[
      (new Positioned(
          bottom: 35.0,
          child: new Container(
              width: MediaQuery.of(context).size.width,
              padding: EdgeInsets.all(8),
              child: Card(
                  child: (Column(children: [
                    Container(
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Image(
                                    width: 150,
                                    image: NetworkImage(
                                      stateInfo.logoUrl ?? '',
                                    )),
                              ),
                              Padding(
                                  padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                                  child: Text(
                                    " | ",
                                    style: TextStyle(
                                        fontSize: 19,
                                        color: Color.fromRGBO(0, 0, 0, 1)),
                                  )),
                              Padding(
                                  padding: const EdgeInsets.only(left: 8.0),
                                  child: Text(
                                    ApplicationLocalizations.of(context)
                                        .translate(stateInfo.code!),
                                    style: TextStyle(
                                        fontSize: 19,
                                        color: Color.fromRGBO(0, 0, 0, 1),
                                        fontWeight: FontWeight.w400),
                                  )),
                            ])),
                    Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              for (Languages language in stateInfo.languages ?? [])
                                Row(
                                  children: [
                                    stateInfo.languages!.first == language
                                        ? Container(
                                        padding: EdgeInsets.only(
                                            left: 15, right: 15),
                                        margin: EdgeInsets.all(5),
                                        child: Text('${language.label}'))
                                        : Container(
                                        padding: EdgeInsets.only(
                                            left: 15, right: 15),
                                        decoration: BoxDecoration(
                                            border: Border(
                                                left: BorderSide(width: 1.0))),
                                        child: Text('${language.label}')),
                                  ],
                                )
                            ])),
                    Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              for (var language in stateInfo.languages ?? [])
                                LanguageCard(
                                    language, stateInfo.languages ?? [], 85, 10, 10)
                            ])),
                    Padding(
                        padding: EdgeInsets.all(15),
                        child: Consumer<LanguageProvider>(
                          builder: (_, languageProvider, child) => Button(
                            i18.common.CONTINUE,
                                () => Navigator.pushNamed(context, Routes.LOGIN),
                            key: Keys.language.LANGUAGE_PAGE_CONTINUE_BTN,),
                        ))
                  ])))))),
      (new Positioned(
          bottom: 0.0,
          left: MediaQuery.of(context).size.width / 4,
          child: FooterBanner()))
    ]));
  }
}