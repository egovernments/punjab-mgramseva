import 'dart:async';

import 'package:flutter/material.dart';
import 'package:mgramseva/model/expensesDetails/expenses_details.dart';
import 'package:mgramseva/model/localization/language.dart';
import 'package:mgramseva/model/mdms/expense_type.dart';
import 'package:mgramseva/repository/core_repo.dart';
import 'package:mgramseva/repository/expenses_repo.dart';
import 'package:mgramseva/services/MDMS.dart';
import 'package:mgramseva/utils/custom_exception.dart';
import 'package:mgramseva/utils/date_formats.dart';
import 'package:mgramseva/utils/global_variables.dart';
import 'package:provider/provider.dart';

class ExpensesDetailsProvider with ChangeNotifier {
  var streamController = StreamController.broadcast();
  var expenditureDetails = ExpensesDetailsModel();
  late GlobalKey<FormState> formKey;
  var autoValidation = false;
  LanguageList? languageList;

  dispose() {
    streamController.close();
    super.dispose();
  }

  Future<void> getExpensesDetails() async {
    try {
      streamController.add(expenditureDetails);
    } catch (e) {
      streamController.addError('error');
    }
  }

  Future<void> addExpensesDetails() async {
    expenditureDetails.setText();
    try {
     var res = ExpensesRepository().addExpenses(expenditureDetails.toJson());
    }on CustomException catch(e){

    } catch(e){

    }
  }

  Future<void> getExpenses() async {
    try {
      var res = await CoreRepository().getMdms(getExpenseMDMS('pb'));
      languageList = res;
      notifyListeners();
    } catch(e){
      print(e);
    }
  }

  void validateExpensesDetails() {
    if(formKey.currentState!.validate()) {
      addExpensesDetails();
    }else{
      autoValidation = true;
    }
    notifyListeners();
  }

  void onChangeOfDate(DateTime? dateTime) {
     // ctrl.text = DateFormats.getFilteredDate(dateTime.toString());
    notifyListeners();
  }

  void onChangeOfBillPaid(val) {
    if(expenditureDetails.billDateCtrl.text.trim().isNotEmpty || expenditureDetails.paidDateCtrl.text.trim().isNotEmpty) {
      expenditureDetails.isBillPaid = val;
    }else{
      autoValidation = true;
    }
    notifyListeners();
  }

 void onChangeOfExpenses(val){
    expenditureDetails.expenseType = val;
    notifyListeners();
 }


  List<DropdownMenuItem<Object>> getExpenseTypeList(){
    if(languageList?.mdmsRes?.expense?.expenseList != null){
     return (languageList?.mdmsRes?.expense?.expenseList ?? <ExpenseType>[]).map((value) {
       return DropdownMenuItem(
         value: value.code,
         child: new Text(value.name!),
       );
     }).toList();
    }
    return <DropdownMenuItem<Object>>[];
  }
}
