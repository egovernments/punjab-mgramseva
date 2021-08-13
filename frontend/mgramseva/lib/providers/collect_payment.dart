import 'dart:async';

import 'package:flutter/material.dart';
import 'package:mgramseva/model/common/fetch_bill.dart';
import 'package:mgramseva/repository/consumer_details_repo.dart';

class CollectPaymentProvider with ChangeNotifier {

  var paymentStreamController = StreamController.broadcast();
  var demandStreamCtrl = StreamController.broadcast();

  @override
  void dispose() {
    paymentStreamController.close();
    demandStreamCtrl.close();
    super.dispose();
  }


  Future<void> getBillDetails() async {
    try{
      var paymentDetails = await ConsumerRepository().getBillDetails();
      if(paymentDetails != null) {
        paymentStreamController.add(paymentDetails.first);
        getDemandDetails();
      }

    }catch(e){
      print(e);
    }
  }

  Future<void> getDemandDetails() async {
    try{
      var paymentDetails = await ConsumerRepository().getDemandDetails();
      paymentStreamController.add(paymentDetails);
    }catch(e){
      print(e);
    }
  }

  Future<void> updatePaymentInformation(FetchBill fetchBill) async {
    try{
      var paymentDetails = await ConsumerRepository().getBillDetails();
    }catch(e){
      print(e);
    }
  }

  onClickOfViewOrHideDetails(FetchBill fetchBill) {
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