import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_xlsio/xlsio.dart';

import '../model/common/BillsTableData.dart';
import '../model/localization/language.dart';
import '../model/mdms/tax_period.dart';
import '../model/reports/bill_report_data.dart';
import '../model/reports/collection_report_data.dart';
import '../repository/core_repo.dart';
import '../repository/reports_repo.dart';
import '../utils/common_methods.dart';
import '../utils/constants.dart';
import 'package:mgramseva/utils/constants/i18_key_constants.dart';
import '../utils/date_formats.dart';
import '../utils/error_logging.dart';
import 'package:mgramseva/utils/excel_download/save_file_mobile.dart'
  if (dart.library.html) 'package:mgramseva/utils/excel_download/save_file_web.dart';
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
  List<BillReportData>? demandreports;
  List<CollectionReportData>? collectionreports;
  late BillsTableData genericTableData;

  dispose() {
    streamController.close();
    super.dispose();
  }
  List<TableHeader> get demandHeaderList => [
    TableHeader(i18.common.CONNECTION_ID),
    TableHeader(i18.consumer.OLD_CONNECTION_ID,
      isSortingRequired: false,),
    TableHeader(i18.common.NAME),
    TableHeader('Consumer Created On Date'),
    TableHeader(i18.billDetails.CORE_PENALTY),
    TableHeader(i18.common.CORE_ADVANCE),
    TableHeader(i18.billDetails.TOTAL_AMOUNT),
  ];
  List<TableHeader> get collectionHeaderList => [
    TableHeader(i18.common.CONNECTION_ID),
    TableHeader(i18.consumer.OLD_CONNECTION_ID,
      isSortingRequired: false,),
    TableHeader(i18.common.NAME),
    TableHeader('Payment Mode'),
    TableHeader(i18.billDetails.TOTAL_AMOUNT),
  ];

  List<TableDataRow> getDemandsData(List<BillReportData> list,{isExcel = false}) {
    return list.map((e) => getDemandRow(e,isExcel: isExcel)).toList();
  }
  TableDataRow getDemandRow(BillReportData data,{bool isExcel = false}) {
    String? name =
    CommonMethods.truncateWithEllipsis(20,data.consumerName!);
    return TableDataRow([
      TableData(
        isExcel?'${data.connectionNo ?? '-'}':'${data.connectionNo?.split('/').first ?? ''}/...${data.connectionNo?.split('/').last ?? ''}',),
      TableData('${data.oldConnectionNo ?? '-'}'),
      TableData('${name ?? '-'}'),
      TableData('${DateFormats.timeStampToDate(int.parse(data.consumerCreatedOnDate??'0'))}'),
      TableData('${data.penalty ?? '0'}'),
      TableData('${data.advance ?? '0'}'),
      TableData('${data.demandAmount ?? '0'}'),
    ]);
  }

  List<TableDataRow> getCollectionData(List<CollectionReportData> list,{bool isExcel = false}) {
    return list.map((e) => getCollectionRow(e,isExcel: isExcel)).toList();
  }
  TableDataRow getCollectionRow(CollectionReportData data,{bool isExcel = false}) {
    String? name =
    CommonMethods.truncateWithEllipsis(20,data.consumerName!);
    if(data.oldConnectionNo!=null && data.oldConnectionNo!.isEmpty){
      data.oldConnectionNo='-';
    }
    return TableDataRow([
      TableData(
          isExcel?'${data.connectionNo ?? '-'}':'${data.connectionNo?.split('/').first ?? ''}/...${data.connectionNo?.split('/').last ?? ''}',),
      TableData('${data.oldConnectionNo ?? '-'}'),
      TableData('${name?? '-'}'),
      TableData('${data.paymentMode ?? '-'}'),
      TableData('${data.paymentAmount==null?null:data.paymentAmount!.isNotEmpty?data.paymentAmount?.first:null ?? '0'}'),
    ]);
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

  Future<void> getDemandReport([bool download = false]) async {
    try {
      var commonProvider = Provider.of<CommonProvider>(
          navigatorKey.currentContext!,
          listen: false);
      if(selectedBillPeriod==null){
        throw Exception('Select Billing Cycle');
      }
      Map<String,dynamic> params={
        'tenantId':commonProvider.userDetails!.selectedtenant!.code,
        'demandStartDate':selectedBillPeriod?.split('-')[0],
        'demandEndDate':selectedBillPeriod?.split('-')[1]
      };
      var response = await ReportsRepo().fetchBillReport(
          params);
      if (response != null) {
        demandreports = response;
        if(download){
          generateExcel(
              demandHeaderList
                  .map<String>((e) =>
              '${ApplicationLocalizations.of(navigatorKey.currentContext!).translate(e.label)}')
                  .toList(),
              getDemandsData(demandreports!,isExcel: true).map<List<String>>((e) => e.tableRow.map((e) => e.label).toList()).toList()??[],
              title: 'DemandReport_${commonProvider.userDetails?.selectedtenant?.code?.substring(2)}_$selectedBillPeriod',
              optionalData: [
                'Demand Report',
                '$selectedBillPeriod',
                '${ApplicationLocalizations.of(navigatorKey.currentContext!).translate(commonProvider.userDetails!.selectedtenant!.code!)} ${commonProvider.userDetails?.selectedtenant?.code?.substring(3)}',
                'Downloaded On ${DateFormats.timeStampToDate(DateTime.now().millisecondsSinceEpoch,format: 'dd/MMM/yyyy')}'
              ]);
        }else{
          genericTableData = BillsTableData(demandHeaderList,getDemandsData(demandreports!));
        }
        streamController.add(response);
        callNotifier();
      }else{
        streamController.add('error');
        throw Exception('API Error');
      }
      callNotifier();
    } catch (e, s) {
      demandreports = [];
      ErrorHandler().allExceptionsHandler(navigatorKey.currentContext!, e, s);
      streamController.addError('error');
      callNotifier();
    }
  }

  Future<void> getCollectionReport([bool download = false]) async {
    try {
      var commonProvider = Provider.of<CommonProvider>(
          navigatorKey.currentContext!,
          listen: false);
      if(selectedBillPeriod==null){
        throw Exception('Select Billing Cycle');
      }
      Map<String,dynamic> params={
        'tenantId':commonProvider.userDetails!.selectedtenant!.code,
        'paymentStartDate':selectedBillPeriod?.split('-')[0],
        'paymentEndDate':selectedBillPeriod?.split('-')[1]
      };
      var response = await ReportsRepo().fetchCollectionReport(
          params);
      if (response != null) {
        collectionreports = response;
        if(download){
          generateExcel(
              collectionHeaderList
                  .map<String>((e) =>
              '${ApplicationLocalizations.of(navigatorKey.currentContext!).translate(e.label)}')
                  .toList(),
              getCollectionData(collectionreports!,isExcel: true).map<List<String>>((e) => e.tableRow.map((e) => e.label).toList()).toList()??[],
          title: 'CollectionReport_${commonProvider.userDetails?.selectedtenant?.code?.substring(3)}_$selectedBillPeriod',
          optionalData: [
            'Collection Report',
            '$selectedBillPeriod',
            '${ApplicationLocalizations.of(navigatorKey.currentContext!).translate(commonProvider.userDetails!.selectedtenant!.code!)} ${commonProvider.userDetails?.selectedtenant?.code?.substring(3)}',
            'Downloaded On ${DateFormats.timeStampToDate(DateTime.now().millisecondsSinceEpoch,format: 'dd/MMM/yyyy')}'
          ]);
        }else{
          genericTableData = BillsTableData(collectionHeaderList,getCollectionData(collectionreports!));
        }
        streamController.add(response);
        callNotifier();
      }else{
        streamController.add('error');
        throw Exception('API Error');
      }
      callNotifier();
    } catch (e, s) {
      collectionreports = [];
      ErrorHandler().allExceptionsHandler(navigatorKey.currentContext!, e, s);
      streamController.addError('error');
      callNotifier();
    }
  }

  void clearBuildTableData() {
    genericTableData = BillsTableData([],[]);
    callNotifier();
  }
  Future<void> generateExcel(
      List<String> headers, List<List<String>> tableData,{String title='HouseholdRegister',List<String> optionalData=const[]}) async {
    //Create a Excel document.

    //Creating a workbook.
    final Workbook workbook = Workbook();
    //Accessing via index
    final Worksheet sheet = workbook.worksheets[0];
    // sheet.showGridlines = false;

    // Enable calculation for worksheet.
    sheet.enableSheetCalculations();
    int dataStartRow=2;
    int headersStartRow=1;
    // //Set data in the worksheet.
    if(optionalData.isEmpty){
      sheet.getRangeByName('A1:D1').columnWidth = 32.5;
      sheet.getRangeByName('A1:D1').cellStyle.hAlign = HAlignType.center;
    }else{
      sheet.getRangeByName('A1:D1').columnWidth = 32.5;
      sheet.getRangeByName('A2:D2').columnWidth = 32.5;
      sheet.getRangeByName('A2:D2').cellStyle.hAlign = HAlignType.center;
      dataStartRow = 3;
      headersStartRow= 2;
      for (int i = 0; i < optionalData.length; i++) {
        sheet
            .getRangeByName('${CommonMethods.getAlphabetsWithKeyValue()[i].label}1')
            .setText(optionalData[CommonMethods.getAlphabetsWithKeyValue()[i].key]);
      }
    }

    for (int i = 0; i < headers.length; i++) {
      sheet
          .getRangeByName('${CommonMethods.getAlphabetsWithKeyValue()[i].label}$headersStartRow')
          .setText(headers[CommonMethods.getAlphabetsWithKeyValue()[i].key]);
    }

    for (int i = dataStartRow; i < tableData.length + 2; i++) {
      for (int j = 0; j < headers.length; j++) {
        sheet
            .getRangeByName(
            '${CommonMethods.getAlphabetsWithKeyValue()[j].label}$i')
            .setText(tableData[i - 2][j]);
        sheet
            .getRangeByName(
            '${CommonMethods.getAlphabetsWithKeyValue()[j].label}$i')
            .cellStyle
            .hAlign = HAlignType.center;
        sheet
            .getRangeByName(
            '${CommonMethods.getAlphabetsWithKeyValue()[j].label}$i')
            .cellStyle
            .vAlign = VAlignType.center;
      }
    }

    //Save and launch the excel.
    final List<int> bytes = workbook.saveAsStream();
    //Dispose the document.
    workbook.dispose();

    //Save and launch the file.
    await saveAndLaunchFile(bytes, '$title.xlsx');
  }
}