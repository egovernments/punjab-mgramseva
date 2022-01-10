import 'dart:async';
import 'dart:typed_data';
import 'package:mgramseva/providers/language.dart';

import '../components/HouseConnectionandBill/jsconnnector.dart' as js;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:mgramseva/Env/app_config.dart';
import 'package:mgramseva/model/bill/bill_payments.dart';
import 'package:mgramseva/model/common/fetch_bill.dart';
import 'package:mgramseva/model/success_handler.dart';
import 'package:mgramseva/providers/household_details_provider.dart';
import 'package:mgramseva/repository/consumer_details_repo.dart';
import 'package:mgramseva/repository/core_repo.dart';
import 'package:mgramseva/routers/Routers.dart';
import 'package:mgramseva/services/MDMS.dart';
import 'package:mgramseva/utils/Locilization/application_localizations.dart';
import 'package:mgramseva/utils/common_printer.dart';
import 'package:mgramseva/utils/constants.dart';
import 'package:mgramseva/utils/custom_exception.dart';
import 'package:mgramseva/utils/date_formats.dart';
import 'package:mgramseva/utils/error_logging.dart';
import 'package:mgramseva/utils/Constants/I18KeyConstants.dart';
import 'package:mgramseva/utils/global_variables.dart';
import 'package:mgramseva/utils/loaders.dart';
import 'package:mgramseva/utils/models.dart';
import 'package:mgramseva/utils/notifyers.dart';
import 'package:mgramseva/widgets/CommonSuccessPage.dart';
import 'package:number_to_words/number_to_words.dart';
import 'package:provider/provider.dart';
import 'package:screenshot/screenshot.dart';
import 'package:image/image.dart' as img;
import 'common_provider.dart';

class CollectPaymentProvider with ChangeNotifier {
  var paymentStreamController = StreamController.broadcast();

  ScreenshotController screenshotController = ScreenshotController();
  var paymentModeList = <KeyValue>[];

  @override
  void dispose() {
    paymentStreamController.close();
    super.dispose();
  }

  Future<void> getBillDetails(
      BuildContext context, Map<String, dynamic> query) async {
    try {
      var paymentDetails = await ConsumerRepository().getBillDetails(query);
      if (paymentDetails != null) {
        paymentDetails.first.billDetails
            ?.sort((a, b) => b.fromPeriod!.compareTo(a.fromPeriod!));
        // var demandDetails = await ConsumerRepository().getDemandDetails(query);
        // if (demandDetails != null)
        // paymentDetails.first.demand = demandDetails.first;
        getPaymentModes(paymentDetails.first);
        paymentStreamController.add(paymentDetails.first);
        notifyListeners();
      }
    } on CustomException catch (e, s) {
      if (ErrorHandler.handleApiException(context, e, s)) {
        paymentStreamController.add(e.code ?? e.message);
        return;
      }
      paymentStreamController.addError('error');
    } catch (e, s) {
      ErrorHandler.logError(e.toString(), s);
      paymentStreamController.addError('error');
    }
  }

  getprinterlabel(key, value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
            margin: EdgeInsets.zero,
            padding: EdgeInsets.zero,
            width: kIsWeb ? 150 : 65,
            child: Text(
                ApplicationLocalizations.of(navigatorKey.currentContext!)
                    .translate(key),
                maxLines: 3,
                textScaleFactor: kIsWeb ? 2.5 : 1,
                textAlign: TextAlign.start,
                style: TextStyle(
                    color: Colors.red,
                    fontSize: kIsWeb ? 5 : 6,
                    fontWeight: FontWeight.w900))),
        Container(
            width: kIsWeb ? 215 : 85,
            child: Text(
              ApplicationLocalizations.of(navigatorKey.currentContext!)
                  .translate(value),
              maxLines: 3,
              overflow: TextOverflow.fade,
              textAlign: TextAlign.start,
              textScaleFactor: kIsWeb ? 2.5 : 1,
              style: TextStyle(
                  color: Colors.red,
                  fontSize: kIsWeb ? 5 : 6,
                  fontWeight: FontWeight.w900),
            )),
      ],
    );
  }

  Future<Uint8List?> _capturePng(item, FetchBill fetchBill) async {
    item.paymentDetails!.last.bill!.billDetails
        ?.sort((a, b) => b.fromPeriod!.compareTo(a.fromPeriod!));

    var stateProvider = Provider.of<LanguageProvider>(
        navigatorKey.currentContext!,
        listen: false);

    var commonProvider = Provider.of<CommonProvider>(
        navigatorKey.currentContext!,
        listen: false);

    var houseHoldProvider = Provider.of<HouseHoldProvider>(
        navigatorKey.currentContext!,
        listen: false);

    // getBluetooth();
    screenshotController
        .captureFromWidget(Container(
            width: 375,
            margin: EdgeInsets.all(10),
            padding: EdgeInsets.all(10),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    kIsWeb
                        ? SizedBox(
                            width: 70,
                            height: 70,
                          )
                        : Image(
                            width: 40,
                            height: 40,
                            image: NetworkImage(stateProvider
                                .stateInfo!.stateLogoURL
                                .toString())),
                    Container(
                      width: kIsWeb ? 290 : 90,
                      margin: EdgeInsets.all(5),
                      child: Text(
                        ApplicationLocalizations.of(
                                navigatorKey.currentContext!)
                            .translate(i18.consumerReciepts
                                .GRAM_PANCHAYAT_WATER_SUPPLY_AND_SANITATION),
                        textScaleFactor: kIsWeb ? 3 : 1,
                        maxLines: 3,
                        style: TextStyle(
                            color: Colors.blue,
                            fontSize: 10,
                            height: 1,
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
                Container(
                    width: kIsWeb
                        ? MediaQuery.of(navigatorKey.currentContext!).size.width
                        : 90,
                    margin: EdgeInsets.all(5),
                    child: Text(
                        ApplicationLocalizations.of(
                                navigatorKey.currentContext!)
                            .translate(i18.consumerReciepts.WATER_RECEIPT),
                        textScaleFactor: kIsWeb ? 3 : 1,
                        style: TextStyle(
                          color: Colors.blue,
                          fontSize: 10,
                          height: 1,
                          fontWeight: FontWeight.bold,
                        ))),
                SizedBox(
                  height: 8,
                ),
                getprinterlabel(
                    i18.consumerReciepts.RECEIPT_GPWSC_NAME,
                    ApplicationLocalizations.of(navigatorKey.currentContext!)
                        .translate(
                            commonProvider.userDetails!.selectedtenant!.code!)),
                getprinterlabel(i18.consumerReciepts.RECEIPT_CONSUMER_NO,
                    fetchBill.consumerCode),
                getprinterlabel(
                  i18.consumerReciepts.RECEIPT_CONSUMER_NAME,
                  item.paidBy,
                ),
                getprinterlabel(i18.consumerReciepts.RECEIPT_CONSUMER_MOBILE_NO,
                    item.mobileNumber),
                getprinterlabel(
                    i18.consumerReciepts.RECEIPT_CONSUMER_ADDRESS,
                    ApplicationLocalizations.of(navigatorKey.currentContext!)
                            .translate(houseHoldProvider
                                .waterConnection!.additionalDetails!.doorNo
                                .toString()) +
                        " " +
                        ApplicationLocalizations.of(navigatorKey.currentContext!)
                            .translate(houseHoldProvider
                                .waterConnection!.additionalDetails!.street
                                .toString()) +
                        " " +
                        ApplicationLocalizations.of(navigatorKey.currentContext!)
                            .translate(houseHoldProvider
                                .waterConnection!.additionalDetails!.locality
                                .toString()) +
                        " " +
                        ApplicationLocalizations.of(navigatorKey.currentContext!)
                            .translate(
                                commonProvider.userDetails!.selectedtenant!.code!)),
                SizedBox(
                  height: 10,
                ),
                getprinterlabel(
                    i18.consumer.SERVICE_TYPE,
                    houseHoldProvider.waterConnection!.connectionType
                        .toString()),
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
                            item.paymentDetails.first.bill.billDetails.first
                                .fromPeriod,
                            format: "dd/MM/yyyy") +
                        '-' +
                        DateFormats.timeStampToDate(
                                item.paymentDetails.first.bill.billDetails.first
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
                SizedBox(
                  height: 5,
                ),
                Text('- - *** - -',
                    textScaleFactor: kIsWeb ? 3 : 1,
                    textAlign: TextAlign.start,
                    style: TextStyle(
                        color: Colors.red,
                        fontSize: 6,
                        fontWeight: FontWeight.bold)),
                SizedBox(
                  height: 10,
                ),
                Text(
                    "${ApplicationLocalizations.of(navigatorKey.currentContext!).translate(i18.common.RECEIPT_FOOTER)}",
                    textScaleFactor: kIsWeb ? 3 : 1,
                    textAlign: TextAlign.start,
                    style: TextStyle(
                        color: Colors.red,
                        fontSize: 6,
                        fontWeight: FontWeight.bold))
              ],
            )))
        .then((value) => {
              kIsWeb
                  ? js.onButtonClick(
                      value, stateProvider.stateInfo!.stateLogoURL.toString())
                  : CommonPrinter.printTicket(
                      img.decodeImage(value), navigatorKey.currentContext!)
              // print(value as Image),
            });
  }

  Future<void> getPaymentModes(FetchBill fetchBill) async {
    paymentModeList = <KeyValue>[];
    var commonProvider = Provider.of<CommonProvider>(
        navigatorKey.currentContext!,
        listen: false);
    var res = await CoreRepository().getMdms(getMdmsPaymentModes(
        commonProvider.userDetails!.userRequest!.tenantId.toString()));
    if (res.mdmsRes?.billingService != null &&
        res.mdmsRes?.billingService?.businessServiceList != null) {
      Constants.PAYMENT_METHOD.forEach((e) {
        var index = res.mdmsRes?.billingService?.businessServiceList?.first
            .collectionModesNotAllowed!
            .indexOf(e.key);
        if (index == -1) {
          paymentModeList.add(KeyValue(e.key, e.label));
        }
      });
      fetchBill.paymentMethod = paymentModeList.first.key;
      notifyListeners();
    }
  }

  Future<void> updatePaymentInformation(
      FetchBill fetchBill, BuildContext context) async {
    var commonProvider = Provider.of<CommonProvider>(context, listen: false);

    var amount = fetchBill.paymentAmount == Constants.PAYMENT_AMOUNT.last.key
        ? fetchBill.customAmountCtrl.text
        : fetchBill.totalAmount;
    var payment = {
      "Payment": {
        "tenantId": commonProvider.userDetails?.selectedtenant?.code,
        "paymentMode": fetchBill.paymentMethod,
        "paidBy": fetchBill.payerName,
        "mobileNumber": fetchBill.mobileNumber,
        "totalAmountPaid": amount,
        "paymentDetails": [
          {
            "businessService": fetchBill.businessService,
            "billId": fetchBill.billDetails?.first.billId,
            "totalAmountPaid": amount,
          }
        ]
      }
    };

    try {
      Loaders.showLoadingDialog(context);

      var paymentDetails = await ConsumerRepository().collectPayment(payment);
      if (paymentDetails != null && paymentDetails.payments!.length > 0) {
        print(paymentDetails.payments);
        Navigator.pop(context);
        Navigator.of(context).pushReplacement(
            new MaterialPageRoute(builder: (BuildContext context) {
          print(paymentDetails.payments!.first.paymentDetails?.first.bill
              ?.waterConnection?.connectionNo);
          return CommonSuccess(
            SuccessHandler(
                i18.common.PAYMENT_COMPLETE,
                '${ApplicationLocalizations.of(context).translate(i18.payment.RECEIPT_REFERENCE_WITH_MOBILE_NUMBER)} (+91 ${fetchBill.mobileNumber})',
                i18.common.BACK_HOME,
                Routes.HOUSEHOLD_DETAILS_SUCCESS,
                subHeader:
                    '${ApplicationLocalizations.of(context).translate(i18.common.RECEIPT_NO)} \n ${paymentDetails.payments!.first.paymentDetails!.first.receiptNumber}',
                downloadLink: i18.common.RECEIPT_DOWNLOAD,
                whatsAppShare: i18.common.SHARE_RECEIPTS,
                downloadLinkLabel: i18.common.RECEIPT_DOWNLOAD,
                printLabel: i18.consumerReciepts.CONSUMER_RECEIPT_PRINT,
                subtitleFun: () =>
                    getSubtitleDynamicLocalization(context, fetchBill),
                subHeaderFun: () =>
                    getSubHeaderDynamicLocalization(context, paymentDetails)),
            callBackdownload: () => commonProvider.getFileFromPDFPaymentService(
                {
                  "Payments": [paymentDetails.payments!.first]
                },
                {
                  "key": paymentDetails.payments?.first.paymentDetails?.first
                              .bill?.waterConnection?.connectionType ==
                          'Metered'
                      ? "ws-receipt"
                      : "ws-receipt-nm",
                  "tenantId": commonProvider.userDetails!.selectedtenant!.code,
                },
                paymentDetails.payments!.first.mobileNumber,
                paymentDetails.payments!.first,
                "Download"),
            callBackprint: () =>
                _capturePng(paymentDetails.payments?.first, fetchBill),
            callBackwatsapp: () => commonProvider.getFileFromPDFPaymentService({
              "Payments": [paymentDetails.payments!.first]
            }, {
              "key": paymentDetails.payments?.first.paymentDetails?.first.bill
                          ?.waterConnection?.connectionType ==
                      'Metered'
                  ? "ws-receipt"
                  : "ws-receipt-nm",
              "tenantId": commonProvider.userDetails!.selectedtenant!.code,
            }, paymentDetails.payments!.first.mobileNumber,
                paymentDetails.payments!.first, "Share"),
            backButton: true,
          );
        }));
      }
    } on CustomException catch (e, s) {
      Navigator.pop(context);
      if (ErrorHandler.handleApiException(context, e, s)) {
        Notifiers.getToastMessage(context, e.message, 'ERROR');
      }
    } catch (e, s) {
      Navigator.pop(context);
      Notifiers.getToastMessage(context, e.toString(), 'ERROR');
      ErrorHandler.logError(e.toString(), s);
    }
  }

  String getSubtitleDynamicLocalization(
      BuildContext context, FetchBill fetchBill) {
    String localizationText = '';
    localizationText =
        '${ApplicationLocalizations.of(context).translate(i18.payment.RECEIPT_REFERENCE_WITH_MOBILE_NUMBER)}';
    localizationText = localizationText.replaceFirst(
        '{Number}', '(+91 - ${fetchBill.mobileNumber})');
    return localizationText;
  }

  String getSubHeaderDynamicLocalization(
      BuildContext context, BillPayments paymentDetails) {
    return '${ApplicationLocalizations.of(context).translate(i18.common.RECEIPT_NO)} \n ${paymentDetails.payments!.first.paymentDetails!.first.receiptNumber}';
  }

  onClickOfViewOrHideDetails(FetchBill fetchBill, BuildContext context) {
    fetchBill.viewDetails = !fetchBill.viewDetails;
    notifyListeners();
  }

  onChangeOfPaymentAmountOrMethod(FetchBill fetchBill, String val,
      [isPaymentAmount = false]) {
    if (isPaymentAmount) {
      fetchBill.paymentAmount = val;
    } else {
      fetchBill.paymentMethod = val;
    }
    notifyListeners();
  }
}
