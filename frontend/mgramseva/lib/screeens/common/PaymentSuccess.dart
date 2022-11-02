import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mgramseva/model/success_handler.dart';
import 'package:mgramseva/widgets/CommonSuccessPage.dart';
import 'package:mgramseva/utils/Constants/I18KeyConstants.dart';


class PaymentSuccess extends StatefulWidget {
  final Map<String, dynamic> query;

  PaymentSuccess({Key? key, required this.query});
  @override
  State<StatefulWidget> createState() {
    return _PaymentSuccessState();
  }
}

class _PaymentSuccessState extends State<PaymentSuccess> {
  void initState() {
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return CommonSuccess(SuccessHandler(
      i18.common.PAYMENT_COMPLETE,
      'ashdjhdbasjb',
      '',
      '',
    ),backButton: false,
        isWithoutLogin: true,
    isConsumer: widget.query['isConsumer'] == 'true' ? true : false,);
  }
}