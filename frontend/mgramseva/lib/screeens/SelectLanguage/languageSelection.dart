import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:mgramseva/model/localization/language.dart';
import 'package:mgramseva/providers/language_provider.dart';
import 'package:mgramseva/screeens/SelectLanguage/DesktopView.dart';
import 'package:mgramseva/screeens/SelectLanguage/MobileView.dart';
import 'package:mgramseva/services/MDMS.dart';
import 'package:mgramseva/utils/loaders.dart';
import 'package:mgramseva/utils/notifyers.dart';
import 'package:provider/provider.dart';

// ignore: must_be_immutable
class SelectLanguage extends StatefulWidget {
  final Function changelanguage;
  SelectLanguage(this.changelanguage);
  @override
  State<StatefulWidget> createState() => _SelectLanguage();
}

class _SelectLanguage extends State<SelectLanguage> {
  @override
  void initState() {
    super.initState();
    var languageProvider =
        Provider.of<LanguageProvider>(context, listen: false);
    languageProvider.getLocalizationData();
  }

  @override
  Widget build(BuildContext context) {
    var languageProvider =
        Provider.of<LanguageProvider>(context, listen: false);

    return Scaffold(
        body: StreamBuilder(
            stream: languageProvider.streamController.stream,
            builder: (context, AsyncSnapshot snapshot) {
              if (snapshot.hasData) {
                return _buildView(snapshot.data);
              } else if (snapshot.hasError) {
                return Notifiers.networkErrorPage(context, () {});
              } else {
                switch (snapshot.connectionState) {
                  case ConnectionState.waiting:
                    return Loaders.CircularLoader();
                  case ConnectionState.active:
                    return Loaders.CircularLoader();
                  default:
                    return Container();
                }
              }
            }));
  }

  Widget _buildView(List<StateInfo> stateList) {
    return LayoutBuilder(builder: (context, constraints) {
      if (constraints.maxWidth < 760) {
        return LanguageSelectMobileView(stateList.first, widget.changelanguage);
      } else {
        return LanguageSelectionDesktopView(
            stateList.first, widget.changelanguage);
      }
    });
  }
}
