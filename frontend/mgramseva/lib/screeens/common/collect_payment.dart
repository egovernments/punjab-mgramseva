import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_focus_watcher/flutter_focus_watcher.dart';
import 'package:mgramseva/model/common/fetch_bill.dart' as billDetails;
import 'package:mgramseva/model/common/fetch_bill.dart';
import 'package:mgramseva/providers/collect_payment.dart';
import 'package:mgramseva/services/urls.dart';
import 'package:mgramseva/utils/Constants/I18KeyConstants.dart';
import 'package:mgramseva/utils/Locilization/application_localizations.dart';
import 'package:mgramseva/utils/common_widgets.dart';
import 'package:mgramseva/utils/constants.dart';
import 'package:mgramseva/utils/date_formats.dart';
import 'package:mgramseva/utils/loaders.dart';
import 'package:mgramseva/utils/notifyers.dart';
import 'package:mgramseva/utils/validators/Validators.dart';
import 'package:mgramseva/widgets/BottonButtonBar.dart';
import 'package:mgramseva/widgets/DrawerWrapper.dart';
import 'package:mgramseva/widgets/FormWrapper.dart';
import 'package:mgramseva/widgets/HomeBack.dart';
import 'package:mgramseva/widgets/RadioButtonFieldBuilder.dart';
import 'package:mgramseva/widgets/SideBar.dart';
import 'package:provider/provider.dart';
import '../../Env/app_config.dart';
import 'package:universal_html/html.dart' as html;

import '../../providers/common_provider.dart';
import '../../utils/common_methods.dart';
import '../../utils/global_variables.dart';
import 'package:http/http.dart' as http;

import '../../widgets/customAppbar.dart';

class ConnectionPaymentView extends StatefulWidget {
  final Map<String, dynamic> query;
  const ConnectionPaymentView({Key? key, required this.query})
      : super(key: key);

  @override
  _ConnectionPaymentViewState createState() => _ConnectionPaymentViewState();
}

class _ConnectionPaymentViewState extends State<ConnectionPaymentView> {
  final formKey = GlobalKey<FormState>();
  var autoValidation = false;

  @override
  void initState() {
    var consumerPaymentProvider =
        Provider.of<CollectPaymentProvider>(context, listen: false);
    consumerPaymentProvider.getBillDetails(context, widget.query);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var consumerPaymentProvider =
        Provider.of<CollectPaymentProvider>(context, listen: false);
    FetchBill? fetchBill;
    return FocusWatcher(
        child: Scaffold(
          drawer: DrawerWrapper(
            Drawer(child: SideBar()),
          ),
          appBar: CustomAppBar(),
          body: StreamBuilder(
          stream: consumerPaymentProvider.paymentStreamController.stream,
          builder: (context, AsyncSnapshot snapshot) {
            if (snapshot.hasData) {
              if (snapshot.data is String) {
                return CommonWidgets.buildEmptyMessage(snapshot.data, context);
              }
              fetchBill = snapshot.data;
              return _buildView(snapshot.data);
            } else if (snapshot.hasError) {
              return Notifiers.networkErrorPage(
                  context,
                  () => consumerPaymentProvider.getBillDetails(
                      context, widget.query));
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
          }),
      bottomNavigationBar: Consumer<CollectPaymentProvider>(
        builder: (_, consumerPaymentProvider, child) => Visibility(
            visible: fetchBill != null,
            child: BottomButtonBar(
                '${ApplicationLocalizations.of(context).translate(i18.common.COLLECT_PAYMENT)}',
                () => paymentInfo(fetchBill!, context))),
      ),
    ));
  }

  Widget _buildView(FetchBill fetchBill) {
    return SingleChildScrollView(
      child: FormWrapper(Form(
        key: formKey,
        autovalidateMode: autoValidation
            ? AutovalidateMode.always
            : AutovalidateMode.disabled,
        child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              HomeBack(),
              LayoutBuilder(
                builder: (_, constraints) => Column(
                  children: [
                    _buildCoonectionDetails(fetchBill, constraints),
                    _buildPaymentDetails(fetchBill, constraints)
                  ],
                ),
              )
            ]),
      )),
    );
  }

  Widget _buildCoonectionDetails(
      FetchBill fetchBill, BoxConstraints constraints) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Card(
          child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildLabelValue(
                        i18.common.CONNECTION_ID, '${fetchBill.consumerCode}'),
                    _buildLabelValue(
                        i18.common.CONSUMER_NAME, '${fetchBill.payerName}'),
                  ]))),
      Card(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Consumer<CollectPaymentProvider>(
              builder: (_, consumerPaymentProvider, child) => Visibility(
                  visible: fetchBill.viewDetails,
                  child: _buildViewDetails(fetchBill)),
            ),
            _buildLabelValue(i18.common.TOTAL_DUE_AMOUNT,
                '₹ ${fetchBill.totalAmount}', FontWeight.w700),
            Consumer<CollectPaymentProvider>(
              builder: (_, consumerPaymentProvider, child) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: InkWell(
                  onTap: () => Provider.of<CollectPaymentProvider>(context,
                          listen: false)
                      .onClickOfViewOrHideDetails(fetchBill, context),
                  child: Text(
                    fetchBill.viewDetails
                        ? '${ApplicationLocalizations.of(context).translate(i18.payment.HIDE_DETAILS)}'
                        : '${ApplicationLocalizations.of(context).translate(i18.payment.VIEW_DETAILS)}',
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                        color: Theme.of(context).primaryColor),
                  ),
                ),
              ),
            )
          ]),
        ),
      )
    ]);
  }

  Widget _buildPaymentDetails(FetchBill fetchBill, BoxConstraints constraints) {
    return Consumer<CollectPaymentProvider>(
      builder: (_, consumerPaymentProvider, child) => Card(
          child: Wrap(
        children: [
          RadioButtonFieldBuilder(
              context,
              i18.common.PAYMENT_AMOUNT,
              fetchBill.paymentAmount,
              '',
              '',
              true,
              Constants.PAYMENT_AMOUNT,
              (val) => consumerPaymentProvider.onChangeOfPaymentAmountOrMethod(
                  fetchBill, val, true),
              refTextRadioBtn: Constants.PAYMENT_AMOUNT.last.key,
              secondaryBox: fetchBill.paymentAmount == Constants.PAYMENT_AMOUNT.last.key ?
              ForceFocusWatcher(
                  child: TextFormField(
                style: TextStyle(
                    fontWeight: FontWeight.w400,
                    fontSize: 16,
                    color: Theme.of(context).primaryColorDark),
                controller: fetchBill.customAmountCtrl,
                keyboardType: TextInputType.number,
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp("[0-9]"))
                ],
                validator: (val) =>
                    Validators.partialAmountValidatior(val, fetchBill.totalAmount),
                decoration: const InputDecoration(
                  prefixText: '₹ ',
                  prefixStyle: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w400),
                  errorMaxLines: 1,
                  errorStyle: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w400),
                ),
              )) : null),
          RadioButtonFieldBuilder(
              context,
              i18.common.PAYMENT_METHOD,
              fetchBill.paymentMethod,
              '',
              '',
              true,
              consumerPaymentProvider.paymentModeList,
              (val) => consumerPaymentProvider.onChangeOfPaymentAmountOrMethod(
                  fetchBill, val))
        ],
      )),
    );
  }

  Widget _buildViewDetails(FetchBill fetchBill) {
    List res = [];
    num len = fetchBill.billDetails?.first.billAccountDetails?.length as num;
    if (fetchBill.billDetails!.isNotEmpty)
      fetchBill.billDetails?.forEach((element) {
        res.add(element.amount);
      });
    return LayoutBuilder(
      builder: (_, constraints) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 20, bottom: 10),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              subTitle(i18.payment.BILL_DETAILS),
              _buildLabelValue(i18.common.BILL_ID, '${fetchBill.billNumber}'),
              _buildLabelValue(i18.payment.BILL_PERIOD,
                  '${DateFormats.getMonthWithDay(fetchBill.billDetails?.first.fromPeriod)} - ${DateFormats.getMonthWithDay(fetchBill.billDetails?.first.toPeriod)}'),
            ]),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 20, bottom: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                len > 0
                    ? Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                            _buildLabelValue(
                                'WS_${fetchBill.billDetails?.first.billAccountDetails?.last.taxHeadCode}',
                                '₹ ${fetchBill.billDetails?.first.billAccountDetails?.last.amount}'),
                            (res.reduce((value, element) => value + element) -
                                        fetchBill.billDetails?.first
                                            .billAccountDetails?.last.amount) >
                                    0
                                ? _buildLabelValue(i18.billDetails.ARRERS_DUES,
                                    '₹ ${(res.reduce((value, element) => value + element) - fetchBill.billDetails?.first.billAccountDetails?.last.amount).toString()}')
                                : SizedBox(
                                    height: 0,
                                  )
                          ])
                    : _buildLabelValue(
                        'WS_${fetchBill.billDetails?.first.billAccountDetails?.last.taxHeadCode}',
                        '₹ ${fetchBill.billDetails?.first.billAccountDetails?.last.amount}'),
                // }),
                if (fetchBill.billDetails != null && res.length > 1)
                  _buildWaterCharges(fetchBill, constraints)
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _buildWaterCharges(FetchBill bill, BoxConstraints constraints) {
    var style = TextStyle(
        fontSize: 14,
        color: Color.fromRGBO(80, 90, 95, 1),
        fontWeight: FontWeight.w400);

    return Container(
        padding: EdgeInsets.symmetric(vertical: 8, horizontal: 20),
        margin: EdgeInsets.symmetric(vertical: 5),
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(4)),
        child: constraints.maxWidth > 760
            ? Column(
                children: List.generate(bill.billDetails?.length ?? 0, (index) {
                if (index != 0) {
                  return Row(
                    children: [
                      Container(
                          width: MediaQuery.of(context).size.width / 3,
                          padding: EdgeInsets.only(top: 18, bottom: 3),
                          child: new Align(
                              alignment: Alignment.centerLeft,
                              child: _buildDemandDetails(
                                  bill, bill.billDetails![index]))),
                      Container(
                          width: MediaQuery.of(context).size.width / 2.5,
                          padding: EdgeInsets.only(top: 18, bottom: 3),
                          child: Text('₹ ${bill.billDetails![index].amount}')),
                    ],
                  );
                } else {
                  return SizedBox(
                    height: 0,
                  );
                }
              }))
            : Table(
                defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                children: List.generate(bill.billDetails?.length ?? 0, (index) {
                  if (index == 0) {
                    return TableRow(children: [
                      TableCell(child: Text("")),
                      TableCell(child: Text(""))
                    ]);
                  } else {
                    return TableRow(children: [
                      TableCell(
                          child: _buildDemandDetails(
                              bill, bill.billDetails![index])),
                      TableCell(
                          child: Text('₹ ${bill.billDetails![index].amount}',
                          textAlign: TextAlign.center,))
                    ]);
                  }
                }).toList()));
  }

  Widget _buildDemandDetails(
      FetchBill bill, billDetails.BillDetails? billdemandDetails) {
    var style = TextStyle(fontSize: 14, color: Color.fromRGBO(80, 90, 95, 1));

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Wrap(
        direction: Axis.vertical,
        spacing: 3,
        children: [
          Padding(
              padding: EdgeInsets.only(right: 8),
              child: Text(
                  '${ApplicationLocalizations.of(context).translate('BL_${billdemandDetails?.billAccountDetails?.first.taxHeadCode}')}',
                  style: style)),
          Padding(
              padding: EdgeInsets.only(right: 8),
              child: Text(
                  '${DateFormats.getMonthWithDay(billdemandDetails?.fromPeriod)}-${DateFormats.getMonthWithDay(billdemandDetails?.toPeriod)}',
                  style: style)),
        ],
      ),
    );
  }

  Widget _buildLabelValue(String label, String value,
      [FontWeight? fontWeight]) {
    return LayoutBuilder(
        builder: (_, constraints) => constraints.maxWidth > 760
            ? Row(
                children: [
                  Container(
                      width: MediaQuery.of(context).size.width / 3,
                      padding: EdgeInsets.only(top: 18, bottom: 3),
                      child: new Align(
                          alignment: Alignment.centerLeft,
                          child: subTitle('$label', 16))),
                  Container(
                      width: MediaQuery.of(context).size.width / 2.5,
                      padding: EdgeInsets.only(top: 18, bottom: 3, left: 24),
                      child: Text('$value',
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w400))),
                ],
              )
            : Table(
                defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                children: [
                    TableRow(children: [
                      TableCell(
                          child: Container(
                              alignment: Alignment.centerLeft,
                              padding: EdgeInsets.symmetric(vertical: 10),
                              child: subTitle('$label', 16))),
                      TableCell(
                          child: Text('$value',
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.w400)))
                    ])
                  ]));
  }

  paymentInfo(FetchBill fetchBill, BuildContext context) {
    var consumerPaymentProvider =
        Provider.of<CollectPaymentProvider>(context, listen: false);
    if (formKey.currentState!.validate()) {
      autoValidation = false;
      payGovTest();
    } else {
      setState(() {
        autoValidation = true;
      });
    }
  }
  Future <void> payGovTest() async {
    var redirectUrl = "https://pilot.surepay.ndml.in/SurePayPayment/sp/processRequest?additionalField3=111111&orderId=PB_PG_2022_09_22_0024_41&additionalField4=WS/7382/2022-23/0281&requestDateTime=22-09-202210:06:982&additionalField5=Watersupply01&successUrl=https://mgramseva-uat.psegs.in/pg-service/transaction/v1/_redirect?originalreturnurl=/mgramseva/home?eg_pg_txnid=PB_PG_2022_09_22_0024_41&failUrl=https://mgramseva-uat.psegs.in/pg-service/transaction/v1/_redirect?originalreturnurl=/mgramseva/home?eg_pg_txnid=PB_PG_2022_09_22_0024_41&txURL=https://pilot.surepay.ndml.in/SurePayPayment/sp/processRequest&messageType=0100&merchantId=UATPWSSG0000001429&transactionAmount=50.00&customerId=4fc9da1e-7f6f-42e6-8a89-fc13ca5f13d9&checksum=330644870&additionalField1=9399998206&additionalField2=111111&serviceId=Watersupply01&currencyCode=INR";
    var postUri = Uri.parse(redirectUrl);
    DateTime now = new DateTime.now();
    var dateStringPrefix = '${postUri.queryParameters['requestDateTime']}'.split('${now.year}');
    var request = new http.MultipartRequest("POST", postUri);
    request.headers.addAll({"access-control-allow-origin": "*"});
    request.fields['checksum'] = '${postUri.queryParameters['checksum']}';
    request.fields['messageType'] = '${postUri.queryParameters['messageType']}';
    request.fields['merchantId'] = '${postUri.queryParameters['merchantId']}';
    request.fields['serviceId'] = '${postUri.queryParameters['serviceId']}';
    request.fields['orderId'] = '${postUri.queryParameters['orderId']}';
    request.fields['customerId'] = '${postUri.queryParameters['customerId']}';
    request.fields['transactionAmount'] = '${postUri.queryParameters['transactionAmount']}';
    request.fields['currencyCode'] = '${postUri.queryParameters['currencyCode']}';
    request.fields['requestDateTime'] = '${dateStringPrefix[0]}${now.year} ${dateStringPrefix[1]}';
    request.fields['successUrl'] = '${postUri.queryParameters['successUrl']}';
    request.fields['failUrl'] = '${postUri.queryParameters['failUrl']}';
    request.fields['additionalField1'] = '${postUri.queryParameters['additionalField1']}';
    request.fields['additionalField2'] = '${postUri.queryParameters['additionalField2']}';
    request.fields['additionalField3'] = '${postUri.queryParameters['additionalField3']}';
    request.fields['additionalField4'] = '${postUri.queryParameters['additionalField4']}';
    request.fields['additionalField5'] = '${postUri.queryParameters['additionalField5']}';
    try {
      await request.send();
    }
    catch(e){
      print("Error");
      print(jsonEncode(e));
    }
  }

  Text subTitle(String label, [double? size]) =>
      Text('${ApplicationLocalizations.of(context).translate(label)}',
          style: TextStyle(fontSize: size ?? 24, fontWeight: FontWeight.w700));
}
