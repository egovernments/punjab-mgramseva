import 'dart:async';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_share_me/flutter_share_me.dart';
import 'package:mgramseva/model/bill/bill_payments.dart';
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
import 'package:mgramseva/utils/Constants/I18KeyConstants.dart';
import 'package:mgramseva/utils/Locilization/application_localizations.dart';
import 'package:mgramseva/utils/constants.dart';
import 'package:mgramseva/utils/date_formats.dart';
import 'package:mgramseva/utils/error_logging.dart';
import 'package:mgramseva/utils/global_variables.dart';
import 'package:mgramseva/utils/loaders.dart';
import 'package:mgramseva/utils/models.dart';
import 'package:mgramseva/utils/notifyers.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:flutter/foundation.dart';
import 'package:universal_html/html.dart' as html;
import 'package:universal_html/html.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:url_launcher/url_launcher.dart';
import 'package:pdf/widgets.dart' as pw;

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
            'mgramseva-common,mgramseva-consumer,mgramseva-expenses,mgramseva-water-connection,mgramseva-bill,mgramseva-payments,mgramseva-dashboard,mgramseva-feedback',
        'locale': languageProvider.selectedLanguage?.value ?? '',
        'tenantId': languageProvider.stateInfo!.code
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
    userDetails?.selectedtenant = tenant;
    setSelectedState(userDetails!);
    notifyListeners();
  }

  void setSelectedState(UserDetails? loginDetails) async {
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
    navigatorKey.currentState
        ?.pushNamedAndRemoveUntil(Routes.SELECT_LANGUAGE, (route) => false);
    loginCredentails = null;
  }

  void onTapOfAttachment(FileStore store, context) async {
    if (store.url == null) return;
    CoreRepository().fileDownload(context, store.url!);
  }

  void shareonwatsapp(FileStore store, mobileNumber, input) async {
    if (store.url == null) return;
    late html.AnchorElement anchorElement;
    try {
      var res = await CoreRepository().urlShotner(store.url as String);
      if (kIsWeb) {
        if (mobileNumber == null) {
          anchorElement = new html.AnchorElement(
              href: "https://wa.me/send?text=" +
                  input.toString().replaceFirst('{link}', res!));
        } else {
          anchorElement = new html.AnchorElement(
              href: "https://wa.me/+91$mobileNumber?text=" +
                  input.toString().replaceFirst('{link}', res!));
        }

        anchorElement.target = "_blank";
        anchorElement.click();
      } else {
        var link;
        if (mobileNumber == null) {
          final FlutterShareMe flutterShareMe = FlutterShareMe();
          flutterShareMe.shareToWhatsApp(
              msg: input.toString().replaceFirst('{link}', res!));
          return;
        } else {
          link = "https://wa.me/+91$mobileNumber?text=" +
              input.toString().replaceFirst('{link}', res!);
        }
        await canLaunch(link)
            ? launch(link)
            : ErrorHandler.logError('failed to launch the url ${link}');
      }
    } catch (e, s) {
      ErrorHandler.logError(e.toString(), s);
    }
  }

  void getStoreFileDetails(
      fileStoreId, mode, mobileNumber, context, link) async {
    if (fileStoreId == null) return;
    try {
      var res = await CoreRepository().fetchFiles([fileStoreId!]);
      if (res != null) {
        if (mode == 'Share') {
          shareonwatsapp(res.first, mobileNumber, link);
        } else
          onTapOfAttachment(res.first, context);
      }
    } catch (e, s) {
      ErrorHandler.logError(e.toString(), s);
    }
  }

  void getFileFromPDFPaymentService(
      body, params, mobileNumber, Payments payments, mode) async {
    try {
      var res = await CoreRepository().getFileStorefromPdfService(body, params);
      String link = (ApplicationLocalizations.of(navigatorKey.currentContext!)
          .translate(i18.common.SHARE_RECEIPT_LINK)
          .toString()
          .replaceFirst('{user}', payments.paidBy!)
          .replaceFirst('{Amount}', payments.totalAmountPaid.toString())
          .replaceFirst('{new consumer id}',
              payments.paymentDetails!.first.bill!.consumerCode.toString())
          .replaceFirst('{Amount}',
              (payments.totalDue! - payments.totalAmountPaid!).toString()));
      getStoreFileDetails(res!.filestoreIds!.first, mode, mobileNumber,
          navigatorKey.currentContext, link);
    } catch (e, s) {
      ErrorHandler.logError(e.toString(), s);
    }
  }

  void getFileFromPDFBillService(
    body,
    params,
    mobileNumber,
    bill,
    mode,
  ) async {
    try {
      var res = await CoreRepository().getFileStorefromPdfService(body, params);

      String link = (ApplicationLocalizations.of(navigatorKey.currentContext!)
          .translate(i18.common.SHARE_BILL_LINK)
          .toString()
          .replaceFirst('{user}', bill.payerName!.toString())
          .replaceFirst('{cycle}',
              '${DateFormats.getMonthWithDay(bill.billDetails?.first?.fromPeriod)} - ${DateFormats.getMonthWithDay(bill.billDetails?.first?.toPeriod)}')
          .replaceFirst('{new consumer id}', bill.consumerCode!.toString())
          .replaceFirst('{Amount}', bill.totalAmount.toString()));
      getStoreFileDetails(
        res!.filestoreIds!.first,
        mode,
        mobileNumber,
        navigatorKey.currentContext,
        link,
      );
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

  Future<void> sharePdfOnWhatsApp(BuildContext context, pw.Document pdf,
      String fileName, String localizedText,
      {bool isDownload = false}) async {
    try {
      if (isDownload && kIsWeb) {
        final blob = html.Blob([await pdf.save()]);
        final url = html.Url.createObjectUrlFromBlob(blob);
        final anchor = html.document.createElement('a') as html.AnchorElement
          ..href = url
          ..style.display = 'none'
          ..download = '$fileName.pdf';
        html.document.body?.children.add(anchor);
        anchor.click();
        html.document.body?.children.remove(anchor);
        html.Url.revokeObjectUrl(url);
      } else {
        /// Enable loader
        Loaders.showLoadingDialog(context, label: '');

        Uint8List data = await pdf.save();

        /// Uploading file to S3 bucket
        var file = CustomFile(data, fileName, 'pdf');
        var response = await CoreRepository()
            .uploadFiles(<CustomFile>[file], APIConstants.API_MODULE_NAME);

        if (response.isNotEmpty) {
          var commonProvider =
              Provider.of<CommonProvider>(context, listen: false);
          var res =
              await CoreRepository().fetchFiles([response.first.fileStoreId!]);
          if (res != null && res.isNotEmpty) {
            if (isDownload) {
              CoreRepository().fileDownload(context, res.first.url ?? '');
            } else {
              var url = res.first.url ?? '';
              if (url.contains(',')) {
                url = url.split(',').first;
              }
              response.first.url = url;

              commonProvider.shareonwatsapp(
                  response.first, null, localizedText);
            }
          }
        }
        navigatorKey.currentState?.pop();
      }
    } catch (e, s) {
      navigatorKey.currentState?.pop();
      ErrorHandler().allExceptionsHandler(context, e, s);
    }
  }

  Future<pw.Font> getPdfFontFamily() async {
    var language = Provider.of<LanguageProvider>(navigatorKey.currentContext!,
        listen: false);

    switch (language.selectedLanguage!.value) {
      case 'en_IN':
        return pw.Font.ttf(
            await rootBundle.load('assets/fonts/Roboto/Roboto-Regular.ttf'));
      case 'hi_IN':
        return pw.Font.ttf(
            await rootBundle.load('assets/fonts/Roboto/Hind-Regular.ttf'));
      default:
        return pw.Font.ttf(
            await rootBundle.load('assets/fonts/Roboto/punjabi.ttf'));
    }
  }
}
