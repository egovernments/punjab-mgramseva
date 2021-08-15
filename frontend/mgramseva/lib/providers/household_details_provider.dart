import 'dart:async';

import 'package:flutter/material.dart';
import 'package:mgramseva/model/bill/billing.dart';
import 'package:mgramseva/model/bill/meter_demand_details.dart';
import 'package:mgramseva/model/connection/water_connection.dart';
import 'package:mgramseva/repository/bill_generation_details_repo.dart';
import 'package:mgramseva/repository/billing_service_repo.dart';
import 'package:mgramseva/utils/loaders.dart';

class HouseHoldProvider with ChangeNotifier {
  late GlobalKey<FormState> formKey;

  var streamController = StreamController.broadcast();
  Future<void> checkMeterDemand(
      BillList data, WaterConnection waterConnection) async {
    if (data.bill!.isNotEmpty) {
      var res = await BillGenerateRepository().searchmetetedDemand({
        "tenantId": data.bill!.first.tenantId,
        "connectionNos": data.bill!.first.consumerCode
      });
      if (res.meterReadings!.isNotEmpty) {
        data.bill!.first.meterReadings = res.meterReadings;
      }
      if (data.bill!.first.billDetails != null) {
        data.bill!.first.billDetails!
            .sort((a, b) => b.toPeriod!.compareTo(a.toPeriod!));
        print(data.bill!.first.billDetails!.first.amount.toString());
      }
      data.bill!.first.waterConnection = waterConnection;
      streamController.add(data);
    }
  }

  Future<void> FetchBill(data) async {
    await BillingServiceRepository().fetchdBill({
      "tenantId": data.tenantId,
      "consumerCode": data.connectionNo.toString(),
      "businessService": "WS"
    }).then((value) => checkMeterDemand(value, data));
  }

  dispose() {
    streamController.close();
    super.dispose();
  }

  void callNotifyer() {
    notifyListeners();
  }
}
