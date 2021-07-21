import 'package:flutter/material.dart';
import 'package:mgramseva/screeens/Home.dart';
import 'package:mgramseva/widgets/BaseAppBar.dart';
import 'package:mgramseva/widgets/BottonButtonBar.dart';
import 'package:mgramseva/widgets/DatePickerFieldBuilder.dart';
import 'package:mgramseva/widgets/DrawerWrapper.dart';
import 'package:mgramseva/widgets/FormWrapper.dart';
import 'package:mgramseva/widgets/HomeBack.dart';
import 'package:mgramseva/widgets/LabelText.dart';
import 'package:mgramseva/widgets/RadioButtonFieldBuilder.dart';
import 'package:mgramseva/widgets/SelectFieldBuilder.dart';
import 'package:mgramseva/widgets/SideBar.dart';
import 'package:mgramseva/routers/Routers.dart';
import 'package:mgramseva/widgets/SubLabel.dart';
import 'package:mgramseva/widgets/TextFieldBuilder.dart';

class Consumer extends StatefulWidget {
  State<StatefulWidget> createState() {
    return _ConsumerState();
  }
}

class _ConsumerState extends State<Consumer> {
  List<Map<String, dynamic>> options = [
    {"key": "MALE", "label": "Male"},
    {"key": "FEMALE", "label": "Female"},
    {"key": "Transgender", "label": "Transgender "}
  ];

  var name = new TextEditingController();
  String _gender = 'FEMALE';

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
            child: Column(
          children: [
            FormWrapper(Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  HomeBack(),
                  Card(
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                        LabelText("Consumer Details"),
                        SubLabelText(
                            "Provide below Information to create a consumer record"),
                        BuildTextField(context, 'Consumer Name', name, '', '',
                            saveInput, true),
                        RadioButtonFieldBuilder(context, 'Gender', _gender, '',
                            '', true, options, saveInput),
                        BuildTextField(context, 'Father Name', name, '', '',
                            saveInput, true),
                        BuildTextField(context, 'Phone Name', name, '', '+91-',
                            saveInput, true),
                        BuildTextField(context, 'Old Connection ID', name, '',
                            '', saveInput, true),
                        BuildTextField(context, 'Door Number', name, '', '',
                            saveInput, true),
                        BuildTextField(context, 'Street Name', name, '', '',
                            saveInput, true),
                        BuildTextField(context, 'Gram Panchayat Name', name, '',
                            '', saveInput, true),
                        SelectFieldBuilder(context, 'Property Type', name, '',
                            '', saveInput, options, true),
                        SelectFieldBuilder(context, 'Service Type', name, '',
                            '', saveInput, options, true),
                        BasicDateField("Previous Meter Reading Date", true),
                        BuildTextField(context, 'Areas (₹)', name, '', '',
                            saveInput, true),
                        SizedBox(
                          height: 20,
                        ),
                        SizedBox(
                          height: 20,
                        ),
                      ]))
                ])),
          ],
        )),
        bottomNavigationBar: BottomButtonBar('Submit', () => {}));
  }
}
