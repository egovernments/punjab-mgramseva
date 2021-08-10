import 'package:flutter/material.dart';
import 'package:mgramseva/model/localization/language.dart';
import 'package:mgramseva/providers/language.dart';
import 'package:mgramseva/routers/Routers.dart';
import 'package:mgramseva/screeens/Login/Login.dart';
import 'package:mgramseva/utils/Constants/I18KeyConstants.dart';
import 'package:mgramseva/widgets/BackgroundContainer.dart';
import 'package:mgramseva/widgets/Button.dart';
import 'package:mgramseva/widgets/LanguageCard.dart';
import 'package:provider/provider.dart';

class LanguageSelectMobileView extends StatelessWidget {
  final StateInfo stateInfo;
  LanguageSelectMobileView(this.stateInfo);

  @override
  Widget build(BuildContext context) {
    return BackgroundContainer(new Stack(children: <Widget>[
      (new Positioned(
          bottom: 20.0,
          child: new Container(
              width: MediaQuery.of(context).size.width,
              padding: EdgeInsets.all(8),
              child: Card(
                  child: (Column(children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Image(
                      width: 200,
                      image: NetworkImage(
                        stateInfo.logoUrl ?? '',
                      )),
                ),
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
                            LanguageCard(
                                language, stateInfo.languages ?? [], 85, 10, 10)
                        ])),
                Padding(
                    padding: EdgeInsets.all(15),
                    child: Consumer<LanguageProvider>(
                      builder: (_, languageProvider, child) => Button(
                          i18.common.CONTINUE,
                          () => Navigator.pushNamed(context, Routes.LOGIN)),
                    ))
              ]))))))
    ]));
  }
}
