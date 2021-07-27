import 'package:flutter/material.dart';
import 'package:mgramseva/providers/consumer_details.dart';
import 'package:mgramseva/screeens/Home.dart';
import 'package:mgramseva/utils/constants.dart';
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
import 'package:mgramseva/widgets/help.dart';
import 'package:provider/provider.dart';

class ConsumerDetails extends StatefulWidget {
  State<StatefulWidget> createState() {
    return _ConsumerDetailsState();
  }
}

class _ConsumerDetailsState extends State<ConsumerDetails> {
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
        body: SingleChildScrollView(
            child: Column(
          children: [
            FormWrapper(Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  HomeBack(widget: Help()),
                  Card(
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                        LabelText("Consumer Details"),
                        SubLabelText(
                            "Provide below Information to create a consumer record"),
                        BuildTextField(
                          'Consumer Name',
                          name,
                          isRequired: true,
                        ),
                        RadioButtonFieldBuilder(context, 'Gender', _gender, '',
                            '', true, Constants.GENDER, saveInput),
                        BuildTextField(
                          'Father Name',
                          name,
                          isRequired: true,
                        ),
                        BuildTextField(
                          'Phone Name',
                          name,
                          prefixText: '+91-',
                        ),
                        BuildTextField(
                          'Old Connection ID',
                          name,
                          isRequired: true,
                        ),
                        BuildTextField(
                          'Door Number',
                          name,
                          isRequired: true,
                        ),
                        BuildTextField(
                          'Street Name',
                          name,
                        ),
                        BuildTextField(
                          'Gram Panchayat Name',
                          name,
                          isRequired: true,
                        ),
                        // SelectFieldBuilder(context, 'Property Type', name, '',
                        //     '', saveInput, options, true),
                        // SelectFieldBuilder(context, 'Service Type', name, '',
                        //     '', saveInput, options, true),
                        BasicDateField("Previous Meter Reading Date", true),
                        BuildTextField(
                          'Areas (₹)',
                          name,
                          isRequired: true,
                        ),
                      BottomButtonBar('Submit', () => {})
                      ])),
                ])),
          ],
        )),
       );
  }
}
