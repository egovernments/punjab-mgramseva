import 'dart:io';
import 'package:mgramseva/Env/app_config.dart';
import 'package:mgramseva/providers/common_provider.dart';
import 'package:mgramseva/screeens/Home/Home.dart';
import 'package:mgramseva/services/RequestInfo.dart';
import 'package:mgramseva/services/urls.dart';
import 'package:mgramseva/utils/common_methods.dart';
import 'package:mgramseva/utils/constants.dart';
import 'package:mgramseva/utils/global_variables.dart';
import 'package:provider/provider.dart';
import "package:universal_html/html.dart" hide Text, Navigator;
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:mgramseva/services/LocalStorage.dart';

Future<http.Response> login(url, details, context) async {
  var response = await http.post(Uri.parse(url),
      headers: {
        HttpHeaders.contentTypeHeader: 'application/x-www-form-urlencoded',
        "Access-Control-Allow-Origin": "*",
        "authorization": "Basic ZWdvdi11c2VyLWNsaWVudDo=",
      },
      body: details);
  print('Response status: ${response.statusCode}');

  print('Response body: ${response.body}');
  if (response.statusCode == 200) {
// Write value

    if (kIsWeb) {
      window.localStorage['User'] =
          json.decode(response.body)['UserRequest'].toString();
    } else {
      storage.write(
          key: 'User',
          value: json.decode(response.body)['UserRequest'].toString());
    }
    CommonMethods.home();
  } else {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
          backgroundColor: Colors.red,
          content: Text(json.decode(response.body)['error_description'])),
    );
  }

  return (response);
}

Future otpforresetpassword(details, context) async {
  final requestInfo = RequestInfo(
      APIConstants.API_MODULE_NAME,
      APIConstants.API_VERSION,
      APIConstants.API_TS,
      "_search",
      APIConstants.API_DID,
      APIConstants.API_KEY,
      APIConstants.API_MESSAGE_ID,
      "2cc113a0-e3c8-4665-9a41-21746e27f2fb");
  var response = await http.post(
      Uri.parse(apiBaseUrl.toString() + UserUrl.OTP_RESET_PASSWORD),
      headers: {
        HttpHeaders.contentTypeHeader: 'application/json',
        "Access-Control-Allow-Origin": "*",
        "authorization": "Basic ZWdvdi11c2VyLWNsaWVudDo=",
      },
      body: json.encode({"RequestInfo": requestInfo.toJson(), ...details}));
  print('Response status: ${response.statusCode}');

  print('Response body: ${response.body}');
}

Future resetNewPassword(details) async {
  final requestInfo =
      RequestInfo('Rainmaker', .01, "", "_search", 1, "", "", "");

  var response =
      await http.post(Uri.parse(apiBaseUrl.toString() + UserUrl.RESET_PASSWORD),
          headers: {
            HttpHeaders.contentTypeHeader: 'application/json',
          },
          body: json.encode({"RequestInfo": requestInfo.toJson(), ...details}));

  print('Response status: ${response.statusCode}');
}
