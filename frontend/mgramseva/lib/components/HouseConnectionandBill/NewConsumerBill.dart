import 'package:flutter/material.dart';
import 'package:mgramseva/model/bill/billing.dart';
import 'package:mgramseva/providers/common_provider.dart';
import 'package:mgramseva/routers/Routers.dart';
import 'package:mgramseva/utils/Constants/I18KeyConstants.dart';
import 'package:mgramseva/utils/Locilization/application_localizations.dart';
import 'package:mgramseva/utils/date_formats.dart';
import 'package:mgramseva/widgets/ButtonGroup.dart';
import 'package:mgramseva/widgets/ListLabelText.dart';
import 'package:provider/provider.dart';

class NewConsumerBill extends StatelessWidget {
  final BillList? billList;

  const NewConsumerBill(this.billList);
  _getLabeltext(label, value, context) {
    return (Row(
      children: [
        Container(
            padding: EdgeInsets.only(top: 16, bottom: 16),
            width: MediaQuery.of(context).size.width / 3,
            child: Text(
              ApplicationLocalizations.of(context).translate(label),
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
            )),
        Text(value, style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400))
      ],
    ));
  }

  @override
  Widget build(BuildContext context) {
    var r = billList!.bill!.first.billDetails!.first.amount as num;
    print(billList!.bill!.first.billDetails!
            .map((ele) => ele.amount)
            .reduce(((previousValue, element) {
          return previousValue! + element!;
        }))! -
        r);

    return billList!.bill!.first.meterReadings == null
        ? Container(
            child: Text(""),
          )
        : Column(
            children: [
              ListLabelText(i18.billDetails.NEW_CONSUMERGENERATE_BILL_LABEL),
              Card(
                  child: Padding(
                      padding: EdgeInsets.all(15),
                      child: Column(children: [
                        _getLabeltext(
                            i18.billDetails.LAST_BILL_GENERATED_DATE,
                            DateFormats.timeStampToDate(
                                    billList!.bill!.first.billDate,
                                    format: "dd-MM-yyyy")
                                .toString(),
                            context),
                        _getLabeltext(
                            i18.billDetails.CURRENT_BILL,
                            (billList!.bill!.first.billDetails!.first.amount)
                                .toString(),
                            context),
                        _getLabeltext(
                            i18.billDetails.ARRERS_DUES,
                            (billList!.bill!.first.billDetails!
                                        .map((ele) => ele.amount)
                                        .reduce(((previousValue, element) {
                                      return previousValue! + element!;
                                    }))! -
                                    r)
                                .toString(),
                            context),
                        _getLabeltext(
                            i18.billDetails.TOTAL_AMOUNT,
                            billList!.bill!.first.totalAmount.toString(),
                            context),
                        ButtonGroup(i18.billDetails.COLLECT_PAYMENT, ()=> onClickOfCollectPayment(billList!.bill!.first, context)),
                      ])))
            ],
          );
  }

  void onClickOfCollectPayment(Bill bill, BuildContext context) {
    var commonProvider = Provider.of<CommonProvider>(context, listen: false);


    Map<String, dynamic> query ={
      'consumerCode' : bill.consumerCode,
      'businessService' : bill.businessService,
      'tenantId' : commonProvider.userDetails?.selectedtenant?.code
    };
    Navigator.pushNamed(context, Routes.BILL_GENERATE, arguments: query);
  }
}
