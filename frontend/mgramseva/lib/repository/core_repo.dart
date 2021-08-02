import 'dart:convert';
import 'dart:io';
import 'package:mgramseva/model/localization/language.dart';
import 'package:mgramseva/model/localization/localization_label.dart';
import 'package:mgramseva/services/RequestInfo.dart';
import 'package:mgramseva/services/base_service.dart';
import 'package:mgramseva/services/urls.dart';
import 'package:mgramseva/utils/models.dart';

class CoreRepository extends BaseService {
  Future<List<LocalizationLabel>> getLocilisation(
      Map<String, dynamic> query) async {
    late List<LocalizationLabel> labelList;
    var res = await makeRequest(
        url: Url.LOCALIZATION,
        queryParameters: query,
        requestInfo: RequestInfo('Rainmaker', .01, "", "_search", 1, "", "", ""),
        method: RequestType.POST);
    if (res != null) {
      labelList = res['messages']
          .map<LocalizationLabel>((e) => LocalizationLabel.fromJson(e))
          .toList();
    }
    return labelList;
  }

  Future<LanguageList> getMdms(Map body) async {
    late LanguageList languageList;
    var res = await makeRequest(
        url: Url.MDMS, body: body, method: RequestType.POST, requestInfo: RequestInfo('mgramseva-common', .01, "", "_search", 1, "", "", ""));

    if (res != null) {
      languageList = LanguageList.fromJson(res);
    }
    return languageList;
  }
}
