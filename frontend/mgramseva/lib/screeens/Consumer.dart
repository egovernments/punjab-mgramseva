import 'package:flutter/material.dart';
import 'package:mgramseva/models/house_connection.dart';
import 'package:mgramseva/providers/consumer_details.dart';
import 'package:mgramseva/screeens/Home.dart';
import 'package:mgramseva/utils/loaders.dart';
import 'package:mgramseva/utils/notifyers.dart';
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
import 'package:provider/provider.dart';

class ConsumerDetails extends StatefulWidget {

  State<StatefulWidget> createState() {
    return _ConsumerDetailsState();
  }
}

class _ConsumerDetailsState extends State<ConsumerDetails> {
  List<Map<String, dynamic>> options = [
    {"key": "MALE", "label": "Male"},
    {"key": "FEMALE", "label": "Female"},
    {"key": "Transgender", "label": "Transgender "}
  ];

  @override
  void initState() {
    var consumerProvider = Provider.of<ConsumerProvider>(context, listen: false);
    // consumerProvider.getConsumerDetails();
    WidgetsBinding.instance?.addPostFrameCallback((_) => afterViewBuild());

    super.initState();
  }

  afterViewBuild(){
    var consumerProvider = Provider.of<ConsumerProvider>(context, listen: false);
    consumerProvider.getConsumerDetails();
  }

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
    var consumerProvider = Provider.of<ConsumerProvider>(context, listen: false);

    return Scaffold(
        appBar: BaseAppBar(
          Text('mGramSeva'),
          AppBar(),
          <Widget>[Icon(Icons.more_vert)],
        ),
        drawer: DrawerWrapper(
          Drawer(child: SideBar((value) => _onSelectItem(value, context))),
        ),
        body:     StreamBuilder(
            stream: consumerProvider.streamController.stream,
            builder: (context, AsyncSnapshot snapshot) {
              if (snapshot.hasData) {
                return _buildConsumerView(snapshot.data);
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
        ,
        bottomNavigationBar: BottomButtonBar('Submit', () => {}));
  }


  Widget _buildConsumerView(HouseConnection houseConnection) {
    return SingleChildScrollView(
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
                            BuildTextField(context, 'Consumer Name', houseConnection.consumerNameCtrl, '', '',
                                saveInput, true),
                            RadioButtonFieldBuilder(context, 'Gender', houseConnection.gender!, '',
                                '', true, options, saveInput),
                            BuildTextField(context, 'Father Name', houseConnection.fatherOrSpouseCtrl, '', '',
                                saveInput, true),
                            BuildTextField(context, 'Phone Name', houseConnection.phoneNumberCtrl, '', '+91-',
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
        ));
  }
}
