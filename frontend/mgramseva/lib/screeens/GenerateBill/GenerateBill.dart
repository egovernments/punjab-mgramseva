import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mgramseva/screeens/GenerateBill/widgets/MeterReading.dart';
import 'package:mgramseva/utils/Constants/I18KeyConstants.dart';
import 'package:mgramseva/utils/constants.dart';
import 'package:mgramseva/utils/models.dart';
import 'package:mgramseva/utils/notifyers.dart';
import 'package:mgramseva/utils/validators/Validators.dart';
import 'package:mgramseva/widgets/BaseAppBar.dart';
import 'package:mgramseva/widgets/BottonButtonBar.dart';
import 'package:mgramseva/widgets/CommonSuccessPage.dart';
import 'package:mgramseva/widgets/DrawerWrapper.dart';
import 'package:mgramseva/widgets/FormWrapper.dart';
import 'package:mgramseva/widgets/HomeBack.dart';
import 'package:mgramseva/widgets/LabelText.dart';
import 'package:mgramseva/widgets/SelectFieldBuilder.dart';
import 'package:mgramseva/widgets/SideBar.dart';
import 'package:mgramseva/widgets/TextFieldBuilder.dart';

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
  var serviceCat ;
  var serviceType ;
  var propertyType ;
  var billYear;
  var billCycle;
  var metVal = "";
  var meterNumber = new TextEditingController();
  var om_1 = new TextEditingController();
  var om_2 = new TextEditingController();
  var om_3 = new TextEditingController();
  var om_4 = new TextEditingController();
  var om_5 = new TextEditingController();
  var nm_1 = new TextEditingController();
  var nm_2 = new TextEditingController();
  var nm_3 = new TextEditingController();
  var nm_4 = new TextEditingController();
  var nm_5 = new TextEditingController();


  final formKey = GlobalKey<FormState>();
  var autoValidation = false;
  _onSubmit(context) {
    if (formKey.currentState!.validate() && serviceType == "METER CONNECTION") {
      if(om_1.text.isEmpty || om_2.text.isEmpty || om_3.text.isEmpty || om_4.text.isEmpty || om_5.text.isEmpty) {
        Notifiers.getToastMessage('Old Meter Reading is Invalid');
      }
      else if (nm_1.text.isEmpty || nm_2.text.isEmpty || nm_3.text.isEmpty || nm_4.text.isEmpty || nm_5.text.isEmpty){
        Notifiers.getToastMessage('New Meter Reading is Invalid');
      }
      else {
        var oldMeter = om_1.text + om_2.text + om_3.text + om_4.text +
            om_5.text;
        var newMeter = nm_1.text + nm_2.text + nm_3.text + nm_4.text +
            nm_5.text;
        if (int.parse(oldMeter) < int.parse(newMeter)) {
          Navigator.of(context).pushReplacement(
              new MaterialPageRoute(builder: (BuildContext context) {
                return CommonSuccess(SuccessHandler(
                    i18.demandGenerate.GENERATE_BILL_SUCCESS,
                    i18.demandGenerate.GENERATE_BILL_SUCCESS_SUBTEXT,
                    i18.common.BACK_HOME));
              }));
        }
        else {
          Notifiers.getToastMessage(
              'New Meter reading should be greater than old meter reading');
        }
      }
    }
    else if(formKey.currentState!.validate() && serviceType == "NON METER CONNECTION")
      {
        Navigator.of(context).pushReplacement(
            new MaterialPageRoute(builder: (BuildContext context) {
              return CommonSuccess(SuccessHandler(
                  i18.demandGenerate.GENERATE_BILL_SUCCESS,
                  i18.demandGenerate.GENERATE_BILL_SUCCESS_SUBTEXT, i18.common.BACK_HOME));
            }));
      }
    else {
      autoValidation = true;
    }
  }
  saveInput(context) async {
    setState(() {
      metVal = context;
    });
  }
  void onChangeOfMeterType(value) {
    print(value.toString());
    setState(() {
      serviceType = value;
    });
  }
  void onChangeOfServiceCat(value) {
    print(value.toString());
    setState(() {
      serviceCat = value;
    });
  }
  void onChangeOfProperty(value) {
    print(value.toString());
    setState(() {
      propertyType = value;
    });
  }
  void onChangeOfBillYear(value) {
    print(value.toString());
    setState(() {
      billYear = value;
    });
  }
  void onChangeOfBillCycle(value) {
    print(value.toString());
    setState(() {
      billCycle = value;
    });
  }

  Widget buildview() {
    return Container(
        child: FormWrapper(Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              HomeBack(),
              Card(
                  child: Form(
                      key: formKey,
                      autovalidateMode: autoValidation
                          ? AutovalidateMode.always
                          : AutovalidateMode.disabled,
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            LabelText(i18.demandGenerate.GENERATE_BILL_HEADER),
                            SelectFieldBuilder(
                              i18.demandGenerate.SERVICE_CATEGORY_LABEL,
                              serviceCat,
                              '',
                              '',
                              onChangeOfServiceCat,
                              getDropDownList(Constants.SERVICECATEGORY),
                              true,
                            ),
                            SelectFieldBuilder(
                                i18.demandGenerate.PROPERTY_TYPE_LABEL,
                                propertyType,
                                '',
                                '',
                                onChangeOfProperty,
                                getDropDownList(Constants.PROPERTYTYPE),
                                true),
                            SelectFieldBuilder(
                                i18.demandGenerate.SERVICE_TYPE_LABEL,
                                serviceType,
                                '',
                                '',
                                onChangeOfMeterType,
                                getDropDownList(Constants.SERVICETYPE),
                                true),
                            serviceType != "METER CONNECTION"
                                ? Container()
                                : Container(
                              height: 500,
                                child: Column(
                                children: [
                                  BuildTextField(
                                    i18.demandGenerate.METER_NUMBER_LABEL,
                                    meterNumber,
                                    isRequired: true,
                                    validator: Validators.meterNumberValidator,
                                    textInputType: TextInputType.number,
                                    isDisabled: true,
                                    onChange: (value) => saveInput(value),
                                  ),
                                  MeterReading(i18.demandGenerate
                                      .PREV_METER_READING_LABEL, om_1, om_2,
                                      om_3, om_4, om_5),
                                  MeterReading(i18.demandGenerate
                                      .NEW_METER_READING_LABEL, nm_1, nm_2,
                                      nm_3, nm_4, nm_5),
                                ])),
                            serviceType != "NON METER CONNECTION"
                                ? Container()
                                : Container(
                                height: 500,
                                  child : Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    SelectFieldBuilder(
                                      i18.demandGenerate.BILLING_YEAR_LABEL,
                                      billYear,
                                      '',
                                      '',
                                      onChangeOfBillYear,
                                      getDropDownList(Constants.BILLINGYEAR),
                                      true),
                                    SelectFieldBuilder(
                                      i18.demandGenerate.BILLING_CYCLE_LABEL,
                                      billCycle,
                                      '',
                                      '',
                                      onChangeOfBillCycle,
                                      getDropDownList(Constants.BILLINGCYCLE),
                                      true),
                                ])),
                          ])))
            ])));
  }


  List<DropdownMenuItem<Object>> getDropDownList(List<KeyValue>? list) {
    if (list?.length != 0) {
      return (list ?? <KeyValue>[]).map((value) {
        return DropdownMenuItem(
          value: value.key,
          child: new Text(value.label),
        );
      }).toList();
    }
    return <DropdownMenuItem<Object>>[];
  }

  @override
  Widget build(BuildContext context) {
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
            child: buildview()),
        bottomNavigationBar: BottomButtonBar(i18.demandGenerate.GENERATE_BILL_BUTTON, () => _onSubmit(context))
    );
  }
}
