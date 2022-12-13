import 'package:mgramseva/services/urls.dart';

import '../model/Transaction/transaction.dart';
import '../model/bill/bill_payments.dart';
import '../services/BaseService.dart';
import '../services/RequestInfo.dart';
import '../utils/global_variables.dart';
import '../utils/models.dart';

class TransactionRepository extends BaseService {
  Future<TransactionDetails?> updateTransaction(
      Map<String, dynamic> queryparams) async {
    TransactionDetails? response;
    var res = await makeRequest(
        url: Url.UPDATE_TRANSACTION,
        method: RequestType.POST,
        queryParameters: queryparams,
        requestInfo: RequestInfo(
            APIConstants.API_MODULE_NAME,
            APIConstants.API_VERSION,
            APIConstants.API_TS,
            "",
            APIConstants.API_DID,
            APIConstants.API_KEY,
            APIConstants.API_MESSAGE_ID,
            null));

    if (res != null) {
      response = TransactionDetails.fromJson(res);
    }
    return response;
  }

  Future<BillPayments?> createPayment(Map body) async {
    BillPayments? response;

    var res = await makeRequest(
        url: Url.COLLECT_PAYMENT,
        method: RequestType.POST,
        body: body,
        requestInfo: RequestInfo(
            APIConstants.API_MODULE_NAME,
            APIConstants.API_VERSION,
            APIConstants.API_TS,
            "",
            APIConstants.API_DID,
            APIConstants.API_KEY,
            APIConstants.API_MESSAGE_ID,
            null));

    if (res != null) {
      response = BillPayments.fromJson(res);
    }
    return response;
  }
}
