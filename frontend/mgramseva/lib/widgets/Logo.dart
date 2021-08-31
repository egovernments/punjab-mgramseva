import 'package:flutter/material.dart';
import 'package:mgramseva/providers/language.dart';
import 'package:mgramseva/utils/Locilization/application_localizations.dart';
import 'package:mgramseva/widgets/LabelText.dart';
import 'package:mgramseva/widgets/SubLabel.dart';
import 'package:provider/provider.dart';

class Logo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var languageProvider =
        Provider.of<LanguageProvider>(context, listen: false);
    return Align(
        alignment: Alignment.centerLeft,
        child: Container(
            child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
                padding: const EdgeInsets.only(top: 15, bottom: 15),
                child: Center(
                  child: Image(
                      width: 150,
                      image: NetworkImage(
                        languageProvider.stateInfo!.logoUrl!,
                      )),
                )),
            Padding(
                padding: const EdgeInsets.only(left: 15), child: Text(" | ")),
            SubLabelText(
              ApplicationLocalizations.of(context)
                  .translate(languageProvider.stateInfo!.code!),
            )
          ],
        )));
  }
}
