import 'dart:async';

import 'package:flutter/material.dart';
import 'package:mgramseva/model/file/file_store.dart';
import 'package:mgramseva/model/localization/language.dart';
import 'package:mgramseva/model/user/user_details.dart';
import 'package:mgramseva/model/userProfile/user_profile.dart';
import 'package:mgramseva/providers/language.dart';
import 'dart:convert';
import 'package:mgramseva/model/localization/localization_label.dart';
import 'package:mgramseva/repository/core_repo.dart';
import 'package:mgramseva/routers/Routers.dart';
import 'package:mgramseva/services/LocalStorage.dart';
import 'package:mgramseva/utils/Locilization/application_localizations.dart';
import 'package:mgramseva/utils/constants.dart';
import 'package:mgramseva/utils/error_logging.dart';
import 'package:mgramseva/utils/global_variables.dart';
import 'package:mgramseva/utils/models.dart';
import 'package:mgramseva/utils/notifyers.dart';
import 'package:provider/provider.dart';
import 'package:flutter/foundation.dart';
import 'package:universal_html/html.dart' as html;
import 'package:universal_html/html.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:url_launcher/url_launcher.dart';

class CommonProvider with ChangeNotifier {
  List<LocalizationLabel> localizedStrings = <LocalizationLabel>[];
  var userLoggedStreamCtrl = StreamController.broadcast();
  UserDetails? userDetails;

  dispose() {
    userLoggedStreamCtrl.close();
    super.dispose();
  }

  Future<List<LocalizationLabel>> getLocalizationLabels() async {
    var languageProvider = Provider.of<LanguageProvider>(
        navigatorKey.currentContext!,
        listen: false);
    List<LocalizationLabel> labels = <LocalizationLabel>[];

    dynamic localLabelResponse;
    if (kIsWeb) {
      localLabelResponse =
          window.localStorage[languageProvider.selectedLanguage?.value ?? ''];
    } else {
      localLabelResponse = await storage.read(
          key: languageProvider.selectedLanguage?.value ?? '');
    }

    if (localLabelResponse != null && localLabelResponse.trim().isNotEmpty) {
      return localizedStrings = jsonDecode(localLabelResponse)
          .map<LocalizationLabel>((e) => LocalizationLabel.fromJson(e))
          .toList();
    }

    try {
      var query = {
        'module':
            'mgramseva-common,mgramseva-consumer,mgramseva-expenses,mgramseva-water-connection,mgramseva-bill,mgramseva-payments',
        'locale': languageProvider.selectedLanguage?.value ?? '',
        'tenantId': 'pb'
      };

      var response = await CoreRepository().getLocilisation(query);
      if (response != null) {
        labels = localizedStrings = response;
        setLocalizationLabels(response);
      }
    } catch (e) {
      print(e);
    }
    return labels;
  }

  setSelectedTenant(UserDetails? loginDetails) {
    if (kIsWeb) {
      window.localStorage[Constants.LOGIN_KEY] =
          loginDetails == null ? '' : jsonEncode(loginDetails.toJson());
    } else {
      storage.write(
          key: Constants.LOGIN_KEY,
          value:
              loginDetails == null ? null : jsonEncode(loginDetails.toJson()));
    }
  }

  setTenant(tenant) {
    userDetails!.selectedtenant = tenant;
    setSelectedState(userDetails!);
    notifyListeners();
  }

  void setSelectedState(UserDetails? loginDetails) {
    if (kIsWeb) {
      window.localStorage[Constants.LOGIN_KEY] =
          loginDetails == null ? '' : jsonEncode(loginDetails.toJson());
    } else {
      storage.write(
          key: Constants.LOGIN_KEY,
          value:
              loginDetails == null ? null : jsonEncode(loginDetails.toJson()));
    }
  }

  setLocalizationLabels(List<LocalizationLabel> labels) async {
    var languageProvider = Provider.of<LanguageProvider>(
        navigatorKey.currentContext!,
        listen: false);

    try {
      if (kIsWeb) {
        window.localStorage[languageProvider.selectedLanguage?.value ?? ''] =
            jsonEncode(labels.map((e) => e.toJson()).toList());
      } else {
        await storage.write(
            key: languageProvider.selectedLanguage?.value ?? '',
            value: jsonEncode(labels.map((e) => e.toJson()).toList()));
      }
    } catch (e) {
      Notifiers.getToastMessage(navigatorKey.currentState!.context,
          'Unable to store the details', 'ERROR');
    }
  }

  set loginCredentails(UserDetails? loginDetails) {
    userDetails = loginDetails;
    if (kIsWeb) {
      window.localStorage[Constants.LOGIN_KEY] =
          loginDetails == null ? '' : jsonEncode(loginDetails.toJson());
    } else {
      storage.write(
          key: Constants.LOGIN_KEY,
          value:
              loginDetails == null ? null : jsonEncode(loginDetails.toJson()));
    }
    notifyListeners();
  }

  set userProfile(UserProfile? profile) {
    if (kIsWeb) {
      window.localStorage[Constants.USER_PROFILE_KEY] =
          profile == null ? '' : jsonEncode(profile.toJson());
    } else {
      storage.write(
          key: Constants.USER_PROFILE_KEY,
          value: profile == null ? null : jsonEncode(profile.toJson()));
    }
    notifyListeners();
  }

  walkThroughCondition(bool? firstTime, String key) {
    if (kIsWeb) {
      window.localStorage[key] = firstTime.toString();
    } else {
      storage.write(key: key, value: firstTime.toString());
    }
    notifyListeners();
  }

  Future<String> getWalkThroughCheck(String key) async {
    var userReposne;
    try {
      if (kIsWeb) {
        userReposne = window.localStorage[key];
      } else {
        userReposne = (await storage.read(key: key));
      }
    } catch (e) {
      userLoggedStreamCtrl.add(null);
    }
    if (userReposne == null) {
      userReposne = 'false';
    }
    return userReposne;
  }

  Future<UserProfile> getUserProfile() async {
    var userReposne;
    try {
      if (kIsWeb) {
        userReposne = window.localStorage[Constants.USER_PROFILE_KEY];
      } else {
        userReposne = await storage.read(key: Constants.USER_PROFILE_KEY);
      }
    } catch (e) {
      userLoggedStreamCtrl.add(null);
    }
    return UserProfile.fromJson(jsonDecode(userReposne));
  }

  Future<void> getLoginCredentails() async {
    var languageProvider = Provider.of<LanguageProvider>(
        navigatorKey.currentContext!,
        listen: false);
    dynamic loginResponse;
    dynamic stateResponse;
    try {
      if (kIsWeb) {
        loginResponse = window.localStorage[Constants.LOGIN_KEY];

        stateResponse = window.localStorage[Constants.STATES_KEY];
      } else {
        loginResponse = await storage.read(key: Constants.LOGIN_KEY);
        stateResponse = await storage.read(key: Constants.STATES_KEY);
      }

      if (stateResponse != null && stateResponse.trim().isNotEmpty) {
        languageProvider.stateInfo =
            StateInfo.fromJson(jsonDecode(stateResponse));
      }

      if (loginResponse != null && loginResponse.trim().isNotEmpty) {
        var decodedResponse = UserDetails.fromJson(jsonDecode(loginResponse));
        userDetails = decodedResponse;
        userLoggedStreamCtrl.add(decodedResponse);
      } else {
        userLoggedStreamCtrl.add(null);
      }
    } catch (e) {
      userLoggedStreamCtrl.add(null);
    }
  }

  UserDetails? getWebLoginStatus() {
    var languageProvider = Provider.of<LanguageProvider>(
        navigatorKey.currentContext!,
        listen: false);

    dynamic loginResponse;
    dynamic stateResponse;

    loginResponse = window.localStorage[Constants.LOGIN_KEY];
    stateResponse = window.localStorage[Constants.STATES_KEY];

    if (stateResponse != null && stateResponse.trim().isNotEmpty) {
      languageProvider.stateInfo =
          StateInfo.fromJson(jsonDecode(stateResponse));

      if (languageProvider.stateInfo != null) {
        // languageProvider.stateInfo?.languages?.first.isSelected = true;
        ApplicationLocalizations(Locale(
                languageProvider.selectedLanguage?.label ?? '',
                languageProvider.selectedLanguage?.value))
            .load();
      }
    }

    if (loginResponse != null && loginResponse.trim().isNotEmpty) {
      var decodedResponse = UserDetails.fromJson(jsonDecode(loginResponse));
      userDetails = decodedResponse;
    }
    return userDetails;
  }

  void onLogout() {
    loginCredentails = null;
    navigatorKey.currentState
        ?.pushNamedAndRemoveUntil(Routes.LOGIN, (route) => false);
  }

  void onTapOfAttachment(FileStore store) async {
    print(store);
    if (store.url == null) return;

    if (kIsWeb) {
      html.AnchorElement anchorElement =
          new html.AnchorElement(href: store.url);
      anchorElement.href = store.url;
      anchorElement.target = "_blank";
      anchorElement.click();
    } else {
      await canLaunch(store.url!)
          ? launch(store.url!)
          : ErrorHandler.logError('failed to launch the url ${store.url}');
    }
  }

  void shareonwatsapp(FileStore store, mobileNumber) async {
    if (store.url == null) return;
    try {
      var res = await CoreRepository().urlShotner(store.url as String);
      print(res);
      if (kIsWeb) {
        html.AnchorElement anchorElement = new html.AnchorElement(
            href: "https://web.whatsapp.com/send?phone=+91$mobileNumber&text=" +
                res!);
        anchorElement.target = "_blank";
        anchorElement.click();
      } else {
        await canLaunch(res!)
            ? launch(res)
            : ErrorHandler.logError('failed to launch the url ${store.url}');
      }
    } catch (e, s) {
      ErrorHandler.logError(e.toString(), s);
    }
  }

  void getStoreFileDetails(fileStoreId, mode, mobileNumber) async {
    if (fileStoreId == null) return;
    try {
      var res = await CoreRepository().fetchFiles([fileStoreId!]);
      if (res != null) {
        if (mode == 'Share')
          shareonwatsapp(res.first, mobileNumber);
        else
          onTapOfAttachment(res.first);
      }
    } catch (e, s) {
      ErrorHandler.logError(e.toString(), s);
    }
  }

  void getFileFromPDFService(body, params, mobileNumber, mode) async {
    try {
      var res = await CoreRepository().getFileStorefromPdfService(body, params);
      print(res);
      getStoreFileDetails(res!.filestoreIds!.first, mode, mobileNumber);
    } catch (e, s) {
      ErrorHandler.logError(e.toString(), s);
    }
  }

  String? getMdmsId(LanguageList? mdms, String code, MDMSType mdmsType) {
    try {
      switch (mdmsType) {
        case MDMSType.BusinessService:
          return mdms?.mdmsRes?.billingService?.businessServiceList
              ?.firstWhere((e) => e.businessService == code)
              .code;
        case MDMSType.ConsumerType:
          return mdms?.mdmsRes?.billingService?.businessServiceList
              ?.firstWhere((e) => e.businessService == code)
              .code;
        case MDMSType.TaxHeadCode:
          return mdms?.mdmsRes?.billingService?.taxHeadMasterList
              ?.firstWhere((e) => e.service == code)
              .code;
        default:
          return '';
      }
    } catch (e) {
      return '';
    }
  }
}
