import 'dart:async';

import 'package:flutter/material.dart';
import 'package:mgramseva/model/common/fetch_bill.dart';
import 'package:mgramseva/model/success_handler.dart';
import 'package:mgramseva/repository/consumer_details_repo.dart';
import 'package:mgramseva/routers/Routers.dart';
import 'package:mgramseva/utils/Locilization/application_localizations.dart';
import 'package:mgramseva/utils/custom_exception.dart';
import 'package:mgramseva/utils/error_logging.dart';
import 'package:mgramseva/utils/Constants/I18KeyConstants.dart';
import 'package:mgramseva/utils/loaders.dart';
import 'package:mgramseva/utils/notifyers.dart';

class CollectPaymentProvider with ChangeNotifier {

  var paymentStreamController = StreamController.broadcast();

  @override
  void dispose() {
    paymentStreamController.close();
    super.dispose();
  }


  Future<void> getBillDetails(BuildContext context) async {

    var query = {
      'consumerCode' : 'WS/400/2021-22/0162',
      'businessService' : 'WS',
      'tenantId' : 'pb.lodhipur'
    };

    try{
      var paymentDetails = await ConsumerRepository().getBillDetails(query);
      if(paymentDetails != null) {
      var demandDetails = await ConsumerRepository().getDemandDetails(query);
      if(demandDetails != null) paymentDetails.first.demand = demandDetails.first;
        paymentStreamController.add(paymentDetails.first);
      }
    }on CustomException catch (e,s){
      ErrorHandler.handleApiException(context, e,s);
      paymentStreamController.addError('error');
    } catch (e, s) {
      ErrorHandler.logError(e.toString(),s);
      paymentStreamController.addError('error');
    }
  }

  Future<void> updatePaymentInformation(FetchBill fetchBill, BuildContext context) async {

    var payment = {
      "Payment": {
        "tenantId": "pb",
        "paymentMode": fetchBill.paymentMethod,
        "paidBy": fetchBill.payerName,
        "mobileNumber": fetchBill.mobileNumber,
        "totalAmountPaid": fetchBill.totalAmount,
        "paymentDetails": [
          {
            "businessService": fetchBill.businessService,
            "billId": fetchBill.billDetails?.first.billId,
            "totalAmountPaid": fetchBill.totalAmount
          }
        ]
      }
    };

    try{
      Loaders.showLoadingDialog(context);

      var paymentDetails = await ConsumerRepository().collectPayment(payment);
      if(paymentDetails != null && paymentDetails.isNotEmpty){

        Navigator.pop(context);

       Navigator.pushNamed(context, Routes.SUCCESS_VIEW,
            arguments: SuccessHandler(
                i18.common.PAYMENT_COMPLETE,
                '${ApplicationLocalizations.of(context).translate(i18.payment.RECEIPT_REFERENCE_WITH_MOBILE_NUMBER)} (+91 ${fetchBill.mobileNumber})',
                i18.common.BACK_HOME, Routes.PAYMENT_SUCCESS, subHeader: '${ApplicationLocalizations.of(context).translate(i18.common.RECEIPT_NO)} \n ${paymentDetails.first['paymentDetails'][0]['receiptNumber']}',
            ));
      }
    }on CustomException catch (e,s) {
      Navigator.pop(context);
      if(ErrorHandler.handleApiException(context, e,s)) {
        Notifiers.getToastMessage(
            context,
            e.message,
            'ERROR');
      }
    } catch (e, s) {
      Navigator.pop(context);
      Notifiers.getToastMessage(
          context,
          e.toString(),
          'ERROR');
      ErrorHandler.logError(e.toString(),s);
    }
  }

  onClickOfViewOrHideDetails(FetchBill fetchBill, BuildContext context) {
    fetchBill.viewDetails = !fetchBill.viewDetails;
    notifyListeners();
  }

  onChangeOfPaymentAmountOrMethod(FetchBill fetchBill, String val, [isPaymentAmount = false]) {
    if(isPaymentAmount){
      fetchBill.paymentAmount = val;
    }else{
      fetchBill.paymentMethod = val;
    }
    notifyListeners();
  }
}