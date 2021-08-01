import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:mgramseva/model/expensesDetails/expenses_details.dart';
import 'package:mgramseva/model/expensesDetails/vendor.dart';
import 'package:mgramseva/model/localization/language.dart';
import 'package:mgramseva/model/mdms/expense_type.dart';
import 'package:mgramseva/repository/core_repo.dart';
import 'package:mgramseva/repository/expenses_repo.dart';
import 'package:mgramseva/routers/Routers.dart';
import 'package:mgramseva/services/MDMS.dart';
import 'package:mgramseva/services/RequestInfo.dart';
import 'package:mgramseva/utils/constants.dart';
import 'package:mgramseva/utils/custom_exception.dart';
import 'package:mgramseva/utils/date_formats.dart';
import 'package:mgramseva/utils/global_variables.dart';
import 'package:mgramseva/utils/loaders.dart';
import 'package:mgramseva/utils/models.dart';
import 'package:mgramseva/utils/notifyers.dart';
import 'package:provider/provider.dart';

import 'common_provider.dart';

class ExpensesDetailsProvider with ChangeNotifier {
  var streamController = StreamController.broadcast();
  var expenditureDetails = ExpensesDetailsModel();
  late GlobalKey<FormState> formKey;
  var autoValidation = false;
  LanguageList? languageList;
  var vendorList = <Vendor>[];
  late SuggestionsBoxController suggestionsBoxController;


  dispose() {
    streamController.close();
    super.dispose();
  }

  Future<void> getExpensesDetails() async {
    try {
      expenditureDetails.getText();
      streamController.add(expenditureDetails);
    } catch (e) {
      streamController.addError('error');
    }
  }

  Future<void> addExpensesDetails() async {
    var commonProvider = Provider.of<CommonProvider>(navigatorKey.currentContext!, listen: false);
    expenditureDetails
    ..businessService = commonProvider.getMdmsId(languageList, 'EXPENSE.${expenditureDetails.expenseType}', MDMSType.BusinessService)
    ..expensesAmount?.first.taxHeadCode = commonProvider.getMdmsId(languageList, 'EXPENSE.${expenditureDetails.expenseType}', MDMSType.TaxHeadCode)
    ..consumerType = 'EXPENSE'
    ..tenantId = 'pb';


    expenditureDetails.setText();
    expenditureDetails.vendorName = '1ba69f7d-103e-4680-bfb0-bb86975e16e7';

    try {
      Loaders.showLoadingDialog(navigatorKey.currentContext!, label : 'Creating the Expense');

      var res = await ExpensesRepository().addExpenses({'Challan' : expenditureDetails.toJson()});
      navigatorKey.currentState?.pop();
      navigatorKey.currentState?.pushNamed(Routes.SUCCESS_VIEW);
      return;
    }on CustomException catch(e){
      Notifiers.getToastMessage('Unable to create the expense');
    } catch(e){
      Notifiers.getToastMessage('Unable to create the expense');
    }
    navigatorKey.currentState?.pop();
  }

  Future<List<dynamic>> onSearchVendorList(pattern) async{

    if(vendorList.isEmpty){
      await fetchVendors();
    }

    if(pattern.toString().trim().isEmpty) return <Vendor>[];

    return vendorList.where((vendor) => vendor.name.contains(pattern)).toList();
  }


  Future<List<Vendor>> fetchVendors() async {

    // await Future.delayed(Duration(seconds: 5));
    // return vendorList = [
    //   Vendor('srinu', 's'),
    //   Vendor('ramesh', 's'),
    //   Vendor('vishu', 's'),
    //   Vendor('gani', 's'),
    //   Vendor('madhav', 's'),
    //   Vendor('Sudheer', 's'),
    // ];

    try{
      var query = {
        'tenantId' : 'pb',
        'offset' : vendorList.length.toString(),
        'limit' : (vendorList.length + Constants.PAGINATION_LIMIT).toString()
      };

      var res = await ExpensesRepository().getVendor(query);
      if(res != null){
        vendorList.addAll(res);
        notifyListeners();
      }
      return vendorList;
    }catch(e){
      return <Vendor>[];
    }
  }

  void onSuggestionSelected(vendor){
    expenditureDetails.vendorNameCtrl.text = vendor?.name ?? '';
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
