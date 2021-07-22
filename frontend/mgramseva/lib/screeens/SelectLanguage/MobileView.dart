
import 'package:flutter/material.dart';
import 'package:mgramseva/models/language.dart';
import 'package:mgramseva/screeens/Login/Login.dart';
import 'package:mgramseva/widgets/BackgroundContainer.dart';
import 'package:mgramseva/widgets/Button.dart';
import 'package:mgramseva/widgets/LanguageCard.dart';

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
                  child:  Image(
                      width: 120,
                      image:NetworkImage(
                 stateInfo.logoUrl ?? '',
                 )),
                ),
                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                          for (var language in stateInfo.languages ?? [])
                           LanguageCard(language, stateInfo.languages ?? [], 4, 10, 10)
                        ]),
          Padding(padding:
                   EdgeInsets.all(15),child:    Button(
                      'CORE_COMMON_CONTINUE',
                      () => Navigator.push<bool>(
                          context,
                          MaterialPageRoute(
                              builder: (BuildContext context) => Login()))))
              ]))))))
    ]));
  }
}
