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
  final String? mode;

  const NewConsumerBill(this.billList, this.mode);
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
    var commonProvider = Provider.of<CommonProvider>(context, listen: false);
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
        : LayoutBuilder(builder: (context, constraints) {
            return Column(
              children: [
                ListLabelText(i18.billDetails.NEW_CONSUMERGENERATE_BILL_LABEL),
                Card(
                    child: Padding(
                        padding: EdgeInsets.all(15),
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Visibility(
                                visible: true,
                                child: TextButton.icon(
                                  onPressed: () => commonProvider
                                      .getFileFromPDFService({
                                    "Bill": [billList!.bill!.first]
                                  }, {
                                    "key": "consolidatedbill",
                                    "tenantId": commonProvider
                                        .userDetails!.selectedtenant!.code,
                                  }, billList!.bill!.first.mobileNumber,
                                          "Download"),
                                  icon: Icon(Icons.download_sharp),
                                  label: Text(
                                      ApplicationLocalizations.of(context)
                                          .translate(i18.common.BILL_DOWNLOAD),
                                      style: TextStyle(fontSize: 19)),
                                ),
                              ),
                              _getLabeltext(
                                  i18.generateBillDetails.LAST_BILL_GENERATION_DATE,
                                  DateFormats.timeStampToDate(
                                          billList!.bill!.first.billDate,
                                          format: "dd-MM-yyyy")
                                      .toString(),
                                  context),
                              _getLabeltext(
                                  i18.billDetails.CURRENT_BILL,
                                  ('₹' +
                                      (billList!.bill!.first.billDetails!.first
                                              .amount)
                                          .toString()),
                                  context),
                              _getLabeltext(
                                  i18.billDetails.ARRERS_DUES,
                                  ('₹' +
                                      (billList!.bill!.first.billDetails!
                                                  .map((ele) => ele.amount)
                                                  .reduce(((previousValue,
                                                      element) {
                                                return previousValue! +
                                                    element!;
                                              }))! -
                                              r)
                                          .toString()),
                                  context),
                              _getLabeltext(
                                  i18.billDetails.TOTAL_AMOUNT,
                                  ('₹' +
                                      billList!.bill!.first.totalAmount
                                          .toString()),
                                  context),
                              this.mode == 'collect'
                                  ? Align(
                                      alignment: Alignment.centerLeft,
                                      child: ButtonGroup(
                                          i18.billDetails.COLLECT_PAYMENT,
                                          () => commonProvider
                                                  .getFileFromPDFService(
                                                      {
                                                    "Bill": [
                                                      billList!.bill!.first
                                                    ]
                                                  },
                                                      {
                                                    "key": "consolidatedbill",
                                                    "tenantId": commonProvider
                                                        .userDetails!
                                                        .selectedtenant!
                                                        .code,
                                                  },
                                                      billList!.bill!.first
                                                          .mobileNumber,
                                                      "Share"),
                                          () => onClickOfCollectPayment(
                                              billList!.bill!.first, context)))
                                  : Container(
                                      width: constraints.maxWidth > 760
                                          ? MediaQuery.of(context).size.width /
                                              3
                                          : MediaQuery.of(context).size.width /
                                              1.25,
                                      child: OutlinedButton.icon(
                                        onPressed: () => commonProvider
                                            .getFileFromPDFService({
                                          "Bill": [billList!.bill!.first]
                                        }, {
                                          "key": "consolidatedbill",
                                          "tenantId": commonProvider
                                              .userDetails!
                                              .selectedtenant!
                                              .code,
                                        }, billList!.bill!.first.mobileNumber,
                                                "Share"),
                                        style: ButtonStyle(
                                          alignment: Alignment.center,
                                          padding: MaterialStateProperty.all(
                                              EdgeInsets.symmetric(
                                                  vertical: 0)),
                                          shape: MaterialStateProperty.all(
                                              RoundedRectangleBorder(
                                            side: BorderSide(
                                                width: 2,
                                                color: Theme.of(context)
                                                    .primaryColor),
                                            borderRadius:
                                                BorderRadius.circular(0.0),
                                          )),
                                        ),
                                        icon: (Image.asset(
                                            'assets/png/whats_app.png')),
                                        label: Padding(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 5),
                                          child: Text(
                                            ApplicationLocalizations.of(context)
                                                .translate(i18.consumerReciepts
                                                    .CONSUMER_RECIEPT_SHARE_RECEIPT),
                                          ),
                                        ),
                                      ),
                                    ),
                            ])))
              ],
            );
          });
  }

  void onClickOfCollectPayment(Bill bill, BuildContext context) {
    var commonProvider = Provider.of<CommonProvider>(context, listen: false);

    Map<String, dynamic> query = {
      'consumerCode': bill.consumerCode,
      'businessService': bill.businessService,
      'tenantId': commonProvider.userDetails?.selectedtenant?.code
    };
    Navigator.pushNamed(context, Routes.HOUSEHOLD_DETAILS_COLLECT_PAYMENT,
        arguments: query);
  }
}
