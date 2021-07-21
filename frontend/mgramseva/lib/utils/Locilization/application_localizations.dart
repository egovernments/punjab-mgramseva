import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:mgramseva/services/Locilization.dart';
import 'package:universal_html/html.dart';

class ApplicationLocalizations {
  ApplicationLocalizations(this.locale);

  final Locale locale;

  static ApplicationLocalizations of(BuildContext context) {
    return Localizations.of<ApplicationLocalizations>(
        context, ApplicationLocalizations)!;
  }

  late List _localizedStrings;

  Future<bool> load() async {
    getLocilisation(locale.toString());
    if (kIsWeb) {
      String? res = window.localStorage['localisation_' + locale.toString()];
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
    var res = _localizedStrings.firstWhere(
        (medium) => medium['code'] == _localizedValues,
        orElse: () => null)?['message'];
    return res == null ? _localizedValues : res;
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
