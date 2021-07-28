import 'dart:async';

import 'package:flutter/material.dart';
import 'package:mgramseva/model/expensesDetails/expenses_details.dart';
import 'package:mgramseva/repository/expenses_repo.dart';
import 'package:mgramseva/utils/custom_exception.dart';
import 'package:mgramseva/utils/global_variables.dart';
import 'package:provider/provider.dart';

class ExpensesDetailsProvider with ChangeNotifier {
  var streamController = StreamController.broadcast();
  var expenditureDetails = ExpensesDetailsModel();
  late GlobalKey<FormState> formKey;
  var autoValidation = false;

  dispose() {
    streamController.close();
    super.dispose();
  }

  void validateExpensesDetails() {
    if(formKey.currentState!.validate()) {
      addExpensesDetails();
    }else{
     autoValidation = true;
    }
  }

  Future<void> getExpensesDetails() async {
    try {
      streamController.add(expenditureDetails);
    } catch (e) {
      streamController.addError('error');
    }
  }

  Future<void> addExpensesDetails() async {

    try {
     var res = ExpensesRepository().addExpenses({});

    }catch(e){

    }
  }
}
