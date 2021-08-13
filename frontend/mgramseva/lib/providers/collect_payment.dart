import 'dart:async';

import 'package:flutter/material.dart';
import 'package:mgramseva/model/payment_collection.dart';
import 'package:mgramseva/repository/consumer_details_repo.dart';

class CollectPaymentProvider with ChangeNotifier {

  var paymentStreamController = StreamController.broadcast();

  @override
  void dispose() {
    paymentStreamController.close();
    super.dispose();
  }


  Future<void> getConsumerPaymentDetails() async {
    try{
      var paymentDetails = await ConsumerRepository().getConsumerPaymentDetails();
      paymentStreamController.add(paymentDetails);
    }catch(e){
      print(e);
    }
  }

  Future<void> updatePaymentInformation(CollectPayment connectionPayment) async {
    try{
      var paymentDetails = await ConsumerRepository().getConsumerPaymentDetails();
    }catch(e){
      print(e);
    }
  }

  onClickOfViewOrHideDetails(CollectPayment connectionPayment) {
    connectionPayment.viewDetails = !connectionPayment.viewDetails;
    notifyListeners();
  }

  onChangeOfPaymentAmountOrMethod(CollectPayment connectionPayment, String val, [isPaymentAmount = false]) {
    if(isPaymentAmount){
      connectionPayment.paymentAmount = val;
    }else{
      connectionPayment.paymentMethod = val;
    }
    notifyListeners();
  }
}