import 'dart:async';

import 'package:flutter/material.dart';
import 'package:mgramseva/model/bill/billing.dart';
import 'package:mgramseva/model/bill/meter_demand_details.dart';
import 'package:mgramseva/repository/bill_generation_details_repo.dart';
import 'package:mgramseva/repository/billing_service_repo.dart';
import 'package:mgramseva/utils/loaders.dart';

class HouseHoldProvider with ChangeNotifier {
  late GlobalKey<FormState> formKey;

  var streamController = StreamController.broadcast();
  Future<void> checkMeterDemand(BillList data) async {
    if (data.bill!.isNotEmpty) {
      var res = await BillGenerateRepository().searchmetetedDemand({
        "tenantId": data.bill!.first.tenantId,
        "connectionNos": data.bill!.first.consumerCode
      });
      if (res.meterReadings!.isNotEmpty) {
        data.bill!.first.meterReadings = res.meterReadings;
      }
      streamController.add(data);
    }
  }

  Future<void> FetchBill(data) async {
    await BillingServiceRepository().fetchdBill({
      "tenantId": data.tenantId,
      "consumerCode": data.connectionNo.toString(),
      "businessService": "WS"
    }).then((value) => checkMeterDemand(value));
  }

  dispose() {
    streamController.close();
    super.dispose();
  }

  void callNotifyer() {
    notifyListeners();
  }
}
