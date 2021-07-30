import 'dart:async';

import 'package:flutter/material.dart';
import 'package:mgramseva/model/localization/language.dart';
import 'package:mgramseva/model/user/user_details.dart';
import 'package:mgramseva/providers/language.dart';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:mgramseva/model/localization/localization_label.dart';

import 'package:mgramseva/repository/core_repo.dart';
import 'package:mgramseva/routers/Routers.dart';
import 'package:mgramseva/services/LocalStorage.dart';
import 'package:mgramseva/services/RequestInfo.dart';
import 'package:mgramseva/utils/constants.dart';
import 'package:mgramseva/utils/global_variables.dart';
import 'package:mgramseva/utils/models.dart';
import 'package:mgramseva/utils/notifyers.dart';
import 'package:provider/provider.dart';
import 'package:flutter/foundation.dart';
import 'package:universal_html/html.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

class CommonProvider with ChangeNotifier {

  List<LocalizationLabel> localizedStrings = <LocalizationLabel>[];
  var userLoggedStreamCtrl = StreamController.broadcast();
  UserDetails? userDetails;

  dispose() {
    userLoggedStreamCtrl.close();
    super.dispose();
  }

  Future<List<LocalizationLabel>> getLocalizationLabels() async {
    var languageProvider = Provider.of<LanguageProvider>(navigatorKey.currentContext!, listen: false);
    List<LocalizationLabel> labels = <LocalizationLabel>[];

    dynamic localLabelResponse;
    if(kIsWeb){
      localLabelResponse = window.localStorage[languageProvider.selectedLanguage?.value ?? ''];
    }else{
      localLabelResponse = await storage.read(
          key: languageProvider.selectedLanguage?.value ?? '');
    }

    if(localLabelResponse != null && localLabelResponse.trim().isNotEmpty){
      return localizedStrings = jsonDecode(localLabelResponse).map<LocalizationLabel>((e) => LocalizationLabel.fromJson(e)).toList();
    }

    try{

      var query = {
        'module' : 'mgramseva-common',
        'locale' : languageProvider.selectedLanguage?.value ?? '',
        'tenantId' : 'pb'
      };

      var response = await CoreRepository().getLocilisation(query);
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
      if (kIsWeb) {
        window.localStorage[languageProvider.selectedLanguage?.value ?? ''] = jsonEncode(labels.map((e) => e.toJson()).toList());
      } else {
        await storage.write(
            key: languageProvider.selectedLanguage?.value ?? '', value: jsonEncode(labels.map((e) => e.toJson()).toList()));
      }
    }catch(e) {
     Notifiers.getToastMessage('Unable to store the details');
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
    var languageProvider = Provider.of<LanguageProvider>(navigatorKey.currentContext!, listen: false);
    dynamic loginResponse;
    dynamic stateResponse;
    try {
      if(kIsWeb){
        loginResponse = window.localStorage[Constants.LOGIN_KEY];
        stateResponse = window.localStorage[Constants.STATES_KEY];
      }else {
        loginResponse = await storage.read(
            key: Constants.LOGIN_KEY);
        stateResponse = await storage.read(
            key: Constants.STATES_KEY);
      }

      if(stateResponse != null && stateResponse.trim().isNotEmpty){
        languageProvider.stateInfo = StateInfo.fromJson(jsonDecode(stateResponse));
      }

      if(loginResponse != null && loginResponse.trim().isNotEmpty){
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
    navigatorKey.currentState?.pushNamedAndRemoveUntil(Routes.LOGIN, (route) => false);
  }

  String? getMdmsId(LanguageList? mdms, String code, MDMSType mdmsType){
    try {
      switch (mdmsType) {
        case MDMSType.BusinessService:
          return mdms?.mdmsRes?.billingService?.businessServiceList?.firstWhere((e) => e.businessService == code).code;
        case MDMSType.ConsumerType:
          return mdms?.mdmsRes?.billingService?.businessServiceList?.firstWhere((e) => e.businessService == code).code;
        case MDMSType.TaxHeadCode:
          return mdms?.mdmsRes?.billingService?.taxHeadMasterList?.firstWhere((e) => e.service == code).code;
        default :
          return '';
      }
    }catch(e){
      return '';
    }
  }
}
