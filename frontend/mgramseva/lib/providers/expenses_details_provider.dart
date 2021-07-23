import 'dart:async';

import 'package:flutter/material.dart';
import 'package:mgramseva/model/expensesDetails/expenses_details.dart';

class ExpensesDetailsProvider with ChangeNotifier {
  var streamController = StreamController.broadcast();

  dispose() {
    streamController.close();
    super.dispose();
  }

  Future<void> getExpensesDetails() async {
    try {
      streamController.add(ExpensesDetailsModel());
    } catch (e) {
      streamController.addError('error');
    }
  }
}
