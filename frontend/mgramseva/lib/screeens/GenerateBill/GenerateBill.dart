import 'package:flutter/material.dart';
import 'package:mgramseva/model/bill/bill_generation_details/bill_generation_details.dart';
import 'package:mgramseva/model/connection/water_connection.dart';
import 'package:mgramseva/providers/bill_generation_details_provider.dart';
import 'package:mgramseva/screeens/GenerateBill/widgets/MeterReading.dart';
import 'package:mgramseva/utils/Constants/I18KeyConstants.dart';
import 'package:mgramseva/utils/loaders.dart';
import 'package:mgramseva/utils/notifyers.dart';
import 'package:mgramseva/utils/validators/Validators.dart';
import 'package:mgramseva/widgets/BaseAppBar.dart';
import 'package:mgramseva/widgets/BottonButtonBar.dart';
import 'package:mgramseva/widgets/DatePickerFieldBuilder.dart';
import 'package:mgramseva/widgets/DrawerWrapper.dart';
import 'package:mgramseva/widgets/FormWrapper.dart';
import 'package:mgramseva/widgets/HomeBack.dart';
import 'package:mgramseva/widgets/LabelText.dart';
import 'package:mgramseva/widgets/SelectFieldBuilder.dart';
import 'package:mgramseva/widgets/SideBar.dart';
import 'package:mgramseva/widgets/TextFieldBuilder.dart';
import 'package:mgramseva/widgets/footer.dart';
import 'package:provider/provider.dart';

class GenerateBill extends StatefulWidget {
  final String? id;
  final WaterConnection? waterconnection;
  const GenerateBill({Key? key, this.id, this.waterconnection})
      : super(key: key);
  State<StatefulWidget> createState() {
    return _GenerateBillState();
  }
}

class _GenerateBillState extends State<GenerateBill> {
  @override
  void initState() {
    WidgetsBinding.instance?.addPostFrameCallback((_) => afterViewBuild());
    super.initState();
  }

  afterViewBuild() {
    Provider.of<BillGenerationProvider>(context, listen: false)
      ..setModel(widget.id, widget.waterconnection, context)
      ..readingExist
      ..getServiceTypePropertyTypeandConnectionType()
      ..autoValidation = false
      ..formKey = GlobalKey<FormState>();
  }

  var metVal = "";

  saveInput(context) async {
    setState(() {
      metVal = context;
    });
  }

  Widget buildview(BillGenerationDetails billGenerationDetails) {
    return Container(
        child: FormWrapper(Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
          HomeBack(),
          Container(
              width: MediaQuery.of(context).size.width,
              child: Card(
                  child: Padding(
                      padding: EdgeInsets.only(bottom: 20),
                      child: Consumer<BillGenerationProvider>(
                          builder: (_, billgenerationprovider, child) => Form(
                              key: billgenerationprovider.formKey,
                              autovalidateMode:
                                  billgenerationprovider.autoValidation
                                      ? AutovalidateMode.always
                                      : AutovalidateMode.disabled,
                              child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    LabelText(
                                        '${widget.id == null ? i18.demandGenerate.SERVICE_DETAILS_HEADER : i18.demandGenerate.GENERATE_BILL_HEADER}'),
                                    Consumer<BillGenerationProvider>(
                                        builder: (_, billgenerationprovider,
                                                child) =>
                                            SelectFieldBuilder(
                                              i18.demandGenerate
                                                  .SERVICE_CATEGORY_LABEL,
                                              billgenerationprovider
                                                  .billGenerateDetails
                                                  .serviceCat,
                                              '',
                                              '',
                                              billgenerationprovider
                                                  .onChangeOfServiceCat,
                                              billgenerationprovider
                                                  .getServiceCategoryList(),
                                              true,
                                              readOnly: true,
                                              isEnabled: false,
                                              controller: billgenerationprovider
                                                  .billGenerateDetails
                                                  .serviceCategoryCtrl,
                                            )),
                                    Consumer<BillGenerationProvider>(
                                        builder: (_,
                                                billgenerationprovider, child) =>
                                            SelectFieldBuilder(
                                                i18.demandGenerate
                                                    .SERVICE_TYPE_LABEL,
                                                billgenerationprovider
                                                    .billGenerateDetails
                                                    .serviceType,
                                                '',
                                                '',
                                                billgenerationprovider
                                                    .onChangeOfServiceType,
                                                billgenerationprovider
                                                    .getConnectionTypeList(),
                                                true,
                                                readOnly: true,
                                                isEnabled: false,
                                                controller:
                                                    billgenerationprovider
                                                        .billGenerateDetails
                                                        .serviceTypeCtrl)),
                                    billgenerationprovider.billGenerateDetails
                                                .serviceType !=
                                            "Metered"
                                        ? Container()
                                        : Container(
                                            width: MediaQuery.of(context)
                                                .size
                                                .width,
                                            child: Column(children: [
                                              Consumer<BillGenerationProvider>(
                                                  builder: (_,
                                                          billgenerationprovider,
                                                          child) =>
                                                      SelectFieldBuilder(
                                                          i18.demandGenerate
                                                              .PROPERTY_TYPE_LABEL,
                                                          billgenerationprovider
                                                              .billGenerateDetails
                                                              .propertyType,
                                                          '',
                                                          '',
                                                          billgenerationprovider
                                                              .onChangeOfProperty,
                                                          billgenerationprovider
                                                              .getPropertyTypeList(),
                                                          true,
                                                          readOnly: true,
                                                          isEnabled: false,
                                                          controller: billgenerationprovider
                                                              .billGenerateDetails
                                                              .propertyTypeCtrl)),
                                              Consumer<BillGenerationProvider>(
                                                  builder: (_,
                                                          billgenerationprovider,
                                                          child) =>
                                                      BuildTextField(
                                                        i18.demandGenerate
                                                            .METER_NUMBER_LABEL,
                                                        billgenerationprovider
                                                            .billGenerateDetails
                                                            .meterNumberCtrl,
                                                        isRequired: true,
                                                        validator: Validators
                                                            .meterNumberValidator,
                                                        textInputType:
                                                            TextInputType
                                                                .number,
                                                        onChange: (value) =>
                                                            saveInput(value),
                                                        isDisabled: true,
                                                        readOnly:
                                                            widget.id == null
                                                                ? false
                                                                : true,
                                                      )),
                                              MeterReading(
                                                i18.demandGenerate
                                                    .PREV_METER_READING_LABEL,
                                                billgenerationprovider
                                                    .billGenerateDetails
                                                    .om_1Ctrl,
                                                billgenerationprovider
                                                    .billGenerateDetails
                                                    .om_2Ctrl,
                                                billgenerationprovider
                                                    .billGenerateDetails
                                                    .om_3Ctrl,
                                                billgenerationprovider
                                                    .billGenerateDetails
                                                    .om_4Ctrl,
                                                billgenerationprovider
                                                    .billGenerateDetails
                                                    .om_5Ctrl,
                                                isRequired: true,
                                                isDisabled: billgenerationprovider.readingExist == false ? true : false,
                                              ),
                                              MeterReading(
                                                i18.demandGenerate
                                                    .NEW_METER_READING_LABEL,
                                                billgenerationprovider
                                                    .billGenerateDetails
                                                    .nm_1Ctrl,
                                                billgenerationprovider
                                                    .billGenerateDetails
                                                    .nm_2Ctrl,
                                                billgenerationprovider
                                                    .billGenerateDetails
                                                    .nm_3Ctrl,
                                                billgenerationprovider
                                                    .billGenerateDetails
                                                    .nm_4Ctrl,
                                                billgenerationprovider
                                                    .billGenerateDetails
                                                    .nm_5Ctrl,
                                                isRequired: true,
                                                isDisabled: false,
                                              ),
                                              BasicDateField(
                                                  i18.demandGenerate
                                                      .METER_READING_DATE,
                                                  true,
                                                  billGenerationDetails
                                                      .meterReadingDateCtrl,
                                                  lastDate: DateTime.now(),
                                                  onChangeOfDate:
                                                      billgenerationprovider
                                                          .onChangeOfDate),
                                            ])),
                                    billgenerationprovider.billGenerateDetails
                                                .serviceType !=
                                            "Non_Metered"
                                        ? Container()
                                        : Container(
                                            width: MediaQuery.of(context)
                                                .size
                                                .width,
                                            child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                children: [
                                                  Consumer<
                                                          BillGenerationProvider>(
                                                      builder: (_,
                                                              billgenerationprovider,
                                                              child) =>
                                                          SelectFieldBuilder(
                                                            i18.demandGenerate
                                                                .BILLING_YEAR_LABEL,
                                                            billgenerationprovider
                                                                .billGenerateDetails
                                                                .billYear,
                                                            '',
                                                            '',
                                                            billgenerationprovider
                                                                .onChangeOfBillYear,
                                                            billgenerationprovider
                                                                .getFinancialYearList(),
                                                            true,
                                                            controller: billgenerationprovider
                                                                .billGenerateDetails
                                                                .billingyearCtrl,
                                                          )),
                                                  Consumer<
                                                          BillGenerationProvider>(
                                                      builder: (_,
                                                              billgenerationprovider,
                                                              child) =>
                                                          SelectFieldBuilder(
                                                            i18.demandGenerate
                                                                .BILLING_CYCLE_LABEL,
                                                            billgenerationprovider
                                                                .billGenerateDetails
                                                                .billCycle,
                                                            '',
                                                            '',
                                                            billgenerationprovider
                                                                .onChangeOfBillCycle,
                                                            billgenerationprovider
                                                                .getBillingCycle(),
                                                            true,
                                                            controller: billgenerationprovider
                                                                .billGenerateDetails
                                                                .billingcycleCtrl,
                                                          )),
                                                ])),
                                  ]))))))
        ])));
  }

  @override
  Widget build(BuildContext context) {
    var billgenerateProvider =
        Provider.of<BillGenerationProvider>(context, listen: false);
    return Scaffold(
        backgroundColor: Theme.of(context).backgroundColor,
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
                child: Column(children: [
          StreamBuilder(
              stream: billgenerateProvider.streamController.stream,
              builder: (context, AsyncSnapshot snapshot) {
                if (snapshot.hasData) {
                  return buildview(snapshot.data);
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
              }),
          Footer()
        ]))),
        bottomNavigationBar: BottomButtonBar(
            '${widget.id == null ? i18.demandGenerate.GENERATE_DEMAND_BUTTON : i18.demandGenerate.GENERATE_BILL_BUTTON}',
            () => {billgenerateProvider.onSubmit(context)}));
  }
}
