import 'package:flutter/material.dart';
import 'package:mgramseva/model/bill/bill_generation_details/bill_generation_details.dart';
import 'package:mgramseva/providers/bill_generation_details_provider.dart';
import 'package:mgramseva/screeens/GenerateBill/widgets/MeterReading.dart';
import 'package:mgramseva/utils/Constants/I18KeyConstants.dart';
import 'package:mgramseva/utils/constants.dart';
import 'package:mgramseva/utils/validators/Validators.dart';
import 'package:mgramseva/widgets/BaseAppBar.dart';
import 'package:mgramseva/widgets/BottonButtonBar.dart';
import 'package:mgramseva/widgets/DrawerWrapper.dart';
import 'package:mgramseva/widgets/FormWrapper.dart';
import 'package:mgramseva/widgets/HomeBack.dart';
import 'package:mgramseva/widgets/LabelText.dart';
import 'package:mgramseva/widgets/SelectFieldBuilder.dart';
import 'package:mgramseva/widgets/SideBar.dart';
import 'package:mgramseva/widgets/TextFieldBuilder.dart';
import 'package:provider/provider.dart';

class GenerateBill extends StatefulWidget {
  State<StatefulWidget> createState() {
    return _GenerateBillState();
  }
}

class _GenerateBillState extends State<GenerateBill> {
  @override
  void initState() {
    super.initState();
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
              height: 1260,
              width: MediaQuery.of(context).size.width,
              child: Card(
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
                                    i18.demandGenerate.GENERATE_BILL_HEADER),
                                SelectFieldBuilder(
                                  i18.demandGenerate.SERVICE_CATEGORY_LABEL,
                                  billGenerationDetails.serviceCat,
                                  '',
                                  '',
                                  billgenerationprovider.onChangeOfServiceCat,
                                  billgenerationprovider.getDropDownList(
                                      Constants.SERVICECATEGORY),
                                  true,
                                ),
                                SelectFieldBuilder(
                                    i18.demandGenerate.PROPERTY_TYPE_LABEL,
                                    billGenerationDetails.propertyType,
                                    '',
                                    '',
                                    billgenerationprovider.onChangeOfProperty,
                                    billgenerationprovider.getDropDownList(
                                        Constants.PROPERTYTYPE),
                                    true),
                                SelectFieldBuilder(
                                    i18.demandGenerate.SERVICE_TYPE_LABEL,
                                    billGenerationDetails.serviceType,
                                    '',
                                    '',
                                    billgenerationprovider
                                        .onChangeOfServiceType,
                                    billgenerationprovider
                                        .getDropDownList(Constants.SERVICETYPE),
                                    true),
                                billGenerationDetails.serviceType !=
                                        "METER CONNECTION"
                                    ? Container()
                                    : Container(
                                        width:
                                            MediaQuery.of(context).size.width,
                                        child: Column(children: [
                                          BuildTextField(
                                            i18.demandGenerate
                                                .METER_NUMBER_LABEL,
                                            billGenerationDetails
                                                .meterNumberCtrl,
                                            isRequired: true,
                                            validator:
                                                Validators.meterNumberValidator,
                                            textInputType: TextInputType.number,
                                            isDisabled: true,
                                            onChange: (value) =>
                                                saveInput(value),
                                          ),
                                          MeterReading(
                                              i18.demandGenerate
                                                  .PREV_METER_READING_LABEL,
                                              billGenerationDetails.om_1Ctrl,
                                              billGenerationDetails.om_2Ctrl,
                                              billGenerationDetails.om_3Ctrl,
                                              billGenerationDetails.om_4Ctrl,
                                              billGenerationDetails.om_5Ctrl),
                                          MeterReading(
                                              i18.demandGenerate
                                                  .NEW_METER_READING_LABEL,
                                              billGenerationDetails.nm_1Ctrl,
                                              billGenerationDetails.nm_2Ctrl,
                                              billGenerationDetails.nm_3Ctrl,
                                              billGenerationDetails.nm_4Ctrl,
                                              billGenerationDetails.nm_5Ctrl),
                                        ])),
                                billGenerationDetails.serviceType !=
                                        "NON METER CONNECTION"
                                    ? Container()
                                    : Container(
                                        width:
                                            MediaQuery.of(context).size.width,
                                        child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: [
                                              SelectFieldBuilder(
                                                  i18.demandGenerate
                                                      .BILLING_YEAR_LABEL,
                                                  billGenerationDetails
                                                      .billYear,
                                                  '',
                                                  '',
                                                  billgenerationprovider
                                                      .onChangeOfBillYear,
                                                  billgenerationprovider
                                                      .getDropDownList(Constants
                                                          .BILLINGYEAR),
                                                  true),
                                              SelectFieldBuilder(
                                                  i18.demandGenerate
                                                      .BILLING_CYCLE_LABEL,
                                                  billGenerationDetails
                                                      .billCycle,
                                                  '',
                                                  '',
                                                  billgenerationprovider
                                                      .onChangeOfBillCycle,
                                                  billgenerationprovider
                                                      .getDropDownList(Constants
                                                          .BILLINGCYCLE),
                                                  true),
                                            ])),
                              ])))))
        ])));
  }

  @override
  Widget build(BuildContext context) {
    var billgenerateProvider =
        Provider.of<BillGenerationProvider>(context, listen: false);
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
            child: buildview(billgenerateProvider.billGenerateDetails)),
        bottomNavigationBar: BottomButtonBar(
            i18.demandGenerate.GENERATE_BILL_BUTTON,
            () => {billgenerateProvider.onSubmit(context)}));
  }
}
