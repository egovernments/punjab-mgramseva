
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mgramseva/model/common/demand.dart';
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

import '../customAppbar.dart';

class ConnectionPaymentView extends StatefulWidget {
  final Map<String, dynamic> query;
  const ConnectionPaymentView({Key? key, required this.query}) : super(key: key);

  @override
  _ConnectionPaymentViewState createState() => _ConnectionPaymentViewState();
}

class _ConnectionPaymentViewState extends State<ConnectionPaymentView> {
  final formKey = GlobalKey<FormState>();
  var autoValidation = false;

  @override
  void initState() {
    var consumerPaymentProvider = Provider.of<CollectPaymentProvider>(context, listen: false);
    consumerPaymentProvider.getBillDetails(context, widget.query);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var consumerPaymentProvider = Provider.of<CollectPaymentProvider>(context, listen: false);
    FetchBill? fetchBill;
    return Scaffold(
      appBar: CustomAppBar(),
      body: StreamBuilder(
          stream: consumerPaymentProvider.paymentStreamController.stream,
          builder: (context, AsyncSnapshot snapshot) {
            if (snapshot.hasData) {
              if(snapshot.data is String){
                return CommonWidgets.buildEmptyMessage(snapshot.data, context);
              }
              fetchBill = snapshot.data;
              return _buildView(snapshot.data);
            } else if (snapshot.hasError) {
              return Notifiers.networkErrorPage(
                  context, () => consumerPaymentProvider.getBillDetails(context, widget.query));
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
            child: BottomButtonBar('${ApplicationLocalizations.of(context).translate(i18.common.COLLECT_PAYMENT)}', () => paymentInfo(fetchBill!, context))),
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

  Widget _buildCoonectionDetails(FetchBill fetchBill, BoxConstraints constraints) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.only(left: 24, top: 8, bottom: 8, right: 10),
        child: Column(
            crossAxisAlignment : CrossAxisAlignment.start,
            children : [
              _buildLabelValue(i18.common.CONNECTION_ID, '${fetchBill.consumerCode}'),
              _buildLabelValue(i18.common.CONSUMER_NAME, '${fetchBill.payerName}'),
              Consumer<CollectPaymentProvider>(
                builder: (_, consumerPaymentProvider, child) => Visibility(
                    visible: fetchBill.viewDetails,
                    child: _buildViewDetails(fetchBill)
                ),
              ),
              _buildLabelValue(i18.common.TOTAL_DUE_AMOUNT, '₹ ${fetchBill.totalAmount}', FontWeight.w700),
              Consumer<CollectPaymentProvider>(
                builder: (_, consumerPaymentProvider, child) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: InkWell(
                    onTap: () =>  Provider.of<CollectPaymentProvider>(context, listen: false).onClickOfViewOrHideDetails(fetchBill, context),
                    child: Text(fetchBill.viewDetails ? '${ApplicationLocalizations.of(context).translate(i18.payment.HIDE_DETAILS)}' : '${ApplicationLocalizations.of(context).translate(i18.payment.VIEW_DETAILS)}',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400, color: Theme.of(context).primaryColor),
                    ),
                  ),
                ),
              )
            ]
        ),
      ),
    );
  }

  Widget _buildPaymentDetails(FetchBill fetchBill, BoxConstraints constraints) {
    return Consumer<CollectPaymentProvider>(
      builder: (_, consumerPaymentProvider, child) => Card(
          child : Wrap(
            children: [
              RadioButtonFieldBuilder(context, i18.common.PAYMENT_AMOUNT, fetchBill.paymentAmount, '', '', true,
                  Constants.PAYMENT_AMOUNT, (val) => consumerPaymentProvider.onChangeOfPaymentAmountOrMethod(fetchBill, val, true)),
              if(fetchBill.paymentAmount == Constants.PAYMENT_AMOUNT.last.key)
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
              RadioButtonFieldBuilder(context, i18.common.PAYMENT_METHOD, fetchBill.paymentMethod, '', '', true,
                  Constants.PAYMENT_METHOD, (val) => consumerPaymentProvider.onChangeOfPaymentAmountOrMethod(fetchBill, val))
            ],
          )
      ),
    );
  }

  Widget _buildViewDetails(FetchBill fetchBill){
    return LayoutBuilder(
      builder: (_, constraints) => Column(
        crossAxisAlignment : CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 20, bottom: 10),
            child: Column(
                crossAxisAlignment : CrossAxisAlignment.start,
                children : [
                  subTitle(i18.common.PAYMENT_INFORMATION),
                  _buildLabelValue(i18.payment.BILL_ID_NUMBER, '${fetchBill.billNumber}'),
                  _buildLabelValue(i18.payment.BILL_PERIOD, '${DateFormats.getMonthWithDay(fetchBill.billDetails?.first?.fromPeriod)} - ${DateFormats.getMonthWithDay(fetchBill.billDetails?.first?.toPeriod)}'),
                ]),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 20, bottom: 10),
            child: Column(
              crossAxisAlignment : CrossAxisAlignment.start,
              children: [
                subTitle(i18.payment.FREE_ESTIMATE, 18),
                ...List.generate(fetchBill.billDetails?.first.billAccountDetails?.length ?? 0, (index)
                {
                  var billAccountDetails = fetchBill.billDetails?.first.billAccountDetails?[index];
                  return  _buildLabelValue(billAccountDetails!.taxHeadCode,
                      '₹ ${billAccountDetails!.amount}');
                }),
                if(fetchBill.demand != null) _buildWaterCharges(fetchBill.demand!, constraints)
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _buildWaterCharges(Demand demand, BoxConstraints constraints) {
    var style = TextStyle(fontSize: 14, color: Color.fromRGBO(80, 90, 95, 1));

    return Container(
        padding: EdgeInsets.symmetric(vertical: 8, horizontal: 20),
        margin: EdgeInsets.symmetric(vertical: 5),
        decoration: BoxDecoration(
            color: Color.fromRGBO(238, 238, 238, 1),
            borderRadius: BorderRadius.circular(4)
        ),
        child: constraints.maxWidth > 760 ?
        Column(
            children: List.generate(demand.demandDetails?.length ?? 0, (index) {
              var demandDetails = demand.demandDetails![index];
              return Row(
                children: [
                  Container(
                      width: MediaQuery.of(context).size.width / 3,
                      padding: EdgeInsets.only(top: 18, bottom: 3),
                      child: new Align(
                          alignment: Alignment.centerLeft,
                          child: _buildDemandDetails(demand, demandDetails))),
                  Container(
                      width: MediaQuery.of(context).size.width / 2.5,
                      padding: EdgeInsets.only(top: 18, bottom: 3),
                      child: Text('₹ ${demandDetails.taxAmount}')),
                ],
              );
            }
            ))
            : Table(
            defaultVerticalAlignment: TableCellVerticalAlignment.middle,
            children : List.generate(demand.demandDetails?.length ?? 0, (index) {
              var demandDetails = demand.demandDetails![index];
              return TableRow(
                  children: [
                    TableCell(
                        child: _buildDemandDetails(demand, demandDetails)
                    ),
                    TableCell(
                        child : Text('₹ ${demandDetails.taxAmount}')
                    )
                  ]
              );
            }).toList())
    );
  }

  Widget _buildDemandDetails(Demand demand, DemandDetails demandDetails) {
    var style = TextStyle(fontSize: 14, color: Color.fromRGBO(80, 90, 95, 1));

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Wrap(
        direction: Axis.vertical,
        spacing: 3,
        children: [
          Text('${ApplicationLocalizations.of(context).translate(
              demandDetails.taxHeadMasterCode)}', style: style),
          Text('${DateFormats.getMonthWithDay(demand.taxPeriodFrom)}-${DateFormats
              .getMonthWithDay(demand.taxPeriodTo)}', style: style),
        ],
      ),
    );
  }

  Widget _buildLabelValue(String label, String value, [FontWeight? fontWeight]) {
    return LayoutBuilder(
        builder: (_, constraints) => constraints.maxWidth > 760 ? Row(
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
                child: Text('$value',  style: TextStyle(fontSize: 16, fontWeight: fontWeight))),
          ],
        ) : Table(
            defaultVerticalAlignment: TableCellVerticalAlignment.middle,
            children : [
              TableRow(
                  children: [
                    TableCell(
                        child: Container(
                            alignment: Alignment.centerLeft,
                            padding: EdgeInsets.symmetric(vertical: 10),
                            child: subTitle('$label', 16))
                    ),
                    TableCell(
                        child: Text('$value',  style: TextStyle(fontSize: 16, fontWeight: fontWeight))
                    )
                  ])]));
  }
  paymentInfo(FetchBill fetchBill, BuildContext context){
    var consumerPaymentProvider = Provider.of<CollectPaymentProvider>(context, listen: false);
    if(formKey.currentState!.validate()){
      autoValidation = false;
      consumerPaymentProvider.updatePaymentInformation(fetchBill, context);
    } else {
      setState(() {
        autoValidation = true;
      });
    }
  }
  Text subTitle(String label, [double? size]) => Text('${ApplicationLocalizations.of(context).translate(label)}', style: TextStyle(fontSize: size ?? 24, fontWeight: FontWeight.w700));
}