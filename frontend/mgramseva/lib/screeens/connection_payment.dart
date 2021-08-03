

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
    return Scaffold(
        appBar: BaseAppBar(
          Text('mGramSeva'),
          AppBar(),
          <Widget>[Icon(Icons.more_vert)],
        ),
      body: StreamBuilder(
          stream: Provider.of<ConsumerPaymentProvider>(context, listen: false).paymentStreamController.stream,
          builder: (context, AsyncSnapshot snapshot) {
            if (snapshot.hasData) {
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
        bottomNavigationBar: BottomButtonBar('${ApplicationLocalizations.of(context).translate(i18.common.COLLECT_PAYMENT)}', (){} ),
    );
  }

  Widget _buildView(ConnectionPayment connectionPayment) {
     return SingleChildScrollView(
       child: FormWrapper(Column(
           mainAxisAlignment: MainAxisAlignment.start,
           crossAxisAlignment: CrossAxisAlignment.start,
           children: [
             HomeBack(widget: Help()),
             Column(
               children: [
                 _buildCoonectionDetails(connectionPayment),
                 _buildPaymentDetails(connectionPayment)
               ],
             )
           ])),
     );
  }

  Widget _buildCoonectionDetails(ConnectionPayment connectionPayment) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.only(left: 24, top: 10, right: 20),
        child: Column(
          crossAxisAlignment : CrossAxisAlignment.start,
          children : [
              _buildLabelValue('Connection ID', '${connectionPayment.connectionId}'),
              _buildLabelValue('Consumer Name', '${connectionPayment.consumerName}'),
              Consumer<ConsumerPaymentProvider>(
                builder: (_, consumerPaymentProvider, child) => Visibility(
                    visible: connectionPayment.viewDetails,
                    child: _buildViewDetails(connectionPayment)
                ),
              ),
              _buildLabelValue('Total Amount Due', '${connectionPayment.totalDueAmount}'),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: InkWell(
                onTap: () =>  Provider.of<ConsumerPaymentProvider>(context, listen: false).onClickOfViewOrHideDetails(connectionPayment),
                child: Text(connectionPayment.viewDetails ? 'Hide Details' : 'View Details',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400, color: Theme.of(context).primaryColor),
                ),
              ),
            )
      ]
        ),
      ),
    );
  }

  Widget _buildPaymentDetails(ConnectionPayment connectionPayment) {
    return Consumer<ConsumerPaymentProvider>(
      builder: (_, consumerPaymentProvider, child) => Card(
        child : Wrap(
          children: [
            RadioButtonFieldBuilder(context, 'Payment Amount', connectionPayment.paymentAmount, '', '', true,
                Constants.PAYMENT_AMOUNT, (val) => consumerPaymentProvider.onChangeOfPaymentAmountOrMethod(connectionPayment, val, true)),
             RadioButtonFieldBuilder(context, 'Payment Method', connectionPayment.paymentMethod, '', '', true,
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
            padding: const EdgeInsets.symmetric(vertical : 8.0),
            child: Column(
             crossAxisAlignment : CrossAxisAlignment.start,
            children : [
              subTitle('Payment Information'),
            _buildLabelValue('Bill ID No', '${connectionPayment.connectionId}'),
            _buildLabelValue('Bill Period', '${connectionPayment.connectionId}'),
            ]),
          ),
          Column(
            crossAxisAlignment : CrossAxisAlignment.start,
            children: [
              subTitle('Fee Estimate:', 18),
              _buildLabelValue('Water Charges', '${connectionPayment.connectionId}'),
              _buildLabelValue('Arrears', '${connectionPayment.connectionId}'),
              _buildWaterCharges(connectionPayment.waterChargesList ?? <WaterCharges>[], constraints)
            ],
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
    return Table(
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
       ])]);
  }

  TableRow _buildWaterChargesRow(WaterCharges waterCharges, BoxConstraints constraints) {
    var style = TextStyle(fontSize: 14, color: Color.fromRGBO(80, 90, 95, 1));
    return TableRow(
      children: [
        TableCell(
          child: constraints.maxWidth > 760 ? Text('Water Charges ${waterCharges.date}', style: style) : Wrap(
            direction: Axis.vertical,
            spacing: 3,
            children: [
              Text('Water Charges', style: style),
              Text('${waterCharges.date}', style : style),
            ],
          ),
        ),
        TableCell(
          child : Text('${waterCharges.waterCharge}')
        )
      ]
    );
  }

  Text subTitle(String label, [double? size]) => Text('$label', style: TextStyle(fontSize: size ?? 24, fontWeight: FontWeight.w700));
}
