import 'package:flutter/material.dart';
import 'package:mgramseva/routers/Routers.dart';
import 'package:mgramseva/screeens/GenerateBill/widgets/MeterReading.dart';
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
  List<Map<String, dynamic>> services = [
    {"key": "BILLING_SERVICE", "label": "Billing Service"},
    {"key": "PROPERTY_SERVICE", "label": "Property Service"},
    {"key": "RENTAL_SERVICE", "label": "Rental Service"},
  ];

  List<Map<String, dynamic>> property = [
    {"key": "RESIDENTIAL", "label": "Residential"},
    {"key": "NON_RESIDENTIAL", "label": "Non Residential"},
  ];
  List<Map<String, dynamic>> servicetype = [
    {"key": "METER_CONNECTION", "label": "Meter Connection"},
    {"key": "NON_METER_CONNECTION", "label": "Non Meter Connection"},
  ];
  List<Map<String, dynamic>> metnum = [
    {"key": "1234456", "label": "1234456"},
    {"key": "1233456", "label": "1233456"},
    {"key": "1234556", "label": "1234556"},
  ];
  var serviceCat = new TextEditingController();
  var serviceType = new TextEditingController();
  var propertyType = new TextEditingController();
  var meterNumber = new TextEditingController();

  _onSelectItem(int index, context) {
    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (BuildContext context) => Home(index),
        ),
        ModalRoute.withName(Routes.home));
  }

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
          Drawer(child: SideBar((value) => _onSelectItem(value, context))),
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
                    SizedBox(
                      height: 20,
                    )
                  ]))
            ]))),
        bottomNavigationBar: BottomButtonBar('Generate Bill', () => {}));
  }
}
