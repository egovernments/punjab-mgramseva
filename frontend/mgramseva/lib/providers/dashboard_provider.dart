import 'dart:async';

import 'package:flutter/material.dart';
import 'package:mgramseva/model/dashboard/expense_dashboard.dart';
import 'package:mgramseva/repository/dashboard.dart';
import 'package:mgramseva/utils/Constants/I18KeyConstants.dart';
import 'package:mgramseva/utils/error_logging.dart';
import 'package:mgramseva/utils/models.dart';
import 'package:mgramseva/utils/models.dart';

class DashBoardProvider with ChangeNotifier {
  var streamController = StreamController.broadcast();
  TextEditingController searchController = TextEditingController();
  late ExpenseDashboard expenseDashboardDetails;

  @override
  void dispose() {
    streamController.close();
    super.dispose();
  }

  Future<void> fetchExpenseDashBoardDetails(BuildContext context)  async {
    try{
      var response = await DashBoardRepository().loadExpenseDashboardDetails({});
      if(response != null){
        expenseDashboardDetails = response;
        streamController.add(response);
      }
    }catch(e,s){
      streamController.addError('error');
      ErrorHandler().allExceptionsHandler(context, e);
    }
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

  List<TableDataRow> getExpenseData(int index) {
    var searchFilterItems = expenseDashboardDetails.data;
    
    if(searchController.text.trim().isNotEmpty){
      searchFilterItems = expenseDashboardDetails.data?.where((element) => element.headerName!.contains(searchController.text.trim())).toList();
    }
    switch(index){
      case 0:
        return searchFilterItems!.map((e) => getExpenseRow(e)).toList();
      case 1:
        var filteredList =  searchFilterItems!.where((e) => e.plots?.last.label != null).toList();
        return filteredList!.map((e) => getExpenseRow(e)).toList();
      case 2:
        var filteredList =  searchFilterItems!.where((e) => e.plots?.last.label == null).toList();
        return filteredList!.map((e) => getExpenseRow(e)).toList();
      default :
        return <TableDataRow>[];
    }
  }

  TableDataRow getExpenseRow(ExpenseDashboardRow expenseDashboardRow){
    expenseDashboardRow.plots?.removeAt(0);
    return TableDataRow(
        List.generate(expenseDashboardRow.plots?.length ?? 0, (index){
          var plot = expenseDashboardRow.plots![index];
          return TableData(plot.label ?? '');
        })
    );
  }

  onExpenseSort(){

  }

  void onSearch(String val){
    notifyListeners();
  }
}