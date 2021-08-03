

import 'package:flutter/material.dart';
import 'package:mgramseva/model/connection/connection_payment.dart';
import 'package:mgramseva/providers/consumer_payment.dart';
import 'package:mgramseva/utils/Constants/I18KeyConstants.dart';
import 'package:mgramseva/utils/Locilization/application_localizations.dart';
import 'package:mgramseva/utils/constants.dart';
import 'package:mgramseva/utils/loaders.dart';
import 'package:mgramseva/utils/notifyers.dart';
import 'package:mgramseva/widgets/BaseAppBar.dart';
import 'package:mgramseva/widgets/BottonButtonBar.dart';
import 'package:mgramseva/widgets/FormWrapper.dart';
import 'package:mgramseva/widgets/HomeBack.dart';
import 'package:mgramseva/widgets/RadioButtonFieldBuilder.dart';
import 'package:mgramseva/widgets/help.dart';
import 'package:provider/provider.dart';

class ConnectionPaymentView extends StatefulWidget {
  const ConnectionPaymentView({Key? key}) : super(key: key);

  @override
  _ConnectionPaymentViewState createState() => _ConnectionPaymentViewState();
}

class _ConnectionPaymentViewState extends State<ConnectionPaymentView> {


  @override
  void initState() {
    var consumerPaymentProvider = Provider.of<ConsumerPaymentProvider>(context, listen: false);
    consumerPaymentProvider.getConsumerPaymentDetails();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var consumerPaymentProvider = Provider.of<ConsumerPaymentProvider>(context, listen: false);
    late ConnectionPayment connectionDetails;
    return Scaffold(
        appBar: BaseAppBar(
          Text('mGramSeva'),
          AppBar(),
          <Widget>[Icon(Icons.more_vert)],
        ),
      body: StreamBuilder(
          stream: consumerPaymentProvider.paymentStreamController.stream,
          builder: (context, AsyncSnapshot snapshot) {
            if (snapshot.hasData) {
              connectionDetails = snapshot.data;
              return _buildView(snapshot.data);
            } else if (snapshot.hasError) {
              return Notifiers.networkErrorPage(
                  context, (){});
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
        bottomNavigationBar: BottomButtonBar('${ApplicationLocalizations.of(context).translate(i18.common.COLLECT_PAYMENT)}', () => consumerPaymentProvider.updatePaymentInformation(connectionDetails)),
    );
  }

  Widget _buildView(ConnectionPayment connectionPayment) {
     return SingleChildScrollView(
       child: FormWrapper(Column(
           mainAxisAlignment: MainAxisAlignment.start,
           crossAxisAlignment: CrossAxisAlignment.start,
           children: [
             HomeBack(widget: Help()),
             LayoutBuilder(
                 builder: (_, constraints) => Column(
                 children: [
                   _buildCoonectionDetails(connectionPayment, constraints),
                   _buildPaymentDetails(connectionPayment, constraints)
                 ],
               ),
             )
           ])),
     );
  }

  Widget _buildCoonectionDetails(ConnectionPayment connectionPayment, BoxConstraints constraints) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.only(left: 24, top: 8, bottom: 8, right: 10),
        child: Column(
          crossAxisAlignment : CrossAxisAlignment.start,
          children : [
              _buildLabelValue('${ApplicationLocalizations.of(context).translate(i18.common.CONNECTION_ID)}', '${connectionPayment.connectionId}'),
              _buildLabelValue('${ApplicationLocalizations.of(context).translate(i18.common.CONSUMER_NAME)}', '${connectionPayment.consumerName}'),
              Consumer<ConsumerPaymentProvider>(
                builder: (_, consumerPaymentProvider, child) => Visibility(
                    visible: connectionPayment.viewDetails,
                    child: _buildViewDetails(connectionPayment)
                ),
              ),
              _buildLabelValue('${ApplicationLocalizations.of(context).translate(i18.common.TOTAL_DUE_AMOUNT)}', '₹ ${connectionPayment.totalDueAmount}'),
            Consumer<ConsumerPaymentProvider>(
              builder: (_, consumerPaymentProvider, child) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: InkWell(
                  onTap: () =>  Provider.of<ConsumerPaymentProvider>(context, listen: false).onClickOfViewOrHideDetails(connectionPayment),
                  child: Text(connectionPayment.viewDetails ? '${ApplicationLocalizations.of(context).translate(i18.payment.HIDE_DETAILS)}' : '${ApplicationLocalizations.of(context).translate(i18.payment.VIEW_DETAILS)}',
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

  Widget _buildPaymentDetails(ConnectionPayment connectionPayment, BoxConstraints constraints) {
    return Consumer<ConsumerPaymentProvider>(
      builder: (_, consumerPaymentProvider, child) => Card(
        child : Wrap(
          children: [
            RadioButtonFieldBuilder(context, '${ApplicationLocalizations.of(context).translate(i18.common.PAYMENT_AMOUNT)}', connectionPayment.paymentAmount, '', '', true,
                Constants.PAYMENT_AMOUNT, (val) => consumerPaymentProvider.onChangeOfPaymentAmountOrMethod(connectionPayment, val, true)),
             RadioButtonFieldBuilder(context, '${ApplicationLocalizations.of(context).translate(i18.common.PAYMENT_METHOD)}', connectionPayment.paymentMethod, '', '', true,
          Constants.PAYMENT_METHOD, (val) => consumerPaymentProvider.onChangeOfPaymentAmountOrMethod(connectionPayment, val))
          ],
        )
      ),
    );
  }

  Widget _buildViewDetails(ConnectionPayment connectionPayment){
    return LayoutBuilder(
      builder: (_, constraints) => Column(
        crossAxisAlignment : CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 20, bottom: 10),
            child: Column(
             crossAxisAlignment : CrossAxisAlignment.start,
            children : [
              subTitle('${ApplicationLocalizations.of(context).translate(i18.common.PAYMENT_INFORMATION)}'),
            _buildLabelValue('${ApplicationLocalizations.of(context).translate(i18.payment.BILL_ID_NUMBER)}', '${connectionPayment.billIdNo}'),
            _buildLabelValue('${ApplicationLocalizations.of(context).translate(i18.payment.BILL_PERIOD)}', '${connectionPayment.billPeriod}'),
            ]),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 20, bottom: 10),
            child: Column(
              crossAxisAlignment : CrossAxisAlignment.start,
              children: [
                subTitle('${ApplicationLocalizations.of(context).translate(i18.payment.FREE_ESTIMATE)}:', 18),
                _buildLabelValue('${ApplicationLocalizations.of(context).translate(i18.common.WATER_CHARGES)}', '₹ ${connectionPayment.waterCharges}'),
                _buildLabelValue('${ApplicationLocalizations.of(context).translate(i18.common.ARREARS)}', '₹ ${connectionPayment.arrears}'),
                _buildWaterCharges(connectionPayment.waterChargesList ?? <WaterCharges>[], constraints)
              ],
            ),
          )
        ],
      ),
    );
  }


  Widget _buildWaterCharges(List<WaterCharges> waterCharges, BoxConstraints constraints) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 8, horizontal: 20),
      margin: EdgeInsets.symmetric(vertical: 5),
      decoration: BoxDecoration(
        color: Color.fromRGBO(238, 238, 238, 1),
        borderRadius: BorderRadius.circular(4)
      ),
      child: Table(
        children: waterCharges.map<TableRow>((e) => _buildWaterChargesRow(e, constraints)).toList()
      )
    );
  }

  Widget _buildLabelValue(String label, String value) {
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
              child: Text('$value',  style: TextStyle(fontSize: 16))),
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
             child: Text('$value',  style: TextStyle(fontSize: 16))
         )
       ])]));
  }

  TableRow _buildWaterChargesRow(WaterCharges waterCharges, BoxConstraints constraints) {
    var style = TextStyle(fontSize: 14, color: Color.fromRGBO(80, 90, 95, 1));
    return TableRow(
      children: [
        TableCell(
          child: constraints.maxWidth > 760 ? Text('${ApplicationLocalizations.of(context).translate(i18.common.WATER_CHARGES)} ${waterCharges.date}', style: style) : Wrap(
            direction: Axis.vertical,
            spacing: 3,
            children: [
              Text('${ApplicationLocalizations.of(context).translate(i18.common.WATER_CHARGES)}', style: style),
              Text('${waterCharges.date}', style : style),
            ],
          ),
        ),
        TableCell(
          child : Text('₹ ${waterCharges.waterCharge}')
        )
      ]
    );
  }

  Text subTitle(String label, [double? size]) => Text('$label', style: TextStyle(fontSize: size ?? 24, fontWeight: FontWeight.w700));
}
