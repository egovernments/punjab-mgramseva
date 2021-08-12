import 'dart:async';

import 'package:flutter/material.dart';
import 'package:mgramseva/model/bill_generation_details/bill_generation_details.dart';
import 'package:mgramseva/model/connection/water_connection.dart';
import 'package:mgramseva/model/localization/language.dart';
import 'package:mgramseva/model/mdms/connection_type.dart';
import 'package:mgramseva/model/mdms/property_type.dart';
import 'package:mgramseva/model/mdms/tax_head_master.dart';
import 'package:mgramseva/model/mdms/tax_period.dart';
import 'package:mgramseva/model/success_handler.dart';
import 'package:mgramseva/repository/bill_generation_details_repo.dart';
import 'package:mgramseva/repository/core_repo.dart';
import 'package:mgramseva/routers/Routers.dart';
import 'package:mgramseva/services/MDMS.dart';
import 'package:mgramseva/utils/Constants/I18KeyConstants.dart';
import 'package:mgramseva/utils/date_formats.dart';
import 'package:mgramseva/utils/global_variables.dart';
import 'package:mgramseva/utils/notifyers.dart';
import 'package:mgramseva/widgets/CommonSuccessPage.dart';
import 'package:provider/provider.dart';

import 'common_provider.dart';

class BillGenerationProvider with ChangeNotifier {
  var streamController = StreamController.broadcast();
  LanguageList? languageList;
  late GlobalKey<FormState> formKey;
  var autoValidation = false;
  var billGenerateDetails = BillGenerationDetails();
  var waterconnection = WaterConnection();
  late List dates = [];
  var selectedBillYear;
  var selectedBillPeriod ;
  var meterReadingDate;
  List months = [
    'Jan',
    'Feb',
    'Mar',
    'Apr',
    'May',
    'Jun',
    'Jul',
    'Aug',
    'Sep',
    'Oct',
    'Nov',
    'Dec'
  ];

  dispose() {
    streamController.close();
    super.dispose();
  }
  Future<void> getBillDetails() async {
    try {
      streamController.add(billGenerateDetails);
    } catch (e) {
      print(e);
      streamController.addError('error');
    }
  }

  onChangeOfServiceType (val){
    print(val.toString());
    billGenerateDetails.serviceType = val;
    notifyListeners();
  }

  onChangeOfServiceCat(val){
    billGenerateDetails.serviceCat = val;
    notifyListeners();
  }
  onChangeOfProperty(val){
    billGenerateDetails.propertyType = val;
    notifyListeners();
  }
  void onChangeOfBillYear(val){
    selectedBillYear = val;
    billGenerateDetails.billYear = val.code;
    notifyListeners();
  }
  void onChangeOfBillCycle(val){
    //var d = val as DateTime;
    selectedBillPeriod = (DateFormats.getFilteredDate(
        val.toLocal().toString(),
        dateFormat: "dd/MM/yyyy")) + "-" + DateFormats.getFilteredDate((new DateTime(val.year, val.month + 1, val.day)).toLocal().toString(), dateFormat: "dd/MM/yyyy");
    billGenerateDetails.billCycle = val;
    notifyListeners();
  }
  void onChangeOfDate(value) {
    notifyListeners();
  }
  Future<void> getServiceTypePropertyTypeandConnectionType() async {
    try {
      var commonProvider = Provider.of<CommonProvider>(
          navigatorKey.currentContext!,
          listen: false);
      var res = await CoreRepository()
          .getMdms(getServiceTypeConnectionTypePropertyTypeMDMS(commonProvider.userDetails!.userRequest!.tenantId.toString()));
      languageList = res;
    } catch (e) {
      print(e);
    }
  }

  void onSubmit(context) async{
    if (formKey.currentState!.validate() &&
        billGenerateDetails.serviceType == "Metered") {
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
        if (int.parse(oldMeter) < int.parse(newMeter)) {
          try {
            var commonProvider = Provider.of<CommonProvider>(
                navigatorKey.currentContext!,
                listen: false);
            var res1 = {
              "meterReadings": {
                "currentReading": int.parse(newMeter),
                "currentReadingDate": DateFormats.dateToTimeStamp(billGenerateDetails.meterReadingDateCtrl.text),
                "billingPeriod": "01/05/2021 - 01/06/2021",
                "meterStatus": "Working",
                "connectionNo": "WS/400/2021-22/0160",
                "lastReading": int.parse(oldMeter),
                "lastReadingDate": 1627756200000,
                "generateDemand":true,
                "tenantId": commonProvider.userDetails!.selectedtenant!.code
              }
            };
            var billResponse1 = await BillGenerateRepository().calculateMeterConnection(res1);
            Navigator.pop(context);
            if(billResponse1!=null) {
              Navigator.of(context).pushReplacement(
                  new MaterialPageRoute(builder: (BuildContext context) {
                    return CommonSuccess(SuccessHandler(
                        i18.demandGenerate.GENERATE_BILL_SUCCESS,
                        i18.demandGenerate.GENERATE_BILL_SUCCESS_SUBTEXT,
                        i18.common.BACK_HOME, Routes.BILL_GENERATE));
                  }));
            }
          }
          catch (e) {
            navigatorKey.currentState?.pop();
          }
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
        billGenerateDetails.serviceType == "Non Metered") {
      try {
        var commonProvider = Provider.of<CommonProvider>(
            navigatorKey.currentContext!,
            listen: false);
        var res2 = {
          "tenantId": commonProvider.userDetails!.selectedtenant!.code,
          "billingPeriod": selectedBillPeriod
        };
        var billResponse2 = await BillGenerateRepository().bulkDemand(res2);
        Navigator.pop(context);
        if(billResponse2!=null) {
          Navigator.of(context).pushReplacement(
              new MaterialPageRoute(builder: (BuildContext context) {
                return CommonSuccess(SuccessHandler(
                    i18.demandGenerate.GENERATE_BILL_SUCCESS,
                    i18.demandGenerate.GENERATE_BILL_SUCCESS_SUBTEXT,
                    i18.common.BACK_HOME, Routes.BILL_GENERATE));
              }));
        }
      }
      catch (e) {
        navigatorKey.currentState?.pop();
      }
    }
    else {
      autoValidation = true;
      notifyListeners();
    }
  }

  List<DropdownMenuItem<Object>> getPropertyTypeList() {
    if (languageList?.mdmsRes?.propertyTax?.PropertyTypeList != null) {
      return (languageList?.mdmsRes?.propertyTax?.PropertyTypeList ??
          <PropertyType>[])
          .map((value) {
        return DropdownMenuItem(
          value: value.code,
          child: new Text(value.name!),
        );
      }).toList();
    }
    return <DropdownMenuItem<Object>>[];
  }
  List<DropdownMenuItem<Object>> getConnectionTypeList() {
    if (languageList?.mdmsRes?.connection?.connectionTypeList != null) {
      return (languageList?.mdmsRes?.connection?.connectionTypeList ??
          <ConnectionType>[])
          .map((value) {
        return DropdownMenuItem(
          value: value.code,
          child: new Text(value.name!),
        );
      }).toList();
    }
    return <DropdownMenuItem<Object>>[];
  }
  List<DropdownMenuItem<Object>> getFinancialYearList() {
    if (languageList?.mdmsRes?.billingService?.taxPeriodList != null) {
      return (languageList?.mdmsRes?.billingService?.taxPeriodList ??
          <TaxPeriod>[])
          .map((value) {
        return DropdownMenuItem(
          value: value,
          child: new Text(value.financialYear!),
        );
      }).toList();
    }
    return <DropdownMenuItem<Object>>[];
  }
  List<DropdownMenuItem<Object>> getServiceCategoryList() {
    if (languageList?.mdmsRes?.billingService?.taxHeadMasterList != null) {
      return (languageList?.mdmsRes?.billingService?.taxHeadMasterList ?? <TaxHeadMaster>[])
          .map((value) {
        return DropdownMenuItem(
          value: value.code,
          child: new Text(value.name!),
        );
      }).toList();
    }
    return <DropdownMenuItem<Object>>[];
  }
  Future<void> fetchDates() async {
    var date = new DateTime.now();
    dates = [];
    for (var i = 0; i < 12; i++) {
      var prevMonth = new DateTime(date.year, date.month - i + 1, 1);
      var r = {"code": prevMonth, "name": prevMonth};
      dates.add(r);
    }
  }

  List<DropdownMenuItem<Object>> getBillingCycle() {
    dates = [];
   // print(languageList?.mdmsRes?.billingService?.taxPeriodList!.first.toJson());
    if (billGenerateDetails.billYear!=null && selectedBillYear!=null) {
      var date2 = DateFormats.getFormattedDateToDateTime(
          DateFormats.timeStampToDate(selectedBillYear.toDate));
      var date1 = DateFormats.getFormattedDateToDateTime(
          DateFormats.timeStampToDate(selectedBillYear.fromDate));
      print(date1);
      print(date2);
      var d = date2 as DateTime;
      var now = date1 as DateTime;
      var years = d.year - now.year;
      var months = now.month - d.month;
      //print(DateFormats.getFilteredDate(date2, dateFormat: 'YYYY-MM-dd'));
      for (var i = 0; i < years * 12; i++) {
        var prevMonth = new DateTime(now.year, date1.month + i, 1);
        var r = {"code": prevMonth, "name": prevMonth};
        dates.add(r);
      }
    }
    if (dates.length > 0) {
      return (dates ?? <Map>[]).map((value) {
        var d = value['name'] as DateTime;
        print(DateFormats.dateToTimeStamp(DateFormats.getFilteredDate(
            d.toLocal().toString(),
            dateFormat: "dd/MM/yyyy")));
        return DropdownMenuItem(
          value: value['code'],
          child: new Text(months[d.month - 1] + " - " + d.year.toString()),
        );
      }).toList();
    }
    return <DropdownMenuItem<Object>>[];
  }




}