import 'package:flutter/material.dart';
import 'package:mgramseva/providers/language.dart';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:mgramseva/model/localization/localization_label.dart';

import 'package:mgramseva/repository/core_repo.dart';
import 'package:mgramseva/services/LocalStorage.dart';
import 'package:mgramseva/services/RequestInfo.dart';
import 'package:mgramseva/utils/global_variables.dart';
import 'package:provider/provider.dart';
import 'package:flutter/foundation.dart';
import 'package:universal_html/html.dart';

class CommonProvider with ChangeNotifier {

  List<LocalizationLabel> localizedStrings = <LocalizationLabel>[];


  Future<List<LocalizationLabel>> getLocalizationLabels() async {
    var languageProvider = Provider.of<LanguageProvider>(navigatorKey.currentContext!, listen: false);
    List<LocalizationLabel> labels = <LocalizationLabel>[];
    try{
      var requestInfo = RequestInfo('Rainmaker', .01, "", "_search", 1, "", "", "");

      var query = {
        'module' : 'mgramseva-common',
        'locale' : languageProvider.selectedLanguage.value,
        'tenantId' : 'pb'
      };

      var response = await CoreRepository().getLocilisation(query, requestInfo);
      if(response != null){
        labels = localizedStrings = response;
        setLocalizationLabels(response);
      }
    } catch(e) {
      print(e);
    }
    return labels;
  }

  setLocalizationLabels(List<LocalizationLabel> labels) async {
    var languageProvider = Provider.of<LanguageProvider>(navigatorKey.currentContext!, listen: false);


    try {
      // var jsonData = labels.map<LocalizationLabel>((e) => e?.toJson()).toList();
      if (kIsWeb) {
        window.localStorage[languageProvider.selectedLanguage.value!] = 'null';
      } else {
        await storage.write(
            key: languageProvider.selectedLanguage.value!, value: '');
      }
    }catch(e) {

    }
  }
}
