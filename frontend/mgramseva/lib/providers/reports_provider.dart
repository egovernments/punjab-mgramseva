import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../model/localization/language.dart';
import '../model/mdms/tax_period.dart';
import '../model/reports/bill_report_data.dart';
import '../repository/core_repo.dart';
import '../repository/reports_repo.dart';
import '../utils/common_methods.dart';
import '../utils/constants.dart';
import '../utils/date_formats.dart';
import '../utils/error_logging.dart';
import '../utils/global_variables.dart';
import '../utils/localization/application_localizations.dart';
import '../utils/models.dart';
import 'common_provider.dart';
import 'package:mgramseva/services/mdms.dart' as mdms;

class ReportsProvider with ChangeNotifier {
  var streamController = StreamController.broadcast();
  LanguageList? languageList;
  var selectedBillYear;
  var selectedBillPeriod;
  var selectedBillCycle;
  var billingyearCtrl = TextEditingController();
  var billingcycleCtrl = TextEditingController();
  List<BillReportData>? billreports;

  dispose() {
    streamController.close();
    super.dispose();
  }

  void callNotifier() {
    notifyListeners();
  }
  void onChangeOfBillYear(val) {
    selectedBillYear = val;
    billingcycleCtrl.clear();
    billingcycleCtrl.notifyListeners();
    selectedBillCycle=null;
    selectedBillPeriod=null;
    notifyListeners();
  }

  void onChangeOfBillCycle(val) {
    var result = DateTime.parse(val);
    selectedBillCycle = (DateFormats.getMonth(result));
    selectedBillPeriod = (DateFormats.getFilteredDate(
        result.toLocal().toString(),
        dateFormat: "dd/MM/yyyy")) +
        "-" +
        DateFormats.getFilteredDate(
            (new DateTime(result.year, result.month + 1, 0))
                .toLocal()
                .toString(),
            dateFormat: "dd/MM/yyyy");
    notifyListeners();
  }
  Future<void> getFinancialYearList() async {
    try {
      var commonProvider = Provider.of<CommonProvider>(
          navigatorKey.currentContext!,
          listen: false);
      var res = await CoreRepository().getMdms(
          mdms.getTenantFinancialYearList(
              commonProvider.userDetails!.userRequest!.tenantId.toString()));
      languageList = res;
      notifyListeners();
      streamController.add(languageList);
    } catch (e, s) {
      ErrorHandler().allExceptionsHandler(navigatorKey.currentContext!, e, s);
      streamController.addError('error');
    }
  }
  List<DropdownMenuItem<Object>> getFinancialYearListDropdown(LanguageList? languageList) {
    if (languageList?.mdmsRes?.billingService?.taxPeriodList != null) {
      CommonMethods.getFilteredFinancialYearList(languageList?.mdmsRes?.billingService?.taxPeriodList ?? <TaxPeriod>[]);
      languageList?.mdmsRes?.billingService?.taxPeriodList!.sort((a,b)=>a.fromDate!.compareTo(b.fromDate!));
      return (languageList?.mdmsRes?.billingService?.taxPeriodList ??
          <TaxPeriod>[])
          .map((value) {
        return DropdownMenuItem(
          value: value,
          child: new Text((value.financialYear!)),
        );
      }).toList().reversed.toList();
    }
    return <DropdownMenuItem<Object>>[];
  }

  List<DropdownMenuItem<Object>> getBillingCycleDropdown(dynamic selectedBillYear) {
    var dates = [];
    if (selectedBillYear != null) {
      DatePeriod ytd;
      var fromDate = DateFormats.getFormattedDateToDateTime(
          DateFormats.timeStampToDate(selectedBillYear.fromDate)) as DateTime;

      var toDate = DateFormats.getFormattedDateToDateTime(
          DateFormats.timeStampToDate(selectedBillYear.toDate)) as DateTime;

      ytd = DatePeriod(fromDate,toDate,DateType.YTD);

      /// Get months based on selected billing year
      var months = CommonMethods.getPastMonthUntilFinancialYTD(ytd);

      /// if selected year is future year means all the months will be removed
      if(fromDate.year > ytd.endDate.year) months.clear();

      for (var i = 0; i < months.length; i++) {
        var prevMonth = months[i].startDate;
        var r = {"code": prevMonth, "name": prevMonth};
        dates.add(r);
      }
    }
    if (dates.length > 0) {
      return (dates).map((value) {
        var d = value['name'];
        return DropdownMenuItem(
          value: value['code'].toLocal().toString(),
          child: new Text(
              ApplicationLocalizations.of(navigatorKey.currentContext!)
                  .translate((Constants.MONTHS[d.month - 1])) +
                  " - " +
                  d.year.toString()),
        );
      }).toList();
    }
    return <DropdownMenuItem<Object>>[];
  }

  Future<void> getBillReport() async {
    try {
      var commonProvider = Provider.of<CommonProvider>(
          navigatorKey.currentContext!,
          listen: false);
      Map<String,dynamic> params={
        'tenantId':commonProvider.userDetails!.selectedtenant!.code,
        'demandDate':selectedBillPeriod?.split('-')[0]
      };
      var response = await ReportsRepo().fetchBillReport(
          params);
      if (response != null) {
        billreports = response;
        print(billreports.toString());
        streamController.add(response);
        callNotifier();
      }else{
        throw Exception('API Error');
      }
      callNotifier();
    } catch (e, s) {
      billreports = [];
      ErrorHandler().allExceptionsHandler(navigatorKey.currentContext!, e, s);
      streamController.addError('error');
      callNotifier();
    }
  }
}