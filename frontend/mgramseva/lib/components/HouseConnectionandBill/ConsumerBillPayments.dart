import 'dart:convert';
import 'dart:typed_data';
import 'dart:io';
import 'dart:typed_data';
import 'package:image/image.dart' as img;
import 'package:bluetooth_thermal_printer/bluetooth_thermal_printer.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mgramseva/Env/app_config.dart';
import 'package:mgramseva/model/bill/bill_payments.dart';
import 'package:mgramseva/model/connection/water_connection.dart';
import 'package:mgramseva/providers/bill_payments_provider.dart';
import 'package:mgramseva/providers/common_provider.dart';
import 'package:mgramseva/utils/Constants/I18KeyConstants.dart';
import 'package:mgramseva/utils/Locilization/application_localizations.dart';
import 'package:mgramseva/utils/common_printer.dart';
import 'package:mgramseva/utils/date_formats.dart';
import 'package:mgramseva/utils/global_variables.dart';
import 'package:mgramseva/utils/loaders.dart';
import 'package:mgramseva/utils/notifyers.dart';
import 'package:mgramseva/widgets/ListLabelText.dart';
import 'package:provider/provider.dart';
import 'package:screenshot/screenshot.dart';
import 'package:number_to_words/number_to_words.dart';

class ConsumerBillPayments extends StatefulWidget {
  final WaterConnection? waterconnection;
  ConsumerBillPayments(this.waterconnection);
  @override
  State<StatefulWidget> createState() {
    return ConsumerBillPaymentsState();
  }
}

class ConsumerBillPaymentsState extends State<ConsumerBillPayments> {
  Uint8List? _imageFile;

  ScreenshotController screenshotController = ScreenshotController();
  @override
  void initState() {
    WidgetsBinding.instance?.addPostFrameCallback((_) => afterViewBuild());
    super.initState();
  }

  getprinterlabel(key, value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
            width: 65,
            child: Text(ApplicationLocalizations.of(context).translate(key),
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 6,
                    fontWeight: FontWeight.bold))),
        Container(
          width: 85,
          child: Text(
              ApplicationLocalizations.of(navigatorKey.currentContext!)
                  .translate(value),
              maxLines: 2,
              style: TextStyle(
                color: Colors.black,
                fontSize: 6,
              )),
        ),
      ],
    );
  }

  Future<Uint8List?> _capturePng(item) async {
    var commonProvider = Provider.of<CommonProvider>(
        navigatorKey.currentContext!,
        listen: false);
    screenshotController
        .captureFromWidget(Container(
            margin: EdgeInsets.zero,
            padding: EdgeInsets.zero,
            width: 150,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Image(
                        width: 20,
                        height: 40,
                        image: NetworkImage(
                          apiBaseUrl +
                              '/mgramseva-dev-assets/logo/punjab-logo.png',
                        )),
                    Container(
                      width: 90,
                      margin: EdgeInsets.all(5),
                      child: Text(
                        ApplicationLocalizations.of(
                                navigatorKey.currentContext!)
                            .translate(i18.consumerReciepts
                                .GRAM_PANCHAYAT_WATER_SUPPLY_AND_SANITATION),
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 12,
                            height: 1.2,
                            fontWeight: FontWeight.bold,
                            fontStyle: FontStyle.italic),
                        textAlign: TextAlign.left,
                      ),
                    )
                  ],
                ),
                SizedBox(
                  height: 5,
                ),
                Text(
                    ApplicationLocalizations.of(navigatorKey.currentContext!)
                        .translate(i18.consumerReciepts.WATER_RECEIPT),
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 12,
                      height: 1,
                      fontWeight: FontWeight.bold,
                    )),
                SizedBox(
                  height: 8,
                ),
                getprinterlabel(
                    i18.consumerReciepts.RECEIPT_GPWSC_NAME,
                    ApplicationLocalizations.of(navigatorKey.currentContext!)
                        .translate(
                            commonProvider.userDetails!.selectedtenant!.code!)),
                getprinterlabel(i18.consumerReciepts.RECEIPT_CONSUMER_NO,
                    widget.waterconnection!.connectionNo),
                getprinterlabel(
                  i18.consumerReciepts.RECEIPT_CONSUMER_NAME,
                  widget.waterconnection!.connectionHolders!.first.name,
                ),
                getprinterlabel(i18.consumerReciepts.RECEIPT_CONSUMER_MOBILE_NO,
                    item.mobileNumber),
                getprinterlabel(
                    i18.consumerReciepts.RECEIPT_CONSUMER_ADDRESS,
                    ApplicationLocalizations.of(navigatorKey.currentContext!)
                            .translate(widget
                                .waterconnection!.additionalDetails!.doorNo
                                .toString()) +
                        ApplicationLocalizations.of(navigatorKey.currentContext!)
                            .translate(widget
                                .waterconnection!.additionalDetails!.street
                                .toString()) +
                        ApplicationLocalizations.of(navigatorKey.currentContext!)
                            .translate(widget
                                .waterconnection!.additionalDetails!.locality
                                .toString()) +
                        " " +
                        ApplicationLocalizations.of(navigatorKey.currentContext!)
                            .translate(
                                commonProvider.userDetails!.selectedtenant!.code!)),
                SizedBox(
                  height: 10,
                ),
                getprinterlabel(i18.consumer.SERVICE_TYPE,
                    widget.waterconnection?.connectionType),
                getprinterlabel(i18.consumerReciepts.CONSUMER_RECEIPT_NO,
                    item.paymentDetails!.first.receiptNumber),
                getprinterlabel(
                    i18.consumerReciepts.RECEIPT_ISSUE_DATE,
                    DateFormats.timeStampToDate(item.transactionDate,
                            format: "dd/MM/yyyy")
                        .toString()),
                getprinterlabel(
                    i18.consumerReciepts.RECEIPT_BILL_PERIOD,
                    DateFormats.timeStampToDate(
                            item.paymentDetails.first.bill.billDetails.last
                                .fromPeriod,
                            format: "dd/MM/yyyy") +
                        '-' +
                        DateFormats.timeStampToDate(
                                item.paymentDetails.first.bill.billDetails.last
                                    .toPeriod,
                                format: "dd/MM/yyyy")
                            .toString()),
                SizedBox(
                  height: 10,
                ),
                getprinterlabel(i18.consumerReciepts.RECEIPT_AMOUNT_PAID,
                    ('₹' + (item.totalAmountPaid).toString())),
                getprinterlabel(
                    i18.consumerReciepts.RECEIPT_AMOUNT_IN_WORDS,
                    ('Rupees ' +
                        (NumberToWord()
                            .convert('en-in', item.totalAmountPaid.toInt())
                            .toString()) +
                        ' only')),
              ],
            )))
        .then((value) => {
              // js.context.callMethod('onButtonClick', []);
              CommonPrinter.printTicket(
                  img.decodeImage(value), navigatorKey.currentContext!),
              // print(value as Image),
            });
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
    var commonProvider = Provider.of<CommonProvider>(context, listen: false);
    return LayoutBuilder(builder: (context, constraints) {
      return Container(
          padding: EdgeInsets.only(top: 16, bottom: 16),
          child: Column(children: [
            billpayments.payments!.length > 0
                ? ListLabelText(
                    i18.consumerReciepts.CONSUMER_BILL_RECIEPTS_LABEL)
                : Text(""),
            for (var item in billpayments.payments!)
              Card(
                  child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                      padding: EdgeInsets.all(8),
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Visibility(
                              visible: true,
                              child: TextButton.icon(
                                onPressed: () => commonProvider
                                    .getFileFromPDFPaymentService({
                                  "Payments": [item]
                                }, {
                                  "key":
                                      widget.waterconnection?.connectionType ==
                                              'Metered'
                                          ? "ws-receipt"
                                          : "ws-receipt-nm",
                                  "tenantId": commonProvider
                                      .userDetails!.selectedtenant!.code,
                                }, item.mobileNumber, item, "Download"),
                                icon: Icon(Icons.download_sharp),
                                label: Text(
                                    ApplicationLocalizations.of(context)
                                        .translate(i18.common.RECEIPT_DOWNLOAD),
                                    style: TextStyle(fontSize: 16)),
                              ),
                            ),
                            _getLabeltext(
                                i18.consumerReciepts.RECEIPT_CONSUMER_NO,
                                (item.paymentDetails!.first.receiptNumber)
                                    .toString(),
                                context),
                            _getLabeltext(
                                i18.consumerReciepts
                                    .CONSUMER_RECIEPT_PAID_AMOUNT,
                                ('₹' + (item.totalAmountPaid).toString()),
                                context),
                            _getLabeltext(
                                i18.consumerReciepts.CONSUMER_RECIEPT_PAID_DATE,
                                DateFormats.timeStampToDate(
                                        item.transactionDate,
                                        format: "dd/MM/yyyy")
                                    .toString(),
                                context),
                          ])),
                  Row(children: [
                    Container(
                      width: constraints.maxWidth > 760
                          ? MediaQuery.of(context).size.width / 3
                          : MediaQuery.of(context).size.width / 2.2,
                      child: OutlinedButton.icon(
                        onPressed: () =>
                            commonProvider.getFileFromPDFPaymentService({
                          "Payments": [item]
                        }, {
                          "key": widget.waterconnection?.connectionType ==
                                  'Metered'
                              ? "ws-receipt"
                              : "ws-receipt-nm",
                          "tenantId":
                              commonProvider.userDetails!.selectedtenant!.code,
                        }, item.mobileNumber, item, "Share"),
                        style: ButtonStyle(
                          alignment: Alignment.center,
                          padding: MaterialStateProperty.all(
                              EdgeInsets.symmetric(vertical: 8)),
                          shape:
                              MaterialStateProperty.all(RoundedRectangleBorder(
                            side: BorderSide(
                                width: 2,
                                color: Theme.of(context).primaryColor),
                            borderRadius: BorderRadius.circular(0.0),
                          )),
                        ),
                        icon: (Image.asset('assets/png/whats_app.png')),
                        label: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 5),
                          child: Text(
                            ApplicationLocalizations.of(context).translate(i18
                                .consumerReciepts
                                .CONSUMER_RECIEPT_SHARE_RECEIPT),
                            style: Theme.of(context).textTheme.subtitle2,
                          ),
                        ),
                      ),
                    ),
                    Container(
                      width: constraints.maxWidth > 760
                          ? MediaQuery.of(context).size.width / 3
                          : MediaQuery.of(context).size.width / 2.2,
                      child: ElevatedButton.icon(
                          onPressed: () => _capturePng(item),
                          icon: Icon(Icons.print),
                          label: Text(
                              ApplicationLocalizations.of(context).translate(
                                  i18.consumerReciepts.CONSUMER_RECEIPT_PRINT),
                              style: Theme.of(context)
                                  .textTheme
                                  .subtitle1!
                                  .apply(color: Colors.white))),
                    ),
                  ])
                ],
              ))
          ]));
    });
  }

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
