import 'dart:io';
import 'package:mgramseva/Env/app_config.dart';
import 'package:mgramseva/providers/common_provider.dart';
import 'package:mgramseva/screeens/Home.dart';
import 'package:mgramseva/services/RequestInfo.dart';
import 'package:mgramseva/services/urls.dart';
import 'package:provider/provider.dart';
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
      window.localStorage['User'] =
          json.decode(response.body)['UserRequest'].toString();
    } else {
      storage.write(
          key: 'User',
          value: json.decode(response.body)['UserRequest'].toString());
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

Future updatepassword(details, context) async {
  print(details);
  final requestInfo = RequestInfo('ap.public', .01, "", "POST", 1, "", "",
      "6d82567a-c768-4cab-b432-f83116f3357a");
  var response = await http.post(
      Uri.parse(apiBaseUrl.toString() + UserUrl.CHANGE_PASSWORD),
      headers: {
        HttpHeaders.contentTypeHeader: 'application/json',
      },
      body: json.encode({"RequestInfo": requestInfo.toJson(), ...details}));

  print('Response status: ${response.statusCode}');
}

Future updateprofile(details, context) async {
  print(details);
  final requestInfo = RequestInfo('Rainmaker', .01, "", "_search", "", "", "", "6d82567a-c768-4cab-b432-f83116f3357a");
  var response = await http.post(
      Uri.parse(apiBaseUrl.toString() + UserUrl.EDIT_PROFILE),
      headers: {
        HttpHeaders.contentTypeHeader: 'application/json',
      },
      body: json.encode({"RequestInfo": requestInfo.toJson(), ...details}));
  print('Response status: ${response.statusCode}');

  print('Response body: ${response.body}');
}
