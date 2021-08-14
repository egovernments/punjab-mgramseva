import 'package:flutter/material.dart';
import 'package:mgramseva/constants/houseconnectiondetails.dart';
import 'package:mgramseva/model/bill/billing.dart';
import 'package:mgramseva/utils/date_formats.dart';
import 'package:mgramseva/widgets/Button.dart';
import 'package:mgramseva/widgets/ButtonGroup.dart';
import 'package:mgramseva/widgets/ListLabelText.dart';

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
              label,
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

    return Column(
      children: [
        ListLabelText("New Consumer Bill"),
        Card(
            child: Padding(
                padding: EdgeInsets.all(15),
                child: Column(children: [
                  _getLabeltext(
                      "Last Bill Generation Date",
                      DateFormats.timeStampToDate(
                              billList!.bill!.first.billDate)
                          .toString(),
                      context),
                  _getLabeltext(
                      "Current Bill",
                      (billList!.bill!.first.billDetails!.first.amount)
                          .toString(),
                      context),
                  _getLabeltext(
                      "Arrear Dues",
                      (billList!.bill!.first.billDetails!
                                  .map((ele) => ele.amount)
                                  .reduce(((previousValue, element) {
                                return previousValue! + element!;
                              }))! -
                              r)
                          .toString(),
                      context),
                  _getLabeltext("Total Amount",
                      billList!.bill!.first.totalAmount.toString(), context),
                  ButtonGroup("Collect  Payment"),
                ])))
      ],
    );
  }
}
