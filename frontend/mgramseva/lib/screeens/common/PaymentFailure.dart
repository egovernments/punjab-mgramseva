import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


import '../../routers/Routers.dart';
import '../../widgets/ErrorMessagePAge.dart';

class PaymentFailure extends StatefulWidget {

  PaymentFailure({Key? key});
  @override
  State<StatefulWidget> createState() {
    return _PaymentFailureState();
  }
}

class _PaymentFailureState extends State<PaymentFailure> {
  void initState() {
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return ErrorPage("Payment failed");
  }
}