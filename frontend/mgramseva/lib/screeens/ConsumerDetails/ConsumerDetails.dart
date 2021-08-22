import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mgramseva/model/connection/property.dart';
import 'package:mgramseva/model/connection/water_connection.dart';
import 'package:mgramseva/providers/common_provider.dart';
import 'package:mgramseva/providers/consumer_details_provider.dart';
import 'package:mgramseva/screeens/ConsumerDetails/ConsumerDetailsWalkThrough/WalkFlowContainer.dart';
import 'package:mgramseva/screeens/ConsumerDetails/ConsumerDetailsWalkThrough/walkthrough.dart';
import 'package:mgramseva/screeens/GenerateBill/widgets/MeterReading.dart';
import 'package:mgramseva/utils/Constants/I18KeyConstants.dart';
import 'package:mgramseva/utils/constants.dart';
import 'package:mgramseva/utils/global_variables.dart';
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
import 'package:mgramseva/widgets/SubLabel.dart';
import 'package:mgramseva/widgets/TableText.dart';
import 'package:mgramseva/widgets/TextFieldBuilder.dart';
import 'package:mgramseva/widgets/help.dart';
import 'package:provider/provider.dart';

class ConsumerDetails extends StatefulWidget {
  final String? id;
  final WaterConnection? waterconnection;

  const ConsumerDetails({Key? key, this.id, this.waterconnection})
      : super(key: key);
  State<StatefulWidget> createState() {
    return _ConsumerDetailsState();
  }
}

class _ConsumerDetailsState extends State<ConsumerDetails> {
  saveInput(context) async {
    print(context);
  }

  @override
  void initState() {
    if (widget.waterconnection != null) {
      WidgetsBinding.instance?.addPostFrameCallback((_) {
        var commonProvider = Provider.of<CommonProvider>(
            navigatorKey.currentContext!,
            listen: false);
        Provider.of<ConsumerProvider>(context, listen: false)
          ..setModel()
          ..setWaterConnection(widget.waterconnection)
          ..getConnectionTypePropertyTypeTaxPeriod()
          ..getProperty({
            "tenantId": commonProvider.userDetails!.selectedtenant!.code,
            "propertyIds": widget.waterconnection!.propertyId
          })
          ..fetchBoundary()
          ..autoValidation = false
          ..formKey = GlobalKey<FormState>()
          ..setwallthrough(ConsumerWalkThrough().consumerWalkThrough.map((e) {
            e.key = GlobalKey();
            return e;
          }).toList());
      });
    } else if (widget.id != null) {
    } else {
      WidgetsBinding.instance?.addPostFrameCallback((_) => afterViewBuild());
    }

    super.initState();
  }

  dispose() {
    super.dispose();
  }

  afterViewBuild() {
    Provider.of<ConsumerProvider>(context, listen: false)
      ..setModel()
      ..getConnectionTypePropertyTypeTaxPeriod()
      ..getConsumerDetails()
      ..fetchBoundary()
      ..autoValidation = false
      ..formKey = GlobalKey<FormState>()
      ..setwallthrough(ConsumerWalkThrough().consumerWalkThrough.map((e) {
        e.key = GlobalKey();
        return e;
      }).toList());

    /*WidgetsBinding.instance!.addPostFrameCallback((_) => ShowCaseWidget.of(consumerWalkThrough.consumerContext!)!.startShowCase([
      consumerWalkThrough.consumerNameKey
    ]));*/
  }

  Widget buildconsumerView(Property property) {
    return Column(
      children: [
        FormWrapper(Consumer<ConsumerProvider>(
            builder: (_, consumerProvider, child) => Form(
                key: consumerProvider.formKey,
                autovalidateMode: consumerProvider.autoValidation
                    ? AutovalidateMode.always
                    : AutovalidateMode.disabled,
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      HomeBack(
                          widget: Help(
                        callBack: () => showGeneralDialog(
                          barrierLabel: "Label",
                          barrierDismissible: false,
                          barrierColor: Colors.black.withOpacity(0.5),
                          transitionDuration: Duration(milliseconds: 700),
                          context: context,
                          pageBuilder: (context, anim1, anim2) {
                            return WalkThroughContainer((index) =>
                                consumerProvider.incrementindex(
                                    index,
                                    consumerProvider
                                        .consmerWalkthrougList[index + 1].key));
                          },
                          transitionBuilder: (context, anim1, anim2, child) {
                            return SlideTransition(
                              position:
                                  Tween(begin: Offset(0, 1), end: Offset(0, 0))
                                      .animate(anim1),
                              child: child,
                            );
                          },
                        ),
                      )),
                      Card(
                          child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                            //Heading
                            LabelText(consumerProvider.isEdit
                                ? i18.consumer.CONSUMER_EDIT_DETAILS_LABEL
                                : i18.consumer.CONSUMER_DETAILS_LABEL),
                            //Sub Heading
                            SubLabelText(consumerProvider.isEdit
                                ? i18.consumer.CONSUMER_EDIT_DETAILS_SUB_LABEL
                                : i18.consumer.CONSUMER_DETAILS_SUB_LABEL),
                            //Conniction ID displayed based in Edit Mode
                            consumerProvider.isEdit
                                ? BuildTableText(
                                    i18.consumer.CONSUMER_CONNECTION_ID,
                                    consumerProvider
                                        .waterconnection.connectionNo
                                        .toString())
                                : Container(child: Text("")),
                            //Consumer Name Field
                            BuildTextField(
                              i18.consumer.CONSUMER_NAME,
                              property.owners!.first.consumerNameCtrl,
                              inputFormatter: [
                                FilteringTextInputFormatter.allow(
                                    RegExp("[A-Za-z ]"))
                              ],
                              isRequired: true,
                              contextkey:
                                  consumerProvider.consmerWalkthrougList[0].key,
                            ),

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
                              contextkey:
                                  consumerProvider.consmerWalkthrougList[1].key,
                            ),

                            BuildTextField(
                              i18.consumer.FATHER_SPOUSE_NAME,
                              property.owners!.first.fatherOrSpouseCtrl,
                              isRequired: true,
                              inputFormatter: [
                                FilteringTextInputFormatter.allow(
                                    RegExp("[A-Za-z ]"))
                              ],
                              contextkey:
                                  consumerProvider.consmerWalkthrougList[2].key,
                            ),

                            //Consumer Phone Number Field

                            BuildTextField(
                              i18.common.PHONE_NUMBER,
                              property.owners!.first.phoneNumberCtrl,
                              prefixText: '+91-',
                              isRequired: true,
                              textInputType: TextInputType.number,
                              maxLength: 10,
                              inputFormatter: [
                                FilteringTextInputFormatter.allow(
                                    RegExp("[0-9]"))
                              ],
                              contextkey:
                                  consumerProvider.consmerWalkthrougList[3].key,
                            ),

                            //Consumer Old Connection Field
                            Consumer<ConsumerProvider>(
                              builder: (_, consumerProvider, child) =>
                                  BuildTextField(
                                i18.consumer.OLD_CONNECTION_ID,
                                consumerProvider
                                    .waterconnection.OldConnectionCtrl,
                                isRequired: true,
                                contextkey: consumerProvider
                                    .consmerWalkthrougList[4].key,
                              ),
                            ),
                            //Consumer Door Number Field
                            BuildTextField(
                              i18.consumer.DOOR_NO,
                              property.address.doorNumberCtrl,
                            ),
                            //Consumer Street Field
                            BuildTextField(
                              i18.consumer.STREET_NUM_NAME,
                              property.address.streetNameOrNumberCtrl,
                              isRequired: true,
                            ),
                            BuildTextField(
                              i18.consumer.GP_NAME,
                              property.address.gpNameCtrl,
                              isRequired: true,
                              readOnly: true,
                              isDisabled: true,
                            ),

                            //Consumer Ward Field
                            Consumer<ConsumerProvider>(
                                builder: (_, consumerProvider, child) =>
                                    consumerProvider.boundaryList.length > 1
                                        ? SelectFieldBuilder(
                                            i18.consumer.WARD,
                                            property.address.localityCtrl,
                                            '',
                                            '',
                                            consumerProvider.onChangeOflocaity,
                                            consumerProvider.getBoundaryList(),
                                            true,
                                            contextkey: consumerProvider
                                                .consmerWalkthrougList[5].key)
                                        : Text("")),
                            //Consumer Property Type Field
                            Consumer<ConsumerProvider>(
                              builder: (_, consumerProvider, child) =>
                                  SelectFieldBuilder(
                                i18.consumer.PROPERTY_TYPE,
                                property.propertyType,
                                '',
                                '',
                                consumerProvider.onChangeOfPropertyType,
                                consumerProvider.getPropertTypeList(),
                                true,
                                contextkey: consumerProvider
                                    .consmerWalkthrougList[6].key,
                              ),
                            ),
                            //Consumer Service Type Field
                            Consumer<ConsumerProvider>(
                                builder: (_, consumerProvider, child) => Column(
                                      children: [
                                        SelectFieldBuilder(
                                            i18.consumer.SERVICE_TYPE,
                                            consumerProvider
                                                .waterconnection.connectionType,
                                            '',
                                            '',
                                            consumerProvider
                                                .onChangeOfConnectionType,
                                            consumerProvider
                                                .getConnectionTypeList(),
                                            true,
                                            contextkey: consumerProvider
                                                .consmerWalkthrougList[7].key),

                                        //Consumer Service Type Field),
                                        consumerProvider.waterconnection
                                                    .connectionType !=
                                                'Metered'
                                            ? Container()
                                            : Column(
                                                children: [
                                                  //Consumer Previous MeterReading Date Picker Field
                                                  consumerProvider.isEdit ==
                                                              false ||
                                                          consumerProvider.isfirstdemand ==
                                                              false
                                                      ? BasicDateField(
                                                          i18.consumer
                                                              .PREV_METER_READING_DATE,
                                                          true,
                                                          consumerProvider
                                                              .waterconnection
                                                              .previousReadingDateCtrl,
                                                          lastDate:
                                                              DateTime.now(),
                                                          onChangeOfDate:
                                                              consumerProvider
                                                                  .onChangeOfDate)
                                                      : Text(""),
                                                  BuildTextField(
                                                    i18.consumer.METER_NUMBER,
                                                    consumerProvider
                                                        .waterconnection
                                                        .meterIdCtrl,
                                                    isRequired: true,
                                                    inputFormatter: [
                                                      FilteringTextInputFormatter
                                                          .allow(RegExp(
                                                              "[a-zA-Z0-9]"))
                                                    ],
                                                  ),
                                                  consumerProvider.isEdit ==
                                                              false ||
                                                          consumerProvider
                                                                  .isfirstdemand ==
                                                              false
                                                      ? MeterReading(
                                                          i18.demandGenerate
                                                              .PREV_METER_READING_LABEL,
                                                          consumerProvider
                                                              .waterconnection
                                                              .om_1Ctrl,
                                                          consumerProvider
                                                              .waterconnection
                                                              .om_2Ctrl,
                                                          consumerProvider
                                                              .waterconnection
                                                              .om_3Ctrl,
                                                          consumerProvider
                                                              .waterconnection
                                                              .om_4Ctrl,
                                                          consumerProvider
                                                              .waterconnection
                                                              .om_5Ctrl,
                                                          isRequired: true,
                                                        )
                                                      : Text(""),
                                                ],
                                              ),
                                        consumerProvider.waterconnection
                                                    .connectionType !=
                                                'Non Metered'
                                            ? Container()
                                            : Consumer<
                                                    ConsumerProvider>(
                                                builder: (_, consumerProvider,
                                                        child) =>
                                                    consumerProvider.isEdit ==
                                                                false ||
                                                            consumerProvider
                                                                    .isfirstdemand ==
                                                                false
                                                        ? SelectFieldBuilder(
                                                            i18.consumer
                                                                .CONSUMER_BILLING_CYCLE,
                                                            consumerProvider
                                                                .selectedcycle,
                                                            '',
                                                            '',
                                                            consumerProvider
                                                                .onChangeBillingcycle,
                                                            consumerProvider
                                                                .getBillingCycle(),
                                                            true)
                                                        : Text("")),
                                      ],
                                    )),
                            consumerProvider.isEdit == false ||
                                    consumerProvider.isfirstdemand == false
                                ? BuildTextField(
                                    i18.consumer.ARREARS,
                                    consumerProvider
                                        .waterconnection.arrearsCtrl,
                                    textInputType: TextInputType.number,
                                    inputFormatter: [
                                      FilteringTextInputFormatter.allow(
                                          RegExp("[0-9.]"))
                                    ],
                                    contextkey: consumerProvider
                                        .consmerWalkthrougList[8].key)
                                : Text(""),
                            SizedBox(
                              height: 20,
                            ),
                          ])),
                    ])))),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    var userProvider = Provider.of<ConsumerProvider>(context, listen: false);
    return Scaffold(
        appBar: BaseAppBar(
          Text(i18.common.MGRAM_SEVA),
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
        bottomNavigationBar: BottomButtonBar(i18.common.SUBMIT,
            () => {userProvider.validateExpensesDetails(context)}));
  }
}
