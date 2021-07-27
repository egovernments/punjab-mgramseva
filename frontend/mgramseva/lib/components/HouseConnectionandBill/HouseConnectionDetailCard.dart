import 'package:flutter/material.dart';
import 'package:mgramseva/constants/houseconnectiondetails.dart';

class HouseConnectionDetailCard extends StatelessWidget {
  _getLabeltext(label, value, context) {
    return (Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
            padding: EdgeInsets.only(top: 16, bottom: 16),
            width: MediaQuery.of(context).size.width / 3,
            child: Text(
              label,
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
            )),
        Container(
            alignment: Alignment.topCenter,
            padding: EdgeInsets.only(top: 16, bottom: 16),
            child: Text(value,
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400)))
      ],
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Card(
        child: Padding(
            padding: EdgeInsets.all(15),
            child: Column(
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                        padding: EdgeInsets.only(top: 16, bottom: 16),
                        width: MediaQuery.of(context).size.width / 3,
                        child: Text(
                          "Connection ID : ",
                          style: TextStyle(
                              fontSize: 24, fontWeight: FontWeight.w700),
                        )),
                    Container(
                        alignment: Alignment.topCenter,
                        padding: EdgeInsets.only(top: 16, bottom: 16),
                        child: Text(
                          " WS-12342-001",
                          style: TextStyle(
                              fontSize: 24, fontWeight: FontWeight.w700),
                        )),
                  ],
                ),
                _getLabeltext("Consumer’s Name",
                    connectiondetails['ConsumerName'], context),
                _getLabeltext(
                    "Father's Name", connectiondetails['FatherName'], context),
                _getLabeltext(
                    "Phone Number", connectiondetails['Phone Number'], context),
                _getLabeltext("Old Connection ID",
                    connectiondetails['Old Connection ID'], context),
                _getLabeltext("Address", connectiondetails['Address'], context),
                _getLabeltext("Property Type",
                    connectiondetails['Property Type'], context),
                _getLabeltext(
                    "Service Type", connectiondetails['Service Type'], context)
              ],
            )));
  }
}
