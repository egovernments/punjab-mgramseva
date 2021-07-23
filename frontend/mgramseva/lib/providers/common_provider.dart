import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:mgramseva/model/localization/localization_label.dart';
import 'package:mgramseva/providers/language_provider.dart';

import 'package:mgramseva/repository/core_repo.dart';
import 'package:mgramseva/services/LocalStorage.dart';
import 'package:mgramseva/services/RequestInfo.dart';
import 'package:mgramseva/utils/global_variables.dart';
import 'package:provider/provider.dart';
import 'package:flutter/foundation.dart';
import 'package:universal_html/html.dart';

class CommonProvider with ChangeNotifier {
  Future<List<LocalizationLabel>> getLocalizationLabels() async {
    print("api call for localization");
    var languageProvider = Provider.of<LanguageProvider>(
        navigatorKey.currentContext!,
        listen: false);
    try {
      var requestInfo =
          RequestInfo('Rainmaker', .01, "", "_search", 1, "", "", "");

      var query = {
        'module': 'mgramseva-common',
        'locale': languageProvider.selectedLanguage.value,
        'tenantId': 'pb'
      };

      var response = await CoreRepository().getLocilisation(query, requestInfo);
      if (response != null) {
        setLocalizationLabels(response, languageProvider.selectedLanguage);
      }
    } catch (e) {
      print(e);
    }
    return [];
  }

  setLocalizationLabels(List<LocalizationLabel> labels, input) async {
    print("valued is setting");
    var tem = [];
    labels.forEach((e) => tem.add(e.toJson()));
    var items = {"key": tem};
    try {
      // var jsonData = labels.map<LocalizationLabel>((e) => e?.toJson()).toList();
      if (kIsWeb) {
        window.localStorage['localisation_' +
            input.value.toString().split('_')[0]] = json.encode(items);
      } else {
        await storage.write(
            key: 'localisation_' + input.value.toString().split('_')[0],
            value: json.encode(items));
      }
    } catch (e) {}
  }
}
