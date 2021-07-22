

import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:mgramseva/models/language.dart';
import 'package:mgramseva/services/MDMS.dart';

class LanguageProvider with ChangeNotifier {

  var streamController = StreamController.broadcast();

  dispose(){
    streamController.close();
    super.dispose();
  }


  Future<void> getLocalizationData() async {
    try {
      var value = await getMDMD();
      var localizationList = LanguageList.fromJson(json.decode(
          utf8.decode(value.bodyBytes)));
      if(localizationList.mdmsRes?.commonMasters?.stateInfo != null){
        localizationList.mdmsRes?.commonMasters?.stateInfo?.first.languages?.first.isSelected = true;
      }
      streamController.add(localizationList.mdmsRes?.commonMasters?.stateInfo ?? []);
    } catch(e){
      streamController.addError('error');
    }
  }

  void onSelectionOfLanguage(Languages language, List<Languages> languages) {
    if(language.isSelected) return;
    languages.forEach((element) => element.isSelected = false);
    language.isSelected = true;
    // getLocalizationData();
    notifyListeners();
  }

}