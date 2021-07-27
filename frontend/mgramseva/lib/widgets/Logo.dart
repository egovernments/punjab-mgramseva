import 'package:flutter/material.dart';
import 'package:mgramseva/providers/language.dart';
import 'package:mgramseva/utils/Locilization/application_localizations.dart';
import 'package:provider/provider.dart';

class Logo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var languageProvider =
        Provider.of<LanguageProvider>(context, listen: false);
    return Align(
        alignment: Alignment.centerLeft,
        child: Container(
            child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: Center(
                  child: Image(
                      width: 150,
                      image: NetworkImage(
                        languageProvider.stateInfo!.logoUrl!,
                      )),
                ))));
  }
}
