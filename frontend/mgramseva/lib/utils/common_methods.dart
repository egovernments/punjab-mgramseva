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

  static List<DateTime> getPastMonthUntilFinancialYear() {
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
    return monthList;
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
