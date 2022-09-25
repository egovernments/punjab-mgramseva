import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mgramseva/model/success_handler.dart';
import 'package:mgramseva/widgets/CommonSuccessPage.dart';
import 'package:mgramseva/utils/Constants/I18KeyConstants.dart';

import '../../routers/Routers.dart';

class PaymentSuccess extends StatefulWidget {

  PaymentSuccess({Key? key});
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
      i18.common.BACK_HOME,
      Routes.HOUSEHOLD_DETAILS_COLLECT_PAYMENT,
    ));
  }
}