import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mgramseva/model/bill/bill_payments.dart';
import 'package:mgramseva/model/connection/water_connection.dart';
import 'package:mgramseva/providers/bill_payments_provider.dart';
import 'package:mgramseva/utils/Constants/I18KeyConstants.dart';
import 'package:mgramseva/utils/Locilization/application_localizations.dart';
import 'package:mgramseva/utils/date_formats.dart';
import 'package:mgramseva/utils/loaders.dart';
import 'package:mgramseva/utils/notifyers.dart';
import 'package:mgramseva/widgets/ListLabelText.dart';
import 'package:provider/provider.dart';

class ConsumerBillPayments extends StatefulWidget {
  final WaterConnection? waterconnection;
  ConsumerBillPayments(this.waterconnection);
  @override
  State<StatefulWidget> createState() {
    return ConsumerBillPaymentsState();
  }
}

class ConsumerBillPaymentsState extends State<ConsumerBillPayments> {
  @override
  void initState() {
    WidgetsBinding.instance?.addPostFrameCallback((_) => afterViewBuild());
    super.initState();
  }

  afterViewBuild() {
    Provider.of<BillPayemntsProvider>(context, listen: false)
      ..FetchBillPayments(widget.waterconnection);
  }

  _getLabeltext(label, value, context) {
    return (Row(
      children: [
        Container(
            padding: EdgeInsets.only(top: 16, bottom: 16),
            width: MediaQuery.of(context).size.width / 3,
            child: Padding(
              padding: EdgeInsets.only(right: 10),
              child: Text(
                ApplicationLocalizations.of(context).translate(label),
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
              ),
            )),
        Text(ApplicationLocalizations.of(context).translate(value),
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400))
      ],
    ));
  }

  buildBillPaymentsView(BillPayments billpayments) {
    print(billpayments.payments!.length);
    return LayoutBuilder(builder: (context, constraints) {
      return Column(children: [
        ListLabelText(i18.consumerReciepts.CONSUMER_BILL_RECIEPTS_LABEL),
        for (var item in billpayments.payments!)
          Card(
              child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Visibility(
                visible: true,
                child: TextButton.icon(
                  onPressed: () {},
                  icon: Icon(Icons.download_sharp),
                  label: Text(
                      ApplicationLocalizations.of(context)
                          .translate(i18.common.DOWNLOAD),
                      style: TextStyle(fontSize: 19)),
                ),
              ),
              Padding(
                  padding: EdgeInsets.all(15),
                  child: Column(children: [
                    _getLabeltext(
                        i18.consumerReciepts.CONSUMER_BILL_RECIEPT_ID,
                        (item.paymentDetails!.first.receiptNumber).toString(),
                        context),
                    _getLabeltext(
                        i18.consumerReciepts.CONSUMER_RECIEPT_PAID_AMOUNT,
                        ('₹' + (item.totalAmountPaid).toString()),
                        context),
                    _getLabeltext(
                        i18.consumerReciepts.CONSUMER_RECIEPT_PAID_DATE,
                        DateFormats.timeStampToDate(item.transactionDate,
                                format: "dd-MM-yyyy")
                            .toString(),
                        context),
                    Row(children: [
                      Container(
                        width: constraints.maxWidth > 760
                            ? MediaQuery.of(context).size.width / 3
                            : MediaQuery.of(context).size.width / 1.25,
                        child: OutlinedButton.icon(
                          onPressed: null,
                          style: ButtonStyle(
                            alignment: Alignment.center,
                            padding: MaterialStateProperty.all(
                                EdgeInsets.symmetric(vertical: 0)),
                            shape: MaterialStateProperty.all(
                                RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(0.0))),
                          ),
                          icon: (Image.asset('assets/png/whats_app.png')),
                          label: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 5),
                            child: Text(
                              ApplicationLocalizations.of(context).translate(i18
                                  .consumerReciepts
                                  .CONSUMER_RECIEPT_SHARE_RECEIPT),
                            ),
                          ),
                        ),
                      )
                    ])
                  ]))
            ],
          ))
      ]);
    });
  }

  //  Text(billpayments.payments!.first.totalDue.toString());

  @override
  Widget build(BuildContext context) {
    var billpaymentsProvider =
        Provider.of<BillPayemntsProvider>(context, listen: false);
    return StreamBuilder(
        stream: billpaymentsProvider.streamController.stream,
        builder: (context, AsyncSnapshot snapshot) {
          if (snapshot.hasData) {
            return buildBillPaymentsView(snapshot.data);
          } else if (snapshot.hasError) {
            return Notifiers.networkErrorPage(context, () {});
          } else {
            switch (snapshot.connectionState) {
              case ConnectionState.waiting:
                return Loaders.CircularLoader();
              case ConnectionState.active:
                return Loaders.CircularLoader();
              default:
                return Container();
            }
          }
        });
  }
}
