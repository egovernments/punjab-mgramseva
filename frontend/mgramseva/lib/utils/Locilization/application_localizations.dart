import 'dart:async';
import 'dart:convert';
import 'dart:html';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:mgramseva/model/localization/localization_label.dart';
import 'package:mgramseva/providers/common_provider.dart';
import 'package:mgramseva/services/LocalStorage.dart';
import 'package:mgramseva/utils/global_variables.dart';
import 'package:provider/provider.dart';

class ApplicationLocalizations {
  ApplicationLocalizations(this.locale);

  final Locale? locale;

  static ApplicationLocalizations of(BuildContext context) {
    return Localizations.of<ApplicationLocalizations>(
        context, ApplicationLocalizations)!;
  }

  late List<LocalizationLabel> _localizedStrings = [];

  Future<bool> load() async {
    print(locale);
    if (navigatorKey.currentContext == null) return false;
    var commonProvider = Provider.of<CommonProvider>(
        navigatorKey.currentContext!,
        listen: false);
    if (kIsWeb) {
      // var ress = window
      //     .localStorage['localisation_' + locale.toString().split('_')[0]];
      // print(jsonDecode(ress!)['key'].toString());
      // print(locale.toString());
      String? res = window
          .localStorage['localisation_' + locale.toString().split('_')[0]];
      if (res != null) {
        (jsonDecode(res)['key']).forEach((e) {
          _localizedStrings.add(LocalizationLabel.fromJson(e));
        });
        _localizedStrings.forEach((element) {
          print(element.code);
        });

        _localizedStrings = _localizedStrings;
        // _localizedStrings = _vaues;
      } else {
        _localizedStrings = await commonProvider.getLocalizationLabels();
        // _localizedStrings = [];
      }
    } else {
      String? res = await storage.read(key: locale.toString());
      if (res != null) {
        _localizedStrings = jsonDecode(res);
      } else {
        _localizedStrings = [];
      }
    }
    return true;
  }

  // called from every widget which needs a localized text
  translate(String _localizedValues) {
    if (_localizedStrings.length > 0) {
      var result = [];
      _localizedStrings.forEach((element) {
        result.add(element);
      });

      // var res = _localizedStrings
      //     .firstWhere(
      //       (medium) => medium.code == _localizedValues,
      //     )
      //     .message;
      // var res = result.firstWhere((medium) => medium.code == _localizedValues,
      //     orElse: () => null);
      // print((res));
      var rr = (result.firstWhere((medium) => medium.code == _localizedValues,
          orElse: () => null));
      if (rr != null) {
        return (rr.message);
      } else {
        return _localizedValues;
      }
      // return res == null ? _localizedValues : res['message'].toString();
    } else {
      return _localizedValues;
    }
  }

  static const LocalizationsDelegate<ApplicationLocalizations> delegate =
      _ApplicationLocalizationsDelegate();
}

class _ApplicationLocalizationsDelegate
    extends LocalizationsDelegate<ApplicationLocalizations> {
  const _ApplicationLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) {
    return ['en', 'pn', 'ar', 'hi'].contains(locale.languageCode);
  }

  @override
  Future<ApplicationLocalizations> load(Locale locale) async {
    ApplicationLocalizations localization =
        new ApplicationLocalizations(locale);
    await localization.load();
    return localization;
  }

  @override
  bool shouldReload(LocalizationsDelegate<ApplicationLocalizations> old) =>
      false;
}
