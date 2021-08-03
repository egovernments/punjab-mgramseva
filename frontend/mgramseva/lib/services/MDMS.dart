import 'dart:io';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:mgramseva/Env/app_config.dart';
import 'package:mgramseva/services/RequestInfo.dart';
import 'package:mgramseva/services/urls.dart';

initRequestBody(tenantId) {
  return {
    "MdmsCriteria": {
      ...tenantId,
      "moduleDetails": [
        {
          "moduleName": "common-masters",
          "masterDetails": [
            {"name": "Department"},
            {"name": "Designation"},
            {"name": "StateInfo"},
            {"name": "wfSlaConfig"}
          ],
        },
        {
          "moduleName": "tenant",
          "masterDetails": [
            {"name": "tenants"},
            {"name": "citymodule"}
          ],
        },
        {
          "moduleName": "DIGIT-UI",
          "masterDetails": [
            {"name": "ApiCachingSettings"}
          ],
        },
      ],
    },
  };
}

Map getExpenseMDMS(String tenantId) {
  return {
    "MdmsCriteria": {
      "tenantId": tenantId,
      "moduleDetails": [
        {
          "moduleName": "Expense",
          "masterDetails": [
            {"name": "ExpenseType"},
          ]
        },
        {
          "moduleName": "BillingService",
          "masterDetails": [
            {"name": "BusinessService"},
            {"name": "TaxHeadMaster"},
          ]
        }
      ]
    }
  };
}

Map getConnectionTypePropertyTypeMDMS(String tenantId) {
  return {
    "MdmsCriteria": {
      "tenantId": tenantId,
      "moduleDetails": [
        {
          "moduleName": "ws-services-masters",
          "masterDetails": [
            {"name": "connectionType"},
          ]
        },
        {
          "moduleName": "PropertyTax",
          "masterDetails": [
            {"name": "PropertyType"},
          ]
        },
      ]
    }
  };
}

Future getMDMD() async {
  final requestInfo =
      RequestInfo('Rainmaker', .01, "", "_search", 1, "", "", "");
  var response = await http.post(Uri.parse(apiBaseUrl.toString() + Url.MDMS),
      headers: {
        HttpHeaders.contentTypeHeader: 'application/json',
      },
      body: json.encode({
        "RequestInfo": requestInfo.toJson(),
        ...initRequestBody({"tenantId": "pb"})
      }));

  print('Response status: ${response.statusCode}');

  if (response.statusCode == 200) {
// Write value
    if (kIsWeb) {
      // Use flutter_secure_storage
      // await storage.write(
      //     key: 'token', value: json.decode(response.body)['token']);
      // } else {
      // Use localStorage - unsafe
      // storage.setItem("local", json.decode(response.body)['messages'].toString());
      // window.localStorage['local'] = ;
    }
  }

  return (response);
}
