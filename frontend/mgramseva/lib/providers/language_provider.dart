import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:mgramseva/model/localization/language.dart';

import 'package:mgramseva/providers/common_provider.dart';
import 'package:mgramseva/repository/core_repo.dart';
import 'package:mgramseva/services/MDMS.dart';
import 'package:mgramseva/services/RequestInfo.dart';
import 'package:mgramseva/utils/Locilization/application_localizations.dart';
import 'package:mgramseva/utils/global_variables.dart';
import 'package:provider/provider.dart';
import 'package:universal_html/html.dart';

class LanguageProvider with ChangeNotifier {
  var streamController = StreamController.broadcast();
  late Languages selectedLanguage;

  dispose() {
    streamController.close();
    super.dispose();
  }

  Future<void> getLocalizationData() async {
    var body = {
      "RequestInfo":
          RequestInfo('mgramseva', .01, "", "_search", 1, "", "", ""),
      ...initRequestBody({"tenantId": "pb"})
    };

    try {
      var localizationList = await CoreRepository().getStates(body);

      if (localizationList.mdmsRes?.commonMasters?.stateInfo != null) {
        localizationList.mdmsRes?.commonMasters?.stateInfo?.first.languages
            ?.first.isSelected = true;
        selectedLanguage = localizationList
                .mdmsRes?.commonMasters?.stateInfo?.first.languages?.first ??
            Languages();

        var commonProvider = Provider.of<CommonProvider>(
            navigatorKey.currentContext!,
            listen: false);

        // await ApplicationLocalizations(
        //         Locale(selectedLanguage.label!, selectedLanguage.value))
        //     .load();
      }
      streamController.add(
          localizationList.mdmsRes?.commonMasters?.stateInfo ?? <StateInfo>[]);
    } catch (e) {
      streamController.addError('error');
    }
  }

  void onSelectionOfLanguage(
      Languages language, List<Languages> languages, Function) async {
    print(language.isSelected);
    if (language.isSelected) return;
    languages.forEach((element) => element.isSelected = false);

    // getLocalizationData();
    language.isSelected = true;
    selectedLanguage = language;
    // (() => function(language.value)());
    notifyListeners();
    if (kIsWeb) {
      window.localStorage['SelectedLocal'] = language.value.toString();
    }
    Function(language.value.toString().split('_')[0]);
  }
}
