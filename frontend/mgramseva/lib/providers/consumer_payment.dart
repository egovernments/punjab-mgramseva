
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:mgramseva/repository/consumer_details_repo.dart';

class ConsumerPayment with ChangeNotifier {

  var paymentStreamController = StreamController.broadcast();

  @override
  void dispose() {
    paymentStreamController.close();
    super.dispose();
  }


  Future<void> getConsumerPaymentDetails() async {
    try{
      var paymentDetails = ConsumerRepository().getConsumerPaymentDetails();
    }catch(e){

    }
  }
}