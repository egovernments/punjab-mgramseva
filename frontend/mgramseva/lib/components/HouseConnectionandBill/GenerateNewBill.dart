import 'package:flutter/material.dart';
import 'package:mgramseva/constants/houseconnectiondetails.dart';
import 'package:mgramseva/model/bill/billing.dart';
import 'package:mgramseva/utils/date_formats.dart';
import 'package:mgramseva/widgets/ListLabelText.dart';
import 'package:mgramseva/widgets/ShortButton.dart';

class GenerateNewBill extends StatelessWidget {
  final BillList? billList;

  const GenerateNewBill(this.billList);

  _getLabeltext(label, value, context) {
    return (Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
            padding: EdgeInsets.only(top: 16, bottom: 16),
            width: MediaQuery.of(context).size.width / 3,
            child: Text(
              label,
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
            )),
        Container(
            padding: EdgeInsets.only(top: 16, bottom: 16),
            child: Text(value,
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400)))
      ],
    ));
  }

  @override
  Widget build(BuildContext context) {
    print(billList!.bill!.first.meterReadings == null);
    // (billList!.bill!.sort((a, b) => a.taxPeriodFrom! - b.taxPeriodFrom!));
    // print(billList!.bill!.map((e) => e.demandDetails!.first.taxAmount));
    return Column(
      children: [
        ListLabelText("Generate Bill"),
        Card(
            child: Padding(
                padding: EdgeInsets.all(15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _getLabeltext(
                        "Last Bill Generation Date",
                        DateFormats.timeStampToDate(
                                billList!.bill!.first.billDate)
                            .toString(),
                        context),
                    _getLabeltext(
                        "Previous Meter Reading",
                        billList!.bill!.first.meterReadings == null
                            ? ""
                            : DateFormats.timeStampToDate(billList!.bill!.first
                                    .meterReadings!.first.currentReadingDate)
                                .toString(),
                        context),
                    _getLabeltext("Pending Amount",
                        billList!.bill!.first.totalAmount.toString(), context),
                    ShortButton("Generate New Bill",
                        () => {Navigator.pushNamed(context, 'bill/generate')})
                  ],
                )))
      ],
    );
  }
}
