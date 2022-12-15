import 'dart:async';

import 'package:flutter/material.dart';
import 'package:mgramseva/model/Transaction/transaction.dart';
import 'package:mgramseva/utils/Constants/I18KeyConstants.dart';
import 'package:mgramseva/utils/error_logging.dart';

import '../repository/billing_service_repo.dart';
import '../repository/transaction_repo.dart';
import '../utils/Locilization/application_localizations.dart';
import '../utils/global_variables.dart';
import 'common_provider.dart';

class TransactionUpdateProvider with ChangeNotifier {
  var transactionController = StreamController.broadcast();
  TransactionDetails? transactionDetails;
  var isPaymentSuccess = false;

  Future<void> updateTransaction(Map query, BuildContext context) async {
    try {
      await TransactionRepository().updateTransaction(
          {"transactionId": query['eg_pg_txnid']}).then((value) {
        if (value != null && value.transaction != null) {
          isPaymentSuccess = true;
          transactionDetails = value;
          transactionController.add(value);
        }
      });
    } catch (e, s) {
      ErrorHandler().allExceptionsHandler(context, e, s);
      transactionController.addError('error');
    }
  }

  Future<void> downloadOrShareReceiptWithoutLogin(BuildContext context,
      TransactionDetails transactionObj, bool isWhatsAppShare) async {
    String input =
        '${ApplicationLocalizations.of(context).translate(i18.payment.WHATSAPP_TEXT_SHARE_RECEIPT)}';
    input = input.replaceAll(
        '{transaction}', transactionObj.transaction!.txnId.toString());
    try {
      var input = {
        "tenantId": transactionObj.transaction!.tenantId,
        "consumerCode": transactionObj.transaction!.consumerCode,
        "businessService": "WS",
      };

      await BillingServiceRepository()
          .fetchdBillPaymentsNoAuth(input)
          .then((res) async {
        var params = {
          "key": "ws-receipt",
          "tenantId": transactionObj.transaction!.tenantId
        };
        var body = {"Payments": res.payments};
        await BillingServiceRepository()
            .fetchdfilestordIDNoAuth(body, params)
            .then((value) async {
          var output = await BillingServiceRepository().fetchFiles(
              value!.filestoreIds!,
              transactionObj.transaction!.tenantId.toString());
          isWhatsAppShare
              ? CommonProvider().shareonwatsapp(output!.first,
                  transactionObj.transaction!.user!.mobileNumber, input)
              : CommonProvider().onTapOfAttachment(
                  output!.first, navigatorKey.currentContext);
        });
      });
    } catch (e, s) {
      ErrorHandler().allExceptionsHandler(navigatorKey.currentContext!, e, s);
      transactionController.addError('error');
    }
  }

  void callNotifier() {
    notifyListeners();
  }
}
