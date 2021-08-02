import 'package:flutter/material.dart';
import 'package:mgramseva/routers/Routers.dart';
import 'package:mgramseva/screeens/GenerateBill/widgets/MeterReading.dart';
import 'package:mgramseva/utils/common_methods.dart';
import 'package:mgramseva/utils/models.dart';
import 'package:mgramseva/widgets/BaseAppBar.dart';
import 'package:mgramseva/widgets/BottonButtonBar.dart';
import 'package:mgramseva/widgets/DrawerWrapper.dart';
import 'package:mgramseva/widgets/FormWrapper.dart';
import 'package:mgramseva/widgets/HomeBack.dart';
import 'package:mgramseva/widgets/LabelText.dart';

import 'package:mgramseva/widgets/SelectFieldBuilder.dart';
import 'package:mgramseva/widgets/SideBar.dart';

import '../Home.dart';

class GenerateBill extends StatefulWidget {
  State<StatefulWidget> createState() {
    return _GenerateBillState();
  }
}

class _GenerateBillState extends State<GenerateBill> {
  var services = [
    KeyValue("BILLING_SERVICE", "Billing Service"),
  KeyValue("PROPERTY_SERVICE", "Property Service"),
  KeyValue("RENTAL_SERVICE", "Rental Service"),
  ];

  var property = [
  KeyValue("RESIDENTIAL", "Residential"),
  KeyValue("NON_RESIDENTIAL", "Non Residential"),
  ];
 var servicetype = [
  KeyValue("METER_CONNECTION", "Meter Connection"),
  KeyValue("NON_METER_CONNECTION", "Non Meter Connection"),
  ];
 var metnum = [
  KeyValue("1234456",  "1234456"),
  KeyValue("1233456", "1233456"),
  KeyValue("1234556", "1234556"),
  ];
  var serviceCat = new TextEditingController();
  var serviceType = new TextEditingController();
  var propertyType = new TextEditingController();
  var meterNumber = new TextEditingController();


  final formKey = GlobalKey<FormState>();
  saveInput(context) async {
    print(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: BaseAppBar(
          Text('mGramSeva'),
          AppBar(),
          <Widget>[Icon(Icons.more_vert)],
        ),
        drawer: DrawerWrapper(
          Drawer(child: SideBar()),
        ),
        body: SingleChildScrollView(
            child: FormWrapper(Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
              HomeBack(),
              Card(
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                    LabelText("Generate Consumer Bill"),
                    SelectFieldBuilder(context, 'Service Category', serviceCat,
                        '', '', saveInput, services, true),
                    SelectFieldBuilder(context, 'Property Type', serviceType,
                        '', '', saveInput, property, true),
                    SelectFieldBuilder(context, 'Service Type', propertyType,
                        '', '', saveInput, servicetype, true),
                    SelectFieldBuilder(context, 'Meter Number', meterNumber, '',
                        '', saveInput, metnum, true),
                    MeterReading("Previous Meter Reading"),
                    MeterReading("New Meter Reading"),
                   BottomButtonBar('Generate Bill', () => {})
                  ]))
            ]))));
  }
}
