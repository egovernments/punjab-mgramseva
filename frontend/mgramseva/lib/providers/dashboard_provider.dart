import 'dart:async';

import 'package:flutter/material.dart';
import 'package:mgramseva/model/dashboard/expense_dashboard.dart';
import 'package:mgramseva/model/expensesDetails/expenses_details.dart';
import 'package:mgramseva/repository/dashboard.dart';
import 'package:mgramseva/repository/expenses_repo.dart';
import 'package:mgramseva/utils/Constants/I18KeyConstants.dart';
import 'package:mgramseva/utils/date_formats.dart';
import 'package:mgramseva/utils/error_logging.dart';
import 'package:mgramseva/utils/models.dart';
import 'package:mgramseva/utils/models.dart';

class DashBoardProvider with ChangeNotifier {
  var streamController = StreamController.broadcast();
  TextEditingController searchController = TextEditingController();
  late List<ExpensesDetailsModel> expenseDashboardDetails;
  int offset = 0;
  @override
  void dispose() {
    streamController.close();
    super.dispose();
  }

  Future<void> fetchExpenseDashBoardDetails(BuildContext context)  async {

    var query = {
      'tenantId': 'pb',
    };

    streamController.add(null);

    try{
      var response = await ExpensesRepository()
          .searchExpense(query);
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
    List<ExpensesDetailsModel> list = expenseDashboardDetails;

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
    fetchExpenseDashBoardDetails(context);
  }

  void onChangeOfPagination(PaginationResponse response){

  }
}