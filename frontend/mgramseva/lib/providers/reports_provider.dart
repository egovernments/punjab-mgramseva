import 'dart:async';

import 'package:flutter/material.dart';
import 'package:mgramseva/model/reports/InactiveConsumerReportData.dart';
import 'package:mgramseva/model/reports/vendor_report_data.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_xlsio/xlsio.dart';

import '../model/common/BillsTableData.dart';
import '../model/localization/language.dart';
import '../model/mdms/tax_period.dart';
import '../model/reports/bill_report_data.dart';
import '../model/reports/collection_report_data.dart';
import '../model/reports/expense_bill_report_data.dart';
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
  LanguageList? billingYearList;
  var selectedBillYear;
  var selectedBillPeriod;
  var selectedBillCycle;
  var billingyearCtrl = TextEditingController();
  var billingcycleCtrl = TextEditingController();
  List<BillReportData>? demandreports;
  List<CollectionReportData>? collectionreports;
  List<InactiveConsumerReportData>? inactiveconsumers;
  List<ExpenseBillReportData>? expenseBillReportData;
  List<VendorReportData>? vendorReportData;
  BillsTableData genericTableData = BillsTableData([], []);
  int limit = 10;
  int offset = 1;

  void clearBillingSelection() {
    selectedBillYear = null;
    selectedBillPeriod = null;
    selectedBillCycle = null;
    billingcycleCtrl.clear();
    billingyearCtrl.clear();
    notifyListeners();
  }

  void clearTableData() {
    genericTableData = BillsTableData([], []);
    notifyListeners();
  }

  dispose() {
    streamController.close();
    super.dispose();
  }

  List<TableHeader> get demandHeaderList => [
        TableHeader(i18.common.CONNECTION_ID),
        TableHeader(
          i18.consumer.OLD_CONNECTION_ID,
          isSortingRequired: false,
        ),
        TableHeader(i18.common.NAME),
        TableHeader('Consumer Created On Date'),
        TableHeader(i18.billDetails.CORE_PENALTY),
        TableHeader(i18.common.CORE_ADVANCE),
        TableHeader(i18.billDetails.TOTAL_AMOUNT),
      ];

  List<TableHeader> get collectionHeaderList => [
        TableHeader(i18.common.CONNECTION_ID),
        TableHeader(
          i18.consumer.OLD_CONNECTION_ID,
          isSortingRequired: false,
        ),
        TableHeader(i18.common.NAME),
        TableHeader(i18.common.PAYMENT_METHOD),
        TableHeader(i18.billDetails.TOTAL_AMOUNT),
      ];
  List<TableHeader> get inactiveConsumerHeaderList => [
    TableHeader(i18.common.CONNECTION_ID),
    TableHeader(i18.common.STATUS),
    TableHeader(i18.common.INACTIVATED_DATE),
    TableHeader(i18.common.INACTIVATED_BY_NAME),
  ];
  List<TableHeader> get expenseBillReportHeaderList => [
    TableHeader(i18.expense.EXPENSE_TYPE),
    TableHeader(i18.expense.VENDOR_NAME),
    TableHeader(i18.expense.AMOUNT),
    TableHeader(i18.expense.BILL_DATE),
    TableHeader(i18.expense.EXPENSE_START_DATE),
    TableHeader(i18.expense.EXPENSE_END_DATE),
    TableHeader(i18.expense.APPLICATION_STATUS),
    TableHeader(i18.expense.PAID_DATE),
    TableHeader(i18.expense.HAS_ATTACHMENT),
    TableHeader(i18.expense.CANCELLED_TIME),
    TableHeader(i18.expense.CANCELLED_BY),

  ];

  List<TableHeader> get vendorReportHeaderList => [
        TableHeader(i18.expense.VENDOR_NAME),
        TableHeader(i18.common.MOBILE_NUMBER),
        TableHeader(i18.expense.EXPENSE_TYPE),
        TableHeader(i18.common.BILL_ID),
      ];

  void onChangeOfPageLimit(
      PaginationResponse response, String type, BuildContext context) {
    if (type == i18.dashboard.BILL_REPORT) {
      getDemandReport(limit: response.limit, offset: response.offset);
    }
    if (type == i18.dashboard.COLLECTION_REPORT) {
      getCollectionReport(limit: response.limit, offset: response.offset);
    }
    if (type == i18.dashboard.INACTIVE_CONSUMER_REPORT) {
      getInactiveConsumerReport(limit: response.limit, offset: response.offset);
    }
    if (type == i18.dashboard.EXPENSE_BILL_REPORT) {
      getExpenseBillReport(limit: response.limit, offset: response.offset);
    }
    if (type == i18.dashboard.VENDOR_REPORT) {
      getVendorReport(limit: response.limit, offset: response.offset);
    }
  }

  List<TableDataRow> getDemandsData(List<BillReportData> list,
      {isExcel = false}) {
    return list.map((e) => getDemandRow(e, isExcel: isExcel)).toList();
  }

  TableDataRow getDemandRow(BillReportData data, {bool isExcel = false}) {
    String? name = CommonMethods.truncateWithEllipsis(20, data.consumerName!);
    return TableDataRow([
      TableData(
        isExcel
            ? '${data.connectionNo ?? '-'}'
            : '${data.connectionNo?.split('/').first ?? ''}/...${data.connectionNo?.split('/').last ?? ''}',
      ),
      TableData(
          '${(data.oldConnectionNo == null ? null : data.oldConnectionNo!.isEmpty ? null : data.oldConnectionNo) ?? '-'}'),
      TableData('${name ?? '-'}'),
      TableData(
          '${DateFormats.timeStampToDate(int.parse(data.consumerCreatedOnDate ?? '0'))}'),
      TableData('${data.penalty ?? '0'}'),
      TableData('${data.advance ?? '0'}'),
      TableData('${data.demandAmount ?? '0'}'),
    ]);
  }

  List<TableDataRow> getCollectionData(List<CollectionReportData> list,
      {bool isExcel = false}) {
    return list.map((e) => getCollectionRow(e, isExcel: isExcel)).toList();
  }

  TableDataRow getCollectionRow(CollectionReportData data,
      {bool isExcel = false}) {
    String? name = CommonMethods.truncateWithEllipsis(20, data.consumerName!);
    if (data.oldConnectionNo != null && data.oldConnectionNo!.isEmpty) {
      data.oldConnectionNo = '-';
    }
    return TableDataRow([
      TableData(
        isExcel
            ? '${data.connectionNo ?? '-'}'
            : '${data.connectionNo?.split('/').first ?? ''}/...${data.connectionNo?.split('/').last ?? ''}',
      ),
      TableData('${(data.oldConnectionNo == null ? null : data.oldConnectionNo!.isEmpty ? null : data.oldConnectionNo) ?? '-'}'),
      TableData('${name ?? '-'}'),
      TableData('${data.paymentMode ?? '-'}'),
      TableData('${data.paymentAmount ?? '0'}'),
    ]);
  }
  List<TableDataRow> getInactiveConsumersData(List<InactiveConsumerReportData> list,
      {bool isExcel = false}) {
    return list.map((e) => getInactiveConsumersDataRow(e, isExcel: isExcel)).toList();
  }

  TableDataRow getInactiveConsumersDataRow(InactiveConsumerReportData data,
      {bool isExcel = false}) {
    String? inactivatedBy = CommonMethods.truncateWithEllipsis(20, data.inactivatedByName!);
    if (data.connectionNo != null && data.connectionNo!.isEmpty) {
      data.connectionNo = '-';
    }
    var inactivatedDate = DateFormats.timeStampToDate(data.inactiveDate?.toInt(),format: "dd/MM/yyyy");
    return TableDataRow([
      TableData(
        isExcel
            ? '${data.connectionNo ?? '-'}'
            : '${data.connectionNo?.split('/').first ?? ''}/...${data.connectionNo?.split('/').last ?? ''}',
      ),
      TableData('${data.status??'-'}'),
      TableData('${inactivatedDate ?? '-'}'),
      TableData('${inactivatedBy ?? '-'}'),
    ]);
  }
  List<TableDataRow> getExpenseBillReportData(List<ExpenseBillReportData> list,
      {bool isExcel = false}) {
    return list.map((e) => getExpenseBillReportDataRow(e, isExcel: isExcel)).toList();
  }
  TableDataRow getExpenseBillReportDataRow(ExpenseBillReportData data,
      {bool isExcel = false}) {
    String? vendorName = CommonMethods.truncateWithEllipsis(20, data.vendorName!);
    String? typeOfExpense = CommonMethods.truncateWithEllipsis(20, data.typeOfExpense!);
    String? applicationStatus = CommonMethods.truncateWithEllipsis(20, data.applicationStatus!);
    String? lastModifiedBy = CommonMethods.truncateWithEllipsis(20, data.lastModifiedBy!);
    String? fileLink = CommonMethods.truncateWithEllipsis(20, data.filestoreid!);
    var billDate = DateFormats.timeStampToDate(data.billDate?.toInt(),format: "dd/MM/yyyy");
    var taxPeriodFrom = DateFormats.timeStampToDate(data.taxPeriodFrom?.toInt(),format: "dd/MM/yyyy");
    var taxPeriodTo = DateFormats.timeStampToDate(data.taxPeriodTo?.toInt(),format: "dd/MM/yyyy");
    var paidDate = data.paidDate==0?'-':DateFormats.timeStampToDate(data.paidDate?.toInt(),format: "dd/MM/yyyy");
    var lastModifiedTime = data.lastModifiedTime==0?'-':DateFormats.timeStampToDate(data.lastModifiedTime?.toInt(),format: "dd/MM/yyyy");
    return TableDataRow([
      TableData('${ApplicationLocalizations.of(navigatorKey.currentContext!).translate(typeOfExpense ?? '-')}'),
      TableData('${vendorName ?? '-'}'),
      TableData('${data.amount ?? '-'}'),
      TableData('${billDate ?? '-'}'),
      TableData('${taxPeriodFrom ?? '-'}'),
      TableData('${taxPeriodTo ?? '-'}'),
      TableData('${applicationStatus ?? '-'}'),
      TableData('${paidDate ?? '-'}'),
      TableData('${fileLink ?? '-'}'),
      TableData('${lastModifiedTime ?? '-'}'),
      TableData('${lastModifiedBy ?? '-'}'),
    ]);
  }
  List<TableDataRow> getVendorReportData(List<VendorReportData> list,
      {bool isExcel = false}) {
    return list.map((e) => getVendorReportDataRow(e, isExcel: isExcel)).toList();
  }
  TableDataRow getVendorReportDataRow(VendorReportData data,
      {bool isExcel = false}) {
    String? vendorName = CommonMethods.truncateWithEllipsis(20, data.vendorName!);
    String? typeOfExpense = CommonMethods.truncateWithEllipsis(20, data.typeOfExpense!);
    String? billId = CommonMethods.truncateWithEllipsis(20, data.billId!);
    return TableDataRow([
      TableData('${vendorName ?? '-'}'),
      TableData('${data.mobileNo ?? '-'}'),
      TableData('${ApplicationLocalizations.of(navigatorKey.currentContext!).translate(typeOfExpense ?? '-')}'),
      TableData('${billId ?? '-'}'),
    ]);
  }

  void callNotifier() {
    notifyListeners();
  }

  void onChangeOfBillYear(val) {
    selectedBillYear = val;
    print(val.toString());
    billingyearCtrl.text = val.toString();
    billingcycleCtrl.clear();
    selectedBillCycle = null;
    selectedBillPeriod = null;
    notifyListeners();
  }

  void onChangeOfBillCycle(cycle) {
    var val = cycle['code'];
    var result = DateTime.parse(val.toString());
    selectedBillCycle = cycle;
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
      var res = await CoreRepository().getMdms(mdms.getTenantFinancialYearList(
          commonProvider.userDetails!.userRequest!.tenantId.toString()));
      billingYearList = res;
      notifyListeners();
      streamController.add(billingYearList);
    } catch (e, s) {
      ErrorHandler().allExceptionsHandler(navigatorKey.currentContext!, e, s);
      streamController.addError('error');
    }
  }
  List<TaxPeriod> getFinancialYearListDropdownA(
      LanguageList? languageList) {
    if (languageList?.mdmsRes?.billingService?.taxPeriodList != null) {
      CommonMethods.getFilteredFinancialYearList(
          languageList?.mdmsRes?.billingService?.taxPeriodList ??
              <TaxPeriod>[]);
      languageList?.mdmsRes?.billingService?.taxPeriodList!
          .sort((a, b) => a.fromDate!.compareTo(b.fromDate!));
      return (languageList?.mdmsRes?.billingService?.taxPeriodList ??
          <TaxPeriod>[])
          .reversed
          .toList();
    }
    return <TaxPeriod>[];
  }
  List<Map<String,dynamic>> getBillingCycleDropdownA(
      dynamic selectedBillYear) {
    List<Map<String,dynamic>> dates = [];
    if (selectedBillYear != null) {
      DatePeriod ytd;
      var fromDate = DateFormats.getFormattedDateToDateTime(
          DateFormats.timeStampToDate(selectedBillYear.fromDate)) as DateTime;

      var toDate = DateFormats.getFormattedDateToDateTime(
          DateFormats.timeStampToDate(selectedBillYear.toDate)) as DateTime;

      ytd = DatePeriod(fromDate, toDate, DateType.YTD);

      /// Get months based on selected billing year
      var months = CommonMethods.getPastMonthUntilFinancialYTD(ytd,
          showCurrentMonth: true);

      /// if selected year is future year means all the months will be removed
      if (fromDate.year > ytd.endDate.year) months.clear();

      for (var i = 0; i < months.length; i++) {
        var prevMonth = months[i].startDate;
        var r = {"code": prevMonth, "name": '${ApplicationLocalizations.of(navigatorKey.currentContext!)
            .translate((Constants.MONTHS[prevMonth.month - 1])) +
        " - " +
            prevMonth.year.toString()}'};
        dates.add(r);
      }
    }
    // if (dates.length > 0) {
    //   return (dates).map((value) {
    //     var d = value['name'];
    //     return "${ApplicationLocalizations.of(navigatorKey.currentContext!)
    //         .translate((Constants.MONTHS[d.month - 1])) +
    //         " - " +
    //         d.year.toString()}";
    //   }).toList();
    // }
    return dates;
  }
  List<TaxPeriod> getFinancialYearListDropdown(
      LanguageList? languageList) {
    if (languageList?.mdmsRes?.billingService?.taxPeriodList != null) {
      CommonMethods.getFilteredFinancialYearList(
          languageList?.mdmsRes?.billingService?.taxPeriodList ??
              <TaxPeriod>[]);
      languageList?.mdmsRes?.billingService?.taxPeriodList!
          .sort((a, b) => a.fromDate!.compareTo(b.fromDate!));
      return (languageList?.mdmsRes?.billingService?.taxPeriodList ??
              <TaxPeriod>[])
          .map((value) {
            return value;
          })
          .toList()
          .reversed
          .toList();
    }
    return <TaxPeriod>[];
  }

  List<Map<String,dynamic>> getBillingCycleDropdown(
      dynamic selectedBillYear) {
    var dates = <Map<String,dynamic>>[];
    if (selectedBillYear != null) {
      DatePeriod ytd;
      var fromDate = DateFormats.getFormattedDateToDateTime(
          DateFormats.timeStampToDate(selectedBillYear.fromDate)) as DateTime;

      var toDate = DateFormats.getFormattedDateToDateTime(
          DateFormats.timeStampToDate(selectedBillYear.toDate)) as DateTime;

      ytd = DatePeriod(fromDate, toDate, DateType.YTD);

      /// Get months based on selected billing year
      var months = CommonMethods.getPastMonthUntilFinancialYTD(ytd,
          showCurrentMonth: true);

      /// if selected year is future year means all the months will be removed
      if (fromDate.year > ytd.endDate.year) months.clear();

      for (var i = 0; i < months.length; i++) {
        var prevMonth = months[i].startDate;
        Map<String,dynamic> r = {"code": prevMonth, "name": "${ApplicationLocalizations.of(navigatorKey.currentContext!)
            .translate((Constants.MONTHS[prevMonth.month - 1])) +
            " - " +
            prevMonth.year.toString()}"};
        dates.add(r);
      }
    }
    if (dates.length > 0) {
      return dates;
    }
    return <Map<String,dynamic>>[];
  }

  Future<void> getDemandReport(
      {bool download = false,
      int offset = 1,
      int limit = 10,
      String sortOrder = "ASC"}) async {
    try {
      var commonProvider = Provider.of<CommonProvider>(
          navigatorKey.currentContext!,
          listen: false);
      if (selectedBillPeriod == null) {
        throw Exception('Select Billing Cycle');
      }
      Map<String, dynamic> params = {
        'tenantId': commonProvider.userDetails!.selectedtenant!.code,
        'demandStartDate': selectedBillPeriod?.split('-')[0],
        'demandEndDate': selectedBillPeriod?.split('-')[1],
        'offset': '${offset - 1}',
        'limit': '${download ? -1 : limit}',
        'sortOrder': '$sortOrder'
      };
      var response = await ReportsRepo().fetchBillReport(params);
      if (response != null) {
        demandreports = response;
        if (download) {
          generateExcel(
              demandHeaderList
                  .map<String>((e) =>
                      '${ApplicationLocalizations.of(navigatorKey.currentContext!).translate(e.label)}')
                  .toList(),
              getDemandsData(demandreports!, isExcel: true)
                      .map<List<String>>(
                          (e) => e.tableRow.map((e) => e.label).toList())
                      .toList() ??
                  [],
              title:
                  'DemandReport_${commonProvider.userDetails?.selectedtenant?.code?.substring(3)}_${selectedBillPeriod.toString().replaceAll('/', '_')}',
              optionalData: [
                'Demand Report',
                '$selectedBillPeriod',
                '${ApplicationLocalizations.of(navigatorKey.currentContext!).translate(commonProvider.userDetails!.selectedtenant!.code!)}',
                '${commonProvider.userDetails?.selectedtenant?.code?.substring(3)}',
                'Downloaded On ${DateFormats.timeStampToDate(DateTime.now().millisecondsSinceEpoch, format: 'dd/MMM/yyyy')}'
              ]);
        } else {
          if (demandreports != null && demandreports!.isNotEmpty) {
            this.limit = limit;
            this.offset = offset;
            this.genericTableData = BillsTableData(
                demandHeaderList, getDemandsData(demandreports!));
          }
        }
        streamController.add(response);
        callNotifier();
      } else {
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

  Future<void> getCollectionReport(
      {bool download = false,
      int offset = 1,
      int limit = 10,
      String sortOrder = "ASC"}) async {
    try {
      var commonProvider = Provider.of<CommonProvider>(
          navigatorKey.currentContext!,
          listen: false);
      if (selectedBillPeriod == null) {
        throw Exception('Select Billing Cycle');
      }
      Map<String, dynamic> params = {
        'tenantId': commonProvider.userDetails!.selectedtenant!.code,
        'paymentStartDate': selectedBillPeriod?.split('-')[0],
        'paymentEndDate': selectedBillPeriod?.split('-')[1],
        'offset': '${offset - 1}',
        'limit': '${download ? -1 : limit}',
        'sortOrder': '$sortOrder'
      };
      var response = await ReportsRepo().fetchCollectionReport(params);
      if (response != null) {
        collectionreports = response;
        if (download) {
          generateExcel(
              collectionHeaderList
                  .map<String>((e) =>
                      '${ApplicationLocalizations.of(navigatorKey.currentContext!).translate(e.label)}')
                  .toList(),
              getCollectionData(collectionreports!, isExcel: true)
                      .map<List<String>>(
                          (e) => e.tableRow.map((e) => e.label).toList())
                      .toList() ??
                  [],
              title:
                  'CollectionReport_${commonProvider.userDetails?.selectedtenant?.code?.substring(3)}_${selectedBillPeriod.toString().replaceAll('/', '_')}',
              optionalData: [
                'Collection Report',
                '$selectedBillPeriod',
                '${ApplicationLocalizations.of(navigatorKey.currentContext!).translate(commonProvider.userDetails!.selectedtenant!.code!)}',
                '${commonProvider.userDetails?.selectedtenant?.code?.substring(3)}',
                'Downloaded On ${DateFormats.timeStampToDate(DateTime.now().millisecondsSinceEpoch, format: 'dd/MMM/yyyy')}'
              ]);
        } else {
          if (collectionreports != null && collectionreports!.isNotEmpty) {
            this.limit = limit;
            this.offset = offset;
            this.genericTableData = BillsTableData(
                collectionHeaderList, getCollectionData(collectionreports!));
          }
        }
        streamController.add(response);
        callNotifier();
      } else {
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

  Future<void> getInactiveConsumerReport(
      {bool download = false,
        int offset = 1,
        int limit = 10,
        String sortOrder = "ASC"}) async {
    try {
      var commonProvider = Provider.of<CommonProvider>(
          navigatorKey.currentContext!,
          listen: false);
      if (selectedBillPeriod == null) {
        throw Exception('Select Billing Cycle');
      }
      Map<String, dynamic> params = {
        'tenantId': commonProvider.userDetails!.selectedtenant!.code,
        'monthStartDate': selectedBillPeriod?.split('-')[0],
        'monthEndDate': selectedBillPeriod?.split('-')[1],
        'offset': '${offset - 1}',
        'limit': '${download ? -1 : limit}',
        'sortOrder': '$sortOrder'
      };
      var response = await ReportsRepo().fetchInactiveConsumerReport(params);
      if (response != null) {
        inactiveconsumers = response;
        if (download) {
          generateExcel(
              inactiveConsumerHeaderList
                  .map<String>((e) =>
              '${ApplicationLocalizations.of(navigatorKey.currentContext!).translate(e.label)}')
                  .toList(),
              getInactiveConsumersData(inactiveconsumers!, isExcel: true)
                  .map<List<String>>(
                      (e) => e.tableRow.map((e) => e.label).toList())
                  .toList() ??
                  [],
              title:
              'InactiveConsumers_${commonProvider.userDetails?.selectedtenant?.code?.substring(3)}_${selectedBillPeriod.toString().replaceAll('/', '_')}',
              optionalData: [
                'Inactive Consumer Report',
                '$selectedBillPeriod',
                '${ApplicationLocalizations.of(navigatorKey.currentContext!).translate(commonProvider.userDetails!.selectedtenant!.code!)}',
                '${commonProvider.userDetails?.selectedtenant?.code?.substring(3)}',
                'Downloaded On ${DateFormats.timeStampToDate(DateTime.now().millisecondsSinceEpoch, format: 'dd/MMM/yyyy')}'
              ]);
        } else {
          if (inactiveconsumers != null && inactiveconsumers!.isNotEmpty) {
            this.limit = limit;
            this.offset = offset;
            this.genericTableData = BillsTableData(
                inactiveConsumerHeaderList, getInactiveConsumersData(inactiveconsumers!));
          }
        }
        streamController.add(response);
        callNotifier();
      } else {
        streamController.add('error');
        throw Exception('API Error');
      }
      callNotifier();
    } catch (e, s) {
      inactiveconsumers = [];
      ErrorHandler().allExceptionsHandler(navigatorKey.currentContext!, e, s);
      streamController.addError('error');
      callNotifier();
    }
  }
  Future<void> getExpenseBillReport(
      {bool download = false,
        int offset = 1,
        int limit = 10,
        String sortOrder = "ASC"}) async {
    try {
      var commonProvider = Provider.of<CommonProvider>(
          navigatorKey.currentContext!,
          listen: false);
      if (selectedBillPeriod == null) {
        throw Exception('Select Billing Cycle');
      }
      Map<String, dynamic> params = {
        'tenantId': commonProvider.userDetails!.selectedtenant!.code,
        'monthstartDate': selectedBillPeriod?.split('-')[0],
        'monthendDate': selectedBillPeriod?.split('-')[1],
        'offset': '${offset - 1}',
        'limit': '${download ? -1 : limit}',
        'sortOrder': '$sortOrder'
      };
      var response = await ReportsRepo().fetchExpenseBillReport(params);
      if (response != null) {
        expenseBillReportData = response;
        if (download) {
          generateExcel(
              expenseBillReportHeaderList
                  .map<String>((e) =>
              '${ApplicationLocalizations.of(navigatorKey.currentContext!).translate(e.label)}')
                  .toList(),
              getExpenseBillReportData(expenseBillReportData!, isExcel: true)
                  .map<List<String>>(
                      (e) => e.tableRow.map((e) => e.label).toList())
                  .toList() ??
                  [],
              title:
              'ExpenseBillReport_${commonProvider.userDetails?.selectedtenant?.code?.substring(3)}_${selectedBillPeriod.toString().replaceAll('/', '_')}',
              optionalData: [
                'Expense Bill Report',
                '$selectedBillPeriod',
                '${ApplicationLocalizations.of(navigatorKey.currentContext!).translate(commonProvider.userDetails!.selectedtenant!.code!)}',
                '${commonProvider.userDetails?.selectedtenant?.code?.substring(3)}',
                'Downloaded On ${DateFormats.timeStampToDate(DateTime.now().millisecondsSinceEpoch, format: 'dd/MMM/yyyy')}'
              ]);
        } else {
          if (expenseBillReportData != null && expenseBillReportData!.isNotEmpty) {
            this.limit = limit;
            this.offset = offset;
            this.genericTableData = BillsTableData(
                expenseBillReportHeaderList, getExpenseBillReportData(expenseBillReportData!));
          }
        }
        streamController.add(response);
        callNotifier();
      } else {
        streamController.add('error');
        throw Exception('API Error');
      }
    }
    catch (e, s) {
      ErrorHandler().allExceptionsHandler(navigatorKey.currentContext!, e, s);
      streamController.addError('error');
      callNotifier();
    }
  }

  Future<void> getVendorReport(
      {bool download = false,
        int offset = 1,
        int limit = 10,
        String sortOrder = "ASC"}) async {
    try {
      var commonProvider = Provider.of<CommonProvider>(
          navigatorKey.currentContext!,
          listen: false);
      if (selectedBillPeriod == null) {
        throw Exception('Select Billing Cycle');
      }
      Map<String, dynamic> params = {
        'tenantId': commonProvider.userDetails!.selectedtenant!.code,
        'monthStartDate': selectedBillPeriod?.split('-')[0],
        'monthEndDate': selectedBillPeriod?.split('-')[1],
        'offset': '${offset - 1}',
        'limit': '${download ? -1 : limit}',
        'sortOrder': '$sortOrder'
      };
      var response = await ReportsRepo().fetchVendorReport(params);
      if (response != null) {
        vendorReportData = response;
        if (download) {
          generateExcel(
              vendorReportHeaderList
                  .map<String>((e) =>
              '${ApplicationLocalizations.of(navigatorKey.currentContext!).translate(e.label)}')
                  .toList(),
              getVendorReportData(vendorReportData!, isExcel: true)
                  .map<List<String>>(
                      (e) => e.tableRow.map((e) => e.label).toList())
                  .toList() ??
                  [],
              title:
              'VendorReport_${commonProvider.userDetails?.selectedtenant?.code?.substring(3)}_${selectedBillPeriod.toString().replaceAll('/', '_')}',
              optionalData: [
                'Vendor Report',
                '$selectedBillPeriod',
                '${ApplicationLocalizations.of(navigatorKey.currentContext!).translate(commonProvider.userDetails!.selectedtenant!.code!)}',
                '${commonProvider.userDetails?.selectedtenant?.code?.substring(3)}',
                'Downloaded On ${DateFormats.timeStampToDate(DateTime.now().millisecondsSinceEpoch, format: 'dd/MMM/yyyy')}'
              ]);
        } else {
          if (vendorReportData != null && vendorReportData!.isNotEmpty) {
            this.limit = limit;
            this.offset = offset;
            this.genericTableData = BillsTableData(
                vendorReportHeaderList, getVendorReportData(vendorReportData!));
          }
        }
        streamController.add(response);
        callNotifier();
      } else {
        streamController.add('error');
        throw Exception('API Error');
      }
    }
    catch (e, s) {
      ErrorHandler().allExceptionsHandler(navigatorKey.currentContext!, e, s);
      streamController.addError('error');
      callNotifier();
    }
  }

  void clearBuildTableData() {
    genericTableData = BillsTableData([], []);
    callNotifier();
  }

  Future<void> generateExcel(List<String> headers, List<List<String>> tableData,
      {String title = 'HouseholdRegister',
      List<String> optionalData = const []}) async {
    //Create a Excel document.

    //Creating a workbook.
    final Workbook workbook = Workbook();
    //Accessing via index
    final Worksheet sheet = workbook.worksheets[0];
    // sheet.showGridlines = false;

    // Enable calculation for worksheet.
    sheet.enableSheetCalculations();
    int dataStartRow = 2;
    int headersStartRow = 1;
    // //Set data in the worksheet.
    if (optionalData.isEmpty) {
      sheet.getRangeByName('A1:D1').columnWidth = 32.5;
      sheet.getRangeByName('A1:D1').cellStyle.hAlign = HAlignType.center;
    } else {
      sheet.getRangeByName('A1:D1').columnWidth = 32.5;
      sheet.getRangeByName('A2:D2').columnWidth = 32.5;
      sheet.getRangeByName('A2:D2').cellStyle.hAlign = HAlignType.center;
      dataStartRow = 3;
      headersStartRow = 2;
      for (int i = 0; i < optionalData.length; i++) {
        sheet
            .getRangeByName(
                '${CommonMethods.getAlphabetsWithKeyValue()[i].label}1')
            .setText(
                optionalData[CommonMethods.getAlphabetsWithKeyValue()[i].key]);
      }
    }

    for (int i = 0; i < headers.length; i++) {
      sheet
          .getRangeByName(
              '${CommonMethods.getAlphabetsWithKeyValue()[i].label}$headersStartRow')
          .setText(headers[CommonMethods.getAlphabetsWithKeyValue()[i].key]);
    }

    for (int i = dataStartRow; i < tableData.length + dataStartRow; i++) {
      for (int j = 0; j < headers.length; j++) {
        sheet
            .getRangeByName(
                '${CommonMethods.getAlphabetsWithKeyValue()[j].label}$i')
            .setText(tableData[i - dataStartRow][j]);
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
