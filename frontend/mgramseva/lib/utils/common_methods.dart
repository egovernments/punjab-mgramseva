import 'dart:io';
import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http_parser/http_parser.dart';
import 'package:mgramseva/model/mdms/tax_period.dart';
import 'package:mgramseva/providers/common_provider.dart';
import 'package:mgramseva/utils/error_logging.dart';
import 'package:mgramseva/utils/global_variables.dart';
import 'package:mime/mime.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import 'constants.dart';
import 'models.dart';

class CommonMethods {
  static home() {
    navigatorKey.currentState?.popUntil((route) => route.isFirst);
  }

  static String getExtension(String url) {
    return url.substring(0, url.indexOf('?')).split('/').last;
  }

  static List<DatePeriod> getPastMonthUntilFinancialYear(int year,
      {DateType? dateType}) {
    var monthList = <DateTime>[];
    if (DateTime.now().year == year && DateTime.now().month >= 4) {
      for (int i = 4; i <= DateTime.now().month; i++) {
        monthList.add(DateTime(DateTime.now().year, i));
      }
    } else {
      var yearDetails = DateTime(year);
      for (int i = 4; i <= 12; i++) {
        monthList.add(DateTime(yearDetails.year, i));
      }
      for (int i = 1;
          i <= (dateType == DateType.YTD ? DateTime.now().month : 3);
          i++) {
        monthList.add(DateTime(yearDetails.year + 1, i));
      }
    }
    return monthList
        .map((e) => DatePeriod(DateTime(e.year, e.month, 1),
            DateTime(e.year, e.month + 1, 0, 23, 59, 59, 999), DateType.MONTH))
        .toList()
        .reversed
        .toList();
  }

  static List<YearWithMonths> getFinancialYearList([int count = 5]) {
    var yearWithMonths = <YearWithMonths>[];

    if (DateTime.now().month >= 4) {
      var year = DatePeriod(
          DateTime(DateTime.now().year, 4),
          DateTime(DateTime.now().year + 1, 4, 0, 23, 59, 59, 999),
          DateType.YTD);
      var monthList = getPastMonthUntilFinancialYear(DateTime.now().year);
      yearWithMonths.add(YearWithMonths(monthList, year));
    } else {
      var year = DatePeriod(
          DateTime(DateTime.now().year - 1, 4), DateTime.now(), DateType.YTD);
      var monthList = getPastMonthUntilFinancialYear(year.startDate.year,
          dateType: DateType.YTD);
      yearWithMonths.add(YearWithMonths(monthList, year));
    }

    for (int i = 0; i < count - 1; i++) {
      var currentDate = DateTime.now();
      dynamic year = currentDate.month < 4
          ? DateTime(currentDate.year - (i + 1))
          : DateTime(currentDate.year - i);
      year = DatePeriod(DateTime(year.year - 1, 4),
          DateTime(year.year, 4, 0, 23, 59, 59, 999), DateType.YEAR);
      var monthList = getPastMonthUntilFinancialYear(year.startDate.year);
      yearWithMonths.add(YearWithMonths(monthList, year));
    }
    return yearWithMonths;
  }

  static List<DatePeriod> getMonthsOfFinancialYear() {
    var monthList = <DateTime>[];
    if (DateTime.now().month >= 4) {
      for (int i = 4; i <= DateTime.now().month; i++) {
        monthList.add(DateTime(DateTime.now().year, i));
      }
    } else {
      for (int i = 4; i <= 12; i++) {
        monthList.add(DateTime(DateTime.now().year - 1, i));
      }
      for (int i = 1; i <= DateTime.now().month; i++) {
        monthList.add(DateTime(DateTime.now().year, i));
      }
    }
    return monthList
        .map((e) => DatePeriod(DateTime(e.year, e.month, 1),
            DateTime(e.year, e.month + 1, 0, 23, 59, 59, 999), DateType.MONTH))
        .toList()
        .reversed
        .toList();
  }

  String truncateWithEllipsis(int cutoff, String myString) {
    return (myString.length <= cutoff)
        ? myString
        : '${myString.substring(0, cutoff)}...';
  }

  static Future<bool> isValidFileSize(int fileLength) async {
    var flag = true;
    if (fileLength > 5000000) {
      flag = false;
    }
    return flag;
  }

  static String getRandomName() {
    var commonProvider = Provider.of<CommonProvider>(
        navigatorKey.currentContext!,
        listen: false);

    return '${commonProvider.userDetails?.userRequest?.id}${Random().nextInt(3)}';
  }

  MediaType getMediaType(String? path) {
    if (path == null) return MediaType('', '');
    String? mimeStr = lookupMimeType(path);
    var fileType = mimeStr?.split('/');
    if (fileType != null && fileType.length > 0) {
      return MediaType(fileType.first, fileType.last);
    } else {
      return MediaType('', '');
    }
  }

  static List<KeyValue> getAlphabetsWithKeyValue() {
    List<String> alphabets = [];
    List<KeyValue> excelColumns = [];
    for (int i = 65; i <= 90; i++) {
      alphabets.add(String.fromCharCode(i));
    }
    for (int i = 0; i < 26; i++) {
      excelColumns.add(KeyValue(alphabets[i], i));
    }
    return excelColumns;
  }

  static Future<void> fetchPackageInfo() async {
    try {
      packageInfo = await PackageInfo.fromPlatform();
    } catch (e, s) {
      ErrorHandler.logError(e.toString(), s);
    }
  }

  void checkVersion(BuildContext context, String? latestAppVersion) async {
    try {
      if (latestAppVersion != null && !kIsWeb) {
        if (int.parse(packageInfo!.version.split('.').join("").toString()) <
            int.parse(latestAppVersion.split('.').join("").toString())) {
          late Uri uri;

          if (Platform.isAndroid) {
            uri = Uri.https("play.google.com", "/store/apps/details",
                {"id": Constants.PACKAGE_NAME});
          } else {
            uri = Uri.https("apps.apple.com", "/in/app/mgramseva/id1614373649");
          }

          showDialog(
              context: context,
              barrierDismissible: false,
              builder: (BuildContext context) {
                return WillPopScope(
                    child: AlertDialog(
                      title: Text('UPDATE AVAILABLE'),
                      content: Text(
                          'Please update the app from ${packageInfo?.version} to $latestAppVersion'),
                      actions: [
                        TextButton(
                            onPressed: () =>
                                launchPlayStore(uri.toString(), context),
                            child: Text('Update'))
                      ],
                    ),
                    onWillPop: () async {
                      if (Platform.isAndroid) {
                        SystemNavigator.pop();
                      } else if (Platform.isIOS) {
                        exit(0);
                      }
                      return true;
                    });
              });
        }
      }
    } catch (e) {}
  }

  void launchPlayStore(String appLink, BuildContext context) async {
    try {
      if (await canLaunch(appLink)) {
        await launch(appLink);
      } else {
        throw 'Could not launch appStoreLink';
      }
    } catch (e) {
      Navigator.pop(context);
    }
  }

  /// Remove invalid financial years
  static Future<void> getFilteredFinancialYearList(
      List<TaxPeriod> taxPeriodList) async {
    taxPeriodList.removeWhere((e) {
      var fromDate = DateTime.fromMillisecondsSinceEpoch(e.fromDate!);
      var toDate = DateTime.fromMillisecondsSinceEpoch(e.toDate!);
      return (fromDate.year + 1) != toDate.year;
    });
  }
}
