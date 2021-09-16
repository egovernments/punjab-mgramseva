import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:mgramseva/model/bill/billing.dart';
import 'package:mgramseva/providers/common_provider.dart';
import 'package:mgramseva/repository/billing_service_repo.dart';
import 'package:mgramseva/utils/global_variables.dart';
import 'package:universal_html/html.dart';

class FetchBillProvider with ChangeNotifier {
  var streamController = StreamController.broadcast();
  late GlobalKey<FormState> formKey;

  // ignore: non_constant_identifier_names
  Future<void> fetchBill(data) async {
    try {
      var res = await BillingServiceRepository().fetchdBill({
        "tenantId": data.tenantId,
        "consumerCode": data.connectionNo.toString(),
        "businessService": "WS"
      });
      if (res != null) {
        if (res.bill!.isNotEmpty) {
          res.bill?.first.billDetails
              ?.sort((a, b) => b.fromPeriod!.compareTo(a.fromPeriod!));
          streamController.add(res);
        } else {
          BillList billList = new BillList();
          billList.bill = [];
          streamController.add(billList);
        }
      } else {
        BillList billList = new BillList();
        billList.bill = [];
        streamController.add(billList);
      }
    } catch (e) {
      print(e);
    }
  }

  // ignore: non_constant_identifier_names
  Future<void> FetchBillwithoutLogin(Map data) async {
    try {
      var input = {
        "tenantId": data['tenantId'],
        "consumerCode": data['consumerCode'],
        "service": "WS",
      };

      await BillingServiceRepository()
          .fetchBillwithoutLogin(input)
          .then((res) async {
        var prams = {
          "key": data['key'] != null ? data['key'] : "ws-bill",
          "tenantId": data['tenantId']
        };
        var body = {"Bill": res.bill};
        await BillingServiceRepository()
            .fetchdfilestordIDNoAuth(body, prams)
            .then((value) async {
          print(value?.filestoreIds?.first);

          var output = await BillingServiceRepository()
              .fetchFiles(value!.filestoreIds!, data['tenantId']);
          CommonProvider()
            ..onTapOfAttachment(output!.first, navigatorKey.currentContext);
          window.location.href = "https://www.google.com/";
        });
      });
    } catch (e) {
      window.location.href = "https://www.google.com/";
    }
  }

  dispose() {
    streamController.close();
    super.dispose();
  }
}
