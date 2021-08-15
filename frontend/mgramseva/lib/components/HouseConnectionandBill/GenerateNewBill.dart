import 'package:flutter/material.dart';
import 'package:mgramseva/model/bill/billing.dart';
import 'package:mgramseva/utils/Constants/I18KeyConstants.dart';
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
    return Column(
      children: [
        ListLabelText(i18.generateBillDetails.GENERATE_BILL_LABEL),
        Card(
            child: Padding(
                padding: EdgeInsets.all(15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _getLabeltext(
                        i18.generateBillDetails.LAST_BILL_GENERATION_DATE,
                        DateFormats.timeStampToDate(
                                billList!.bill!.first.billDate,
                                format: "dd-MM-yyyy")
                            .toString(),
                        context),
                    _getLabeltext(
                        i18.generateBillDetails.PREVIOUS_METER_READING,
                        billList!.bill!.first.meterReadings == null
                            ? "NA".toString()
                            : billList!
                                .bill!.first.meterReadings!.last.currentReading
                                .toString(),
                        context),
                    _getLabeltext(i18.generateBillDetails.PENDING_AMOUNT,
                        billList!.bill!.first.totalAmount.toString(), context),
                    ShortButton(i18.generateBillDetails.GENERATE_NEW_BTN_LABEL,
                        () => {Navigator.pushNamed(context, 'bill/generate')})
                  ],
                )))
      ],
    );
  }
}
