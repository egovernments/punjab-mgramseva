import 'dart:async';

import 'package:flutter/material.dart';
import 'package:mgramseva/model/dashboard/expense_dashboard.dart';
import 'package:mgramseva/model/expensesDetails/expenses_details.dart';
import 'package:mgramseva/repository/dashboard.dart';
import 'package:mgramseva/repository/expenses_repo.dart';
import 'package:mgramseva/utils/Constants/I18KeyConstants.dart';
import 'package:mgramseva/utils/Locilization/application_localizations.dart';
import 'package:mgramseva/utils/date_formats.dart';
import 'package:mgramseva/utils/error_logging.dart';
import 'package:mgramseva/utils/models.dart';
import 'package:mgramseva/utils/models.dart';

class DashBoardProvider with ChangeNotifier {
  var streamController = StreamController.broadcast();
  TextEditingController searchController = TextEditingController();
  ExpensesDetailsWithPagination? expenseDashboardDetails;
  int offset = 1;
  int limit = 10;
  late DateTime selectedMonth;

  @override
  void dispose() {
    streamController.close();
    super.dispose();
  }

  Future<void> fetchExpenseDashBoardDetails(BuildContext context, int limit, int offSet, [bool isSearch = false])  async {
    this.limit = limit;
    this.offset = offSet;
    notifyListeners();
    if(!isSearch && (offSet + limit) <= (expenseDashboardDetails?.expenseDetailList?.length ?? 0)){
      streamController.add(expenseDashboardDetails?.expenseDetailList?.sublist(offset -1, (offset + limit) -1));
      return;
    }

    if(isSearch) expenseDashboardDetails = null;

    var query = {
      'tenantId': 'pb',
      'offset' : '${offset - 1}',
      'limit' : '$limit',
      'fromDate' : '${DateTime(selectedMonth.year, selectedMonth.month, 1).millisecondsSinceEpoch}',
      'toDate' :  '${DateTime(selectedMonth.year, selectedMonth.month + 1, 0).millisecondsSinceEpoch}',
      'vendorName' : searchController.text.trim(),
      // 'challanNo' : searchController.text.trim()
    };

    query.removeWhere((key, value) => value is String && value.trim().isEmpty);
    streamController.add(null);

    try{
      var response = await ExpensesRepository()
          .expenseDashboard(query);
      if(response != null){
          if(expenseDashboardDetails == null) {
            expenseDashboardDetails = response;
            notifyListeners();
          }else {
            expenseDashboardDetails?.expenseDetailList?.addAll(
                response.expenseDetailList ?? <ExpensesDetailsModel>[]);
          }
        streamController.add(expenseDashboardDetails!.expenseDetailList!.isEmpty! ? <ExpensesDetailsModel>[] :
        expenseDashboardDetails?.expenseDetailList?.sublist(offSet -1, ((offset + limit - 1) > (expenseDashboardDetails?.totalCount ?? 0)) ? (expenseDashboardDetails!.totalCount! -1) : (offset + limit) -1));
      }
    }catch(e,s){
      streamController.addError('error');
      ErrorHandler().allExceptionsHandler(context, e,s);
    }
  }

  List<Tab> getExpenseTabList(BuildContext context, List<ExpensesDetailsModel> expenseList) {
    var list = [i18.dashboard.ALL, i18.dashboard.PAID, i18.dashboard.PENDING];
    return List.generate(list.length, (index) => Tab(text: '${ApplicationLocalizations.of(context)
        .translate(list[index])} (${getExpenseData(index, expenseList).length})'));
  }

  List<TableHeader> get expenseHeaderList => [
    TableHeader(i18.dashboard.BILL_ID_VENDOR),
    TableHeader(i18.expense.EXPENSE_TYPE),
    TableHeader(i18.common.AMOUNT),
    TableHeader(i18.expense.BILL_DATE),
    TableHeader(i18.common.PAID_DATE),
  ];


  List<TableHeader> get collectionHeaderList => [
    TableHeader(i18.common.CONNECTION_ID),
    TableHeader(i18.common.NAME),
    TableHeader(i18.dashboard.COLLECTIONS),
  ];

  List<TableDataRow> getExpenseData(int index, List<ExpensesDetailsModel> list) {

    switch(index){
      case 0:
        return list.map((e) => getExpenseRow(e)).toList();
      case 1:
        var filteredList =  list.where((e) => e.applicationStatus == 'PAID').toList();
        return filteredList.map((e) => getExpenseRow(e)).toList();
      case 2:
        var filteredList =  list.where((e) => e.applicationStatus == 'ACTIVE').toList();
        return filteredList.map((e) => getExpenseRow(e)).toList();
      default :
        return <TableDataRow>[];
    }
  }

  TableDataRow getExpenseRow(ExpensesDetailsModel expense){
    return TableDataRow(
      [
        TableData('${expense.challanNo}'),
        TableData('${expense.expenseType}'),
        TableData('${expense.totalAmount}'),
        TableData('${expense.billDate}'),
        TableData('${DateFormats.timeStampToDate(expense.paidDate)}'),
      ]
    );
  }

  onExpenseSort(){

  }

  void onSearch(String val, BuildContext context){
    fetchExpenseDashBoardDetails(context, limit, 1, true);
  }

  void onChangeOfDate(DateTime? date, BuildContext context, _overlayEntry){
    selectedMonth = date ?? DateTime.now();
    notifyListeners();
    removeOverLay(_overlayEntry);
    fetchExpenseDashBoardDetails(context, limit, 1, true);
  }

  void onChangeOfPageLimit(PaginationResponse response, BuildContext context){
    fetchExpenseDashBoardDetails(context, response.limit, response.offset);
  }

  bool removeOverLay(_overlayEntry){
    try{
      _overlayEntry?.remove();
      return true;
    }catch(e){
      return false;
    }
  }
}