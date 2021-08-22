import 'dart:async';

import 'package:flutter/material.dart';
import 'package:mgramseva/model/dashboard/expense_dashboard.dart';
import 'package:mgramseva/repository/dashboard.dart';
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
    TableHeader('Bill Id - Vendor'),
    TableHeader('Expense Type'),
    TableHeader('Amount'),
    TableHeader('Bill Date'),
    TableHeader('Paid Date'),
  ];


  List<TableHeader> get collectionHeaderList => [
    TableHeader('Connection-ID'),
    TableHeader('Name'),
    TableHeader('Collections'),
  ];

  List<TableDataRow> getExpenseData(int index) {

    switch(index){
      case 0:
        return expenseDashboardDetails.data!.map((e) => getExpenseRow(e)).toList();
      case 1:
        var filteredList =  expenseDashboardDetails.data!.where((e) => e.plots?.last.label != null).toList();
        return filteredList!.map((e) => getExpenseRow(e)).toList();
      case 2:
        var filteredList =  expenseDashboardDetails.data!.where((e) => e.plots?.last.label == null).toList();
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

  void onSearch(String val){
    notifyListeners();
  }
}