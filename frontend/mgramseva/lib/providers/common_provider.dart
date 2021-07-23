import 'dart:async';

import 'package:flutter/material.dart';
import 'package:mgramseva/model/user/user_details.dart';
import 'package:mgramseva/providers/language.dart';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:mgramseva/model/localization/localization_label.dart';

import 'package:mgramseva/repository/core_repo.dart';
import 'package:mgramseva/services/LocalStorage.dart';
import 'package:mgramseva/services/RequestInfo.dart';
import 'package:mgramseva/utils/constants.dart';
import 'package:mgramseva/utils/global_variables.dart';
import 'package:provider/provider.dart';
import 'package:flutter/foundation.dart';
import 'package:universal_html/html.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

class CommonProvider with ChangeNotifier {

  List<LocalizationLabel> localizedStrings = <LocalizationLabel>[];
  var userLoggedStreamCtrl = StreamController.broadcast();
  late UserDetails userDetails;

  dispose() {
    userLoggedStreamCtrl.close();
    super.dispose();
  }

  Future<List<LocalizationLabel>> getLocalizationLabels() async {
    var languageProvider = Provider.of<LanguageProvider>(navigatorKey.currentContext!, listen: false);
    List<LocalizationLabel> labels = <LocalizationLabel>[];
    try{
      var requestInfo = RequestInfo('Rainmaker', .01, "", "_search", 1, "", "", "");

      var query = {
        'module' : 'mgramseva-common',
        'locale' : languageProvider.selectedLanguage?.value ?? '',
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
        window.localStorage[languageProvider.selectedLanguage?.value ?? ''] = 'null';
      } else {
        await storage.write(
            key: languageProvider.selectedLanguage?.value ?? '', value: '');
      }
    }catch(e) {

    }
  }

  set loginCredentails(UserDetails? loginDetails) {

    if(kIsWeb){
     window.localStorage[Constants.LOGIN_KEY] = loginDetails == null ? '' : jsonEncode(loginDetails.toJson());
    }else{
      storage.write(
          key: Constants.LOGIN_KEY,
          value: loginDetails == null ? null : jsonEncode(loginDetails.toJson()));
    }
  }

  Future<void>  getLoginCredentails() async {
    dynamic loginResponse;

    try {
      if(kIsWeb){
        loginResponse = window.localStorage[Constants.LOGIN_KEY];
      }else {
        loginResponse = await storage.read(
            key: Constants.LOGIN_KEY);
      }

      if(loginResponse != null && loginResponse){
        var decodedResponse = UserDetails.fromJson(jsonDecode(loginResponse));
        userDetails = decodedResponse;
        userLoggedStreamCtrl.add(decodedResponse);
      }else{
        userLoggedStreamCtrl.add(null);
      }
    }catch(e) {
      userLoggedStreamCtrl.add(null);
    }
  }


  void onLogout() {
    loginCredentails = null;
  }
}
