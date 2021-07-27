import 'dart:io';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:mgramseva/Env/app_config.dart';
import 'package:mgramseva/services/RequestInfo.dart';
import 'package:mgramseva/services/urls.dart';
import 'package:universal_html/html.dart';
// import 'package:mgramseva/services/LocalStorage.dart';
// import 'package:flutter_secure_storage/flutter_secure_storage.dart';

// Create storage
// final storage = new FlutterSecureStorage();

Future getLocilisation(String locale) async {
  var res = window.localStorage['localisation_' + locale.toString()];
  if (res == null) {
    final requestInfo =
        RequestInfo('Rainmaker', .01, "", "_search", 1, "", "", "");

    // print(requestInfo.toJson());
    var response = await http.post(
        Uri.parse(apiBaseUrl.toString() +
            Url.LOCALIZATION +
            "?module=mgramseva-common&locale=" +
            locale +
            "&tenantId=pb"),
        headers: {
          HttpHeaders.contentTypeHeader: 'application/json',
        },
        body: json.encode(requestInfo.toJson()));
    //  var response = await http.post(url,body:json.encode(user.toMap()));
    print('Response status: ${response.statusCode}');

    // print('Response body: ${response.body}');
    if (response.statusCode == 200) {
// Write value
      if (kIsWeb) {
        window.localStorage['localisation_' + locale] =
            jsonEncode(json.decode(response.body)['messages']);
        // Use flutter_secure_storage
        // await storage.write(
        //     key: 'token', value: json.decode(response.body)['token']);
      } else {
        // Use localStorage - unsafe

        // window.localStorage['local'] = ;
      }
    }

    return (response);
  } else {
    return;
  }
}
