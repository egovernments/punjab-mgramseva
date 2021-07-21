import 'package:flutter/material.dart';
import 'package:mgramseva/constants/consumersearchdetails.dart';
import 'package:mgramseva/widgets/LabelText.dart';
import 'package:mgramseva/widgets/ShortButton.dart';

class SearchConnectionDetailCard extends StatelessWidget {
  _getDetailtext(label, value, context) {
    return (Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
            padding: EdgeInsets.only(top: 16, bottom: 16),
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
    return LayoutBuilder(builder: (context, constraints) {
      return Column(children: [
        // ignore: unnecessary_null_comparison
        LabelText(ConsumerSearchDetailsList.length.toString() != null
            ? ConsumerSearchDetailsList.length.toString() + " consumer(s) Found"
            : "0" + " consumer(s) Found"),
        Container(
            height: MediaQuery.of(context).size.height - 200,
            child: ListView.builder(
                padding: const EdgeInsets.all(8),
                itemCount: ConsumerSearchDetailsList.length,
                itemBuilder: (BuildContext context, int index) {
                  return Card(
                      child: Padding(
                          padding: EdgeInsets.all(15),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _getDetailtext(
                                  "New Connection ID",
                                  ConsumerSearchDetailsList[index]
                                          ['connectionId']
                                      .toString(),
                                  context),
                              _getDetailtext(
                                  "Old Connection ID",
                                  ConsumerSearchDetailsList[index]
                                          ['oldConnectioId']
                                      .toString(),
                                  context),
                              _getDetailtext(
                                  "Consumer’s Name",
                                  ConsumerSearchDetailsList[index]
                                          ['consumername']
                                      .toString(),
                                  context),
                              _getDetailtext(
                                  "Phone Number",
                                  ConsumerSearchDetailsList[index]['mobnumber']
                                      .toString(),
                                  context),
                              _getDetailtext(
                                  "Household Address",
                                  ConsumerSearchDetailsList[index]
                                          ['householdAddress']
                                      .toString(),
                                  context),
                              SizedBox(
                                height: 20,
                              ),
                              ShortButton(
                                  'View Household Details',
                                  () => Navigator.pushNamed(
                                      context, 'household/details')),
                              SizedBox(
                                height: 20,
                              ),
                            ],
                          )));
                }))
      ]);
    });
  }
}
