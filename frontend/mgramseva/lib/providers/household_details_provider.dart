import 'dart:async';

import 'package:flutter/material.dart';
import 'package:mgramseva/model/bill/billing.dart';
import 'package:mgramseva/model/bill/meter_demand_details.dart';
import 'package:mgramseva/model/connection/water_connection.dart';
import 'package:mgramseva/repository/bill_generation_details_repo.dart';
import 'package:mgramseva/repository/billing_service_repo.dart';
import 'package:mgramseva/repository/search_connection_repo.dart';
import 'package:mgramseva/utils/error_logging.dart';
import 'package:mgramseva/utils/global_variables.dart';
import 'package:mgramseva/utils/loaders.dart';
import 'package:provider/provider.dart';

import 'common_provider.dart';

class HouseHoldProvider with ChangeNotifier {
  late GlobalKey<FormState> formKey;
  WaterConnection? waterConnection;

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
    } else {
      streamController.add(data);
    }
  }

  Future<void> fetchBill(data) async {
    try {
      await BillingServiceRepository().fetchdBill({
        "tenantId": data.tenantId,
        "consumerCode": data.connectionNo.toString(),
        "businessService": "WS"
      }).then((value) {
        checkMeterDemand(value, data);
      });
    } catch (e, s) {
      streamController.addError('error');
      ErrorHandler().allExceptionsHandler(navigatorKey.currentContext!, e, s);
    }
  }

  Future<void> fetchDemand(data, [String? id]) async {
    var commonProvider = Provider.of<CommonProvider>(
        navigatorKey.currentContext!,
        listen: false);

    if (data == null) {
      var res = await SearchConnectionRepository().getconnection({
        "tenantId": commonProvider.userDetails!.selectedtenant!.code,
        ...{'connectionNumber': id},
      });
      if (res != null &&
          res.waterConnection != null &&
          res.waterConnection!.isNotEmpty) {
        data = res.waterConnection!.first;
      }
    }
    waterConnection = data;
    try {
      await BillingServiceRepository().fetchdDemand({
        "tenantId": data.tenantId,
        "consumerCode": data.connectionNo.toString(),
        "businessService": "WS"
      }).then((value) {
        if (value.demands!.length > 0) {
          fetchBill(data);
        } else {
          BillList bill = new BillList();
          bill.bill = [];
          streamController.add(bill);
        }
      });
    } catch (e, s) {
      streamController.addError('error');
      ErrorHandler().allExceptionsHandler(navigatorKey.currentContext!, e, s);
    }
  }

  dispose() {
    streamController.close();
    super.dispose();
  }

  void callNotifyer() {
    notifyListeners();
  }
}
