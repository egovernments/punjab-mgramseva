import 'dart:async';

import 'package:flutter/material.dart';
import 'package:mgramseva/model/bill/billing.dart';
import 'package:mgramseva/model/bill/meter_demand_details.dart';
import 'package:mgramseva/model/connection/water_connection.dart';
import 'package:mgramseva/repository/bill_generation_details_repo.dart';
import 'package:mgramseva/repository/billing_service_repo.dart';
import 'package:mgramseva/utils/error_logging.dart';
import 'package:mgramseva/utils/global_variables.dart';
import 'package:mgramseva/utils/loaders.dart';

class HouseHoldProvider with ChangeNotifier {
  late GlobalKey<FormState> formKey;

  var streamController = StreamController.broadcast();
  Future<void> checkMeterDemand(
      BillList data, WaterConnection waterConnection) async {
    if (data.bill!.isNotEmpty) {
      try {
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
        }
        data.bill!.first.waterConnection = waterConnection;
        streamController.add(data);
      } catch (e, s) {
        streamController.addError('error');
        ErrorHandler().allExceptionsHandler(navigatorKey.currentContext!, e, s);
      }
    }
  }

  Future<void> fetchBill(data) async {
    await BillingServiceRepository().fetchdBill({
      "tenantId": data.tenantId,
      "consumerCode": data.connectionNo.toString(),
      "businessService": "WS"
    }).then((value) => checkMeterDemand(value, data));
  }

  Future<void> fetchDemand(data) async {
    await BillingServiceRepository().fetchdDemand({
      "tenantId": data.tenantId,
      "consumerCode": data.connectionNo.toString(),
      "businessService": "WS"
    }).then((value) {
      if (value.demands!.length > 0) {
        fetchBill(data);
      } else {
        BillList data = new BillList();
        streamController.add(data);
      }
    });
  }

  dispose() {
    streamController.close();
    super.dispose();
  }

  void callNotifyer() {
    notifyListeners();
  }
}
