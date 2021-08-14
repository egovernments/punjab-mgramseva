import 'dart:async';

import 'package:flutter/material.dart';
import 'package:mgramseva/model/common/fetch_bill.dart';
import 'package:mgramseva/repository/consumer_details_repo.dart';
import 'package:mgramseva/utils/custom_exception.dart';
import 'package:mgramseva/utils/error_logging.dart';

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

  Future<void> updatePaymentInformation(FetchBill fetchBill) async {

    var payment = {
      "Payment": {
        "tenantId": "pb",
        "paymentMode": "CASH",
        "paidBy": "xyz",
        "mobileNumber": "901025689787",
        "totalAmountPaid": 100,
        "paymentDetails": [
          {
            "businessService": "FSM.TRIP_CHARGES",
            "billId": "2c515ec9-3ea4-4580-a1df-fd0d481f6666",
            "totalAmountPaid": 100
          }
        ]
      }
    };

    try{
      var paymentDetails = await ConsumerRepository().collectPayment(payment);
    }catch(e){
      print(e);
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