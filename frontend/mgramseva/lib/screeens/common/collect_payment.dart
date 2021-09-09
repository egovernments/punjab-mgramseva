import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mgramseva/model/common/fetch_bill.dart' as billDetails;
import 'package:mgramseva/model/common/fetch_bill.dart';
import 'package:mgramseva/providers/collect_payment.dart';
import 'package:mgramseva/utils/Constants/I18KeyConstants.dart';
import 'package:mgramseva/utils/Locilization/application_localizations.dart';
import 'package:mgramseva/utils/common_widgets.dart';
import 'package:mgramseva/utils/constants.dart';
import 'package:mgramseva/utils/date_formats.dart';
import 'package:mgramseva/utils/loaders.dart';
import 'package:mgramseva/utils/notifyers.dart';
import 'package:mgramseva/widgets/BaseAppBar.dart';
import 'package:mgramseva/widgets/BottonButtonBar.dart';
import 'package:mgramseva/widgets/FormWrapper.dart';
import 'package:mgramseva/widgets/HomeBack.dart';
import 'package:mgramseva/widgets/RadioButtonFieldBuilder.dart';
import 'package:mgramseva/widgets/TextFieldBuilder.dart';
import 'package:provider/provider.dart';

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
    return Scaffold(
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
    );
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
                  fetchBill, val, true)),
          if (fetchBill.paymentAmount == Constants.PAYMENT_AMOUNT.last.key)
            BuildTextField(
              '${i18.common.CUSTOM_AMOUNT}',
              fetchBill.customAmountCtrl,
              isRequired: true,
              textInputType: TextInputType.number,
              inputFormatter: [
                FilteringTextInputFormatter.allow(RegExp("[0-9]"))
              ],
              labelSuffix: '(₹)',
            ),
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
                  '${DateFormats.getMonthWithDay(fetchBill.billDetails?.last.fromPeriod)} - ${DateFormats.getMonthWithDay(fetchBill.billDetails?.last.toPeriod)}'),
            ]),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 20, bottom: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ...List.generate(fetchBill.billDetails?.length ?? 0, (index) {
                  var billAccountDetails = fetchBill.billDetails?[index];
                  return _buildLabelValue(
                      'WS_${billAccountDetails!.billAccountDetails?.last.taxHeadCode}',
                      '₹ ${billAccountDetails.billAccountDetails?.last.amount}');
                }),
                if (fetchBill.demand != null)
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
                        child: Text('₹ ${bill.paymentAmount}')),
                  ],
                );
              }))
            : Table(
                defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                children: List.generate(bill.billDetails?.length ?? 0, (index) {
                  return TableRow(children: [
                    TableCell(
                        child: _buildDemandDetails(
                            bill, bill.billDetails![index])),
                    TableCell(child: Text('₹ ${bill.paymentAmount}'))
                  ]);
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
          Text(
              '${ApplicationLocalizations.of(context).translate('WS_$billdemandDetails?.billAccountDetails?.first.taxHeadCode')}',
              style: style),
          Text(
              '${DateFormats.getMonthWithDay(billdemandDetails?.fromPeriod)}-${DateFormats.getMonthWithDay(billdemandDetails?.toPeriod)}',
              style: style),
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
      consumerPaymentProvider.updatePaymentInformation(fetchBill, context);
    } else {
      setState(() {
        autoValidation = true;
      });
    }
  }

  Text subTitle(String label, [double? size]) =>
      Text('${ApplicationLocalizations.of(context).translate(label)}',
          style: TextStyle(fontSize: size ?? 24, fontWeight: FontWeight.w700));
}
