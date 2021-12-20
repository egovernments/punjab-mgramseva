import 'dart:math';

import 'package:flutter/material.dart';
import 'package:mgramseva/providers/common_provider.dart';
import 'package:mgramseva/routers/Routers.dart';
import 'package:mgramseva/utils/global_variables.dart';
import 'package:provider/provider.dart';

import 'models.dart';
import 'package:mime/mime.dart';
import 'package:http_parser/http_parser.dart';

class CommonMethods {
  static home() {
    navigatorKey.currentState?.popUntil((route) => route.isFirst);
  }

  static String getExtension(String url) {
    return url.substring(0, url.indexOf('?')).split('/').last;
  }

  static List<DatePeriod> getPastMonthUntilFinancialYear(int year) {
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
          i <= (DateTime.now().year == year ? DateTime.now().month : 3);
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
          DateTime(DateTime.now().year - 1, 1), DateTime.now(), DateType.YTD);
      var monthList = getPastMonthUntilFinancialYear(year.startDate.year);
      yearWithMonths.add(YearWithMonths(monthList, year));
    }

    for (int i = 0; i < count - 1; i++) {
      dynamic year = DateTime(DateTime.now().year - i);
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
}
