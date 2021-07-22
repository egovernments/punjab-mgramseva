import 'dart:io';
import 'package:mgramseva/app_config.dart';
import 'package:mgramseva/screeens/Home.dart';
import 'package:mgramseva/services/RequestInfo.dart';
import 'package:mgramseva/services/urls.dart';
import "package:universal_html/html.dart" hide Text, Navigator;
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:mgramseva/services/LocalStorage.dart';

Future<http.Response> login(url, details, context) async {
  print(url);
  print(details);

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
      // window.localStorage['token'] = json.decode(response.body)['access_token'];
    } else {
      storage.write(
          key: 'token', value: json.decode(response.body)['access_token']);
    }
    Navigator.of(context)
        .pushReplacement(new MaterialPageRoute(builder: (BuildContext context) {
      return new Home(0);
    }));
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
  final requestInfo = RequestInfo('Rainmaker', .01, "", "_search", 1, "", "",
      "2cc113a0-e3c8-4665-9a41-21746e27f2fb");
  var response = await http.post(
      Uri.parse(apiBaseUrl.toString() + Urls['OTP_RESET_PASSWORD'].toString()),
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
  var response = await http.post(
      Uri.parse(apiBaseUrl.toString() + Urls['RESET_NEW_PASSWORD'].toString()),
      headers: {
        HttpHeaders.contentTypeHeader: 'application/json',
      },
      body: json.encode({"RequestInfo": requestInfo.toJson(), ...details}));

  print('Response status: ${response.statusCode}');
}
