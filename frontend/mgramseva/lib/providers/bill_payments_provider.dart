import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:mgramseva/providers/common_provider.dart';
import 'package:mgramseva/repository/billing_service_repo.dart';
import 'package:mgramseva/utils/global_variables.dart';
import 'package:universal_html/html.dart';

class BillPayemntsProvider with ChangeNotifier {
  var streamController = StreamController.broadcast();
  late GlobalKey<FormState> formKey;

  // ignore: non_constant_identifier_names
  Future<void> FetchBillPayments(data) async {
    var res = await BillingServiceRepository().fetchdBillPayments({
      "tenantId": data.tenantId,
      "consumerCodes": data.connectionNo.toString(),
      "businessService": "WS"
    });
    streamController.add(res);
  }

  // ignore: non_constant_identifier_names
  Future<void> FetchBillPaymentswithoutLogin(Map data) async {
    try {
      var input = {
        "tenantId": data['tenantId'],
        "consumerCode": data['consumerCode'],
        "businessService": "WS",
        "receiptNumbers": data['receiptNumber']
      };

      await BillingServiceRepository()
          .fetchdBillPaymentsNoAuth(input)
          .then((res) async {
        var prams = {
          "key": data['key'] != null ? data['key'] : "ws-receipt",
          "tenantId": data['tenantId']
        };
        var body = {"Payments": res.payments};
        await BillingServiceRepository()
            .fetchdfilestordIDNoAuth(body, prams)
            .then((value) async {
          var output = await BillingServiceRepository()
              .fetchFiles(value!.filestoreIds!, data['tenantId']);
          CommonProvider()
            ..onTapOfAttachment(output!.first, navigatorKey.currentContext);
          // window.location.href = "https://www.google.com/";
        });
      });
    } catch (e) {
      // window.location.href = "https://www.google.com/";
    }
  }

  dispose() {
    streamController.close();
    super.dispose();
  }
}
