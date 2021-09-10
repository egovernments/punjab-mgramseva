import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:mgramseva/model/bill/billing.dart';
import 'package:mgramseva/repository/billing_service_repo.dart';

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
        res.bill?.first.billDetails
            ?.sort((a, b) => b.fromPeriod!.compareTo(a.fromPeriod!));
        streamController.add(res);
      } else {
        BillList billList = new BillList();
        billList.bill = [];
        streamController.add(billList);
      }
    } catch (e) {
      print(e);
    }
  }

  dispose() {
    streamController.close();
    super.dispose();
  }
}
