import 'package:flutter/material.dart';
import 'package:mgramseva/model/bill_generation_details/bill_generation_details.dart';
import 'package:mgramseva/utils/Constants/I18KeyConstants.dart';
import 'package:mgramseva/utils/global_variables.dart';
import 'package:mgramseva/utils/models.dart';
import 'package:mgramseva/utils/notifyers.dart';
import 'package:mgramseva/widgets/CommonSuccessPage.dart';

class BillGenerationProvider with ChangeNotifier {
  var formKey = GlobalKey<FormState>();
  var autoValidation = false;
  var billGenerateDetails = BillGenerationDetails();

onChangeOfServiceType (val){
  print(val.toString());
  billGenerateDetails.serviceType = val;
  notifyListeners();
}

onChangeOfServiceCat(val){
  print(val.toString());
    billGenerateDetails.serviceCat = val;
    notifyListeners();
}
onChangeOfProperty(val){
  print(val.toString());
    billGenerateDetails.propertyType = val;
    notifyListeners();
}
void onChangeOfBillYear(val){
  print(val.toString());
    billGenerateDetails.billYear = val;
    notifyListeners();
}
void onChangeOfBillCycle(val){
  print(val.toString());
    billGenerateDetails.billCycle = val;
    notifyListeners();
}

  void onSubmit(context) async{
  try {
    if (formKey.currentState!.validate() &&
        billGenerateDetails.serviceType == "METER CONNECTION") {
      if (billGenerateDetails.om_1Ctrl.text.isEmpty ||
          billGenerateDetails.om_2Ctrl.text.isEmpty ||
          billGenerateDetails.om_3Ctrl.text.isEmpty ||
          billGenerateDetails.om_4Ctrl.text.isEmpty ||
          billGenerateDetails.om_5Ctrl.text.isEmpty) {
        Notifiers.getToastMessage(
            context, i18.demandGenerate.OLD_METER_READING_INVALID, 'ERROR');
      }
      else if (billGenerateDetails.nm_1Ctrl.text.isEmpty ||
          billGenerateDetails.nm_2Ctrl.text.isEmpty ||
          billGenerateDetails.nm_3Ctrl.text.isEmpty ||
          billGenerateDetails.nm_4Ctrl.text.isEmpty ||
          billGenerateDetails.nm_5Ctrl.text.isEmpty) {
        Notifiers.getToastMessage(
            context, i18.demandGenerate.NEW_METER_READING_INVALID, 'ERROR');
      }
      else {
        var oldMeter = billGenerateDetails.om_1Ctrl.text +
            billGenerateDetails.om_2Ctrl.text +
            billGenerateDetails.om_3Ctrl.text +
            billGenerateDetails.om_4Ctrl.text +
            billGenerateDetails.om_5Ctrl.text;
        var newMeter = billGenerateDetails.nm_1Ctrl.text +
            billGenerateDetails.nm_2Ctrl.text +
            billGenerateDetails.nm_3Ctrl.text +
            billGenerateDetails.nm_4Ctrl.text +
            billGenerateDetails.nm_5Ctrl.text;
        print(oldMeter);
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
              context,
              i18.demandGenerate.NEW_METER_READING_SHOULD_GREATER_THAN_OLD_METER_READING,
              'ERROR');
        }
      }
    }
    else if (formKey.currentState!.validate() &&
        billGenerateDetails.serviceType == "NON METER CONNECTION") {
      Navigator.of(context).pushReplacement(
          new MaterialPageRoute(builder: (BuildContext context) {
            return CommonSuccess(SuccessHandler(
                i18.demandGenerate.GENERATE_BILL_SUCCESS,
                i18.demandGenerate.GENERATE_BILL_SUCCESS_SUBTEXT,
                i18.common.BACK_HOME));
          }));
    }
    else {
      autoValidation = true;
      notifyListeners();
    }
  }
  catch (e) {
    navigatorKey.currentState?.pop();
  }
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


}