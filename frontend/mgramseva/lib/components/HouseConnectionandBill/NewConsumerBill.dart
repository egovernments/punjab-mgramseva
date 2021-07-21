import 'package:flutter/material.dart';
import 'package:mgramseva/constants/houseconnectiondetails.dart';
import 'package:mgramseva/widgets/Button.dart';
import 'package:mgramseva/widgets/ButtonGroup.dart';
import 'package:mgramseva/widgets/ListLabelText.dart';

class NewConsumerBill extends StatelessWidget {
  _getLabeltext(label, value, context) {
    return (Row(
      children: [
        Container(
            padding: EdgeInsets.only(top: 16, bottom: 16),
            width: MediaQuery.of(context).size.width / 3,
            child: Text(
              label,
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
            )),
        Text(value, style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400))
      ],
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListLabelText("New Consumer Bill"),
        Card(
            child: Padding(
                padding: EdgeInsets.all(15),
                child: Column(children: [
                  _getLabeltext("Last Bill Generation Date",
                      connectiondetails['ConsumerName'], context),
                  _getLabeltext("Previous Meter Reading",
                      connectiondetails['FatherName'], context),
                  _getLabeltext("Pending Amount",
                      connectiondetails['Phone Number'], context),
                  ButtonGroup("Collect  Payment"),
                ])))
      ],
    );
  }
}
