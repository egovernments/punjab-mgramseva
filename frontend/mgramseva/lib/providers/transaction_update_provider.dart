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
  // var transactionController = StreamController.broadcast();
  TransactionDetails? transactionDetails;
  var isPaymentSuccess = false;
  Timer? _timer;

  // dispose() {
  //   transactionController.close();
  //   super.dispose();
  // }

  loadPaymentSuccessPage(Map query, BuildContext context) async {
    try {
      var transactionResponse = await TransactionRepository()
          .updateTransaction({"transactionId": query['eg_pg_txnid']});
      if (transactionResponse != null &&
          transactionResponse.transaction != null) {
        isPaymentSuccess = true;
        transactionDetails = transactionResponse;
      }
    } catch (e, s) {
      ErrorHandler().allExceptionsHandler(context, e, s);
    }
  }

  Future<void> downloadOrShareReceiptWithoutLogin(
      BuildContext context, Map data, bool isWhatsAppShare) async {
    String input =
        '${ApplicationLocalizations.of(context).translate(i18.payment.WHATSAPP_TEXT_SHARE_RECEIPT)}';
    input = input.replaceAll('{transaction}', data['eg_pg_txnid']);
    try {
      var payment = {
        "Payment": {
          "tenantId": data['tenantId'],
          "paymentMode": 'PAYGOV',
          "paidBy": data['paidBy'],
          "mobileNumber": data['mobileNumber'],
          "totalAmountPaid": data['txnAmt'],
          "paymentDetails": [
            {
              "businessService": 'WS',
              "billId": data['billId'],
              "totalAmountPaid": data['txnAmt'],
            }
          ]
        }
      };

      await TransactionRepository().createPayment(payment).then((res) async {
        var params = {"key": "ws-receipt", "tenantId": data['tenantId']};
        var body = {"Payments": res!.payments};
        await BillingServiceRepository()
            .fetchdfilestordIDNoAuth(body, params)
            .then((value) async {
          var output = await BillingServiceRepository()
              .fetchFiles(value!.filestoreIds!, data['tenantId']);
          isWhatsAppShare
              ? CommonProvider()
                  .shareonwatsapp(output!.first, data['mobileNumber'], input)
              : CommonProvider().onTapOfAttachment(
                  output!.first, navigatorKey.currentContext);
          // window.location.href = "https://www.google.com/";
        });
      });
    } catch (e, s) {
      ErrorHandler().allExceptionsHandler(navigatorKey.currentContext!, e, s);
    }
  }

  void callNotifier() {
    notifyListeners();
  }
}
