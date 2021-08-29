import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:mgramseva/repository/billing_service_repo.dart';

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
    print(res);
    streamController.add(res);
  }

  dispose() {
    streamController.close();
    super.dispose();
  }
}
