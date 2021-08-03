

import 'package:flutter/material.dart';
import 'package:mgramseva/model/connection/connection_payment.dart';
import 'package:mgramseva/providers/consumer_payment.dart';
import 'package:mgramseva/utils/constants.dart';
import 'package:mgramseva/utils/loaders.dart';
import 'package:mgramseva/utils/notifyers.dart';
import 'package:mgramseva/widgets/BaseAppBar.dart';
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
          })
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
      child: Wrap(
        children: [
          _buildLabelValue('safs', 'safds'),
          _buildLabelValue('safs', 'safds'),
          _buildLabelValue('safs', 'safds'),
        ],
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


  Widget _buildLabelValue(String label, String value) {
    return Table(children: [
     TableRow(
       children: [
         TableCell(
           child: Text('$label', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold))
         ),
         TableCell(
             child: Text('$value',  style: TextStyle(fontSize: 18))
         )
       ]
     )
    ]);
  }
}
