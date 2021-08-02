import 'package:flutter/material.dart';
import 'package:mgramseva/model/connection/property.dart';
import 'package:mgramseva/providers/consumer_details.dart';
import 'package:mgramseva/screeens/Home.dart';
import 'package:mgramseva/utils/Constants/I18KeyConstants.dart';
import 'package:mgramseva/utils/constants.dart';
import 'package:mgramseva/utils/loaders.dart';
import 'package:mgramseva/utils/notifyers.dart';
import 'package:mgramseva/widgets/BaseAppBar.dart';
import 'package:mgramseva/widgets/BottonButtonBar.dart';
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

  _onSelectItem(int index, context) {
    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (BuildContext context) => Home(),
        ),
        ModalRoute.withName(Routes.HOME));
  }

  final formKey = GlobalKey<FormState>();
  saveInput(context) async {
    print(context);
  }

  @override
  void initState() {
    WidgetsBinding.instance?.addPostFrameCallback((_) => afterViewBuild());
    super.initState();
  }

  afterViewBuild() {
    var consumerProvider =
        Provider.of<ConsumerProvider>(context, listen: false);
    consumerProvider.getConsumerDetails();
    consumerProvider.fetchBoundary();
  }

  Widget buildconsumerView(Property property) {
    return Column(
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
                      property.owners!.first.consumerNameCtrl,
                      isRequired: true,
                    ),
                    Consumer<ConsumerProvider>(
                        builder: (_, consumerProvider, child) =>
                            RadioButtonFieldBuilder(
                              context,
                              i18.common.GENDER,
                              property.owners!.first.gender,
                              '',
                              '',
                              true,
                              Constants.GENDER,
                              (val) => consumerProvider.onChangeOfGender(
                                  val, property.owners!.first),
                            )),
                    BuildTextField(
                      'Father Name',
                      property.owners!.first.fatherOrSpouseCtrl,
                      isRequired: true,
                    ),
                    BuildTextField(
                      'Phone Name',
                      property.owners!.first.phoneNumberCtrl,
                      prefixText: '+91-',
                    ),
                    // BuildTextField(
                    //   'Old Connection ID',
                    //   name,
                    //   isRequired: true,
                    // ),
                    BuildTextField(
                      'Door Number',
                      property.address!.doorNumberCtrl,
                      isRequired: true,
                    ),
                    BuildTextField(
                      'Street Name',
                      property.address!.streetNameOrNumberCtrl,
                    ),
                    // BuildTextField(
                    //   'Gram Panchayat Name',
                    //   name,
                    //   isRequired: true,
                    // ),
                    Consumer<ConsumerProvider>(
                        builder: (_, consumerProvider, child) =>
                            SelectFieldBuilder(
                                'Ward Name/ Number',
                                property.address!.localityCtrl,
                                '',
                                '',
                                consumerProvider.onChangeOflocaity,
                                consumerProvider.getBoundaryList(),
                                true)),
                    // SelectFieldBuilder(context, 'Service Type', name, '',
                    //     '', saveInput, options, true),
                    // BasicDateField("Previous Meter Reading Date", true,
                    //     TextEditingController()),
                    // BuildTextField(
                    //   'Areas (₹)',
                    //   name,
                    //   isRequired: true,
                    // ),
                    SizedBox(
                      height: 20,
                    ),
                  ])),
            ])),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    var userProvider = Provider.of<ConsumerProvider>(context, listen: false);

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
            child: Container(
                child: StreamBuilder(
                    stream: userProvider.streamController.stream,
                    builder: (context, AsyncSnapshot snapshot) {
                      if (snapshot.hasData) {
                        return buildconsumerView(snapshot.data);
                      } else if (snapshot.hasError) {
                        return Notifiers.networkErrorPage(context, () {});
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
                    }))),
        bottomNavigationBar: BottomButtonBar(
            'Submit', () => {userProvider.validateExpensesDetails()}));
  }
}
