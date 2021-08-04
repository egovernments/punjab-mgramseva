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
import 'package:mgramseva/utils/Locilization/application_localizations.dart';

import 'package:mgramseva/utils/constants.dart';
import 'package:mgramseva/utils/custom_exception.dart';
import 'package:mgramseva/utils/global_variables.dart';
import 'package:mgramseva/utils/loaders.dart';
import 'package:mgramseva/utils/models.dart';
import 'package:mgramseva/utils/notifyers.dart';
import 'package:provider/provider.dart';
import 'package:mgramseva/utils/Constants/I18KeyConstants.dart';

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

  Future<void> addExpensesDetails(BuildContext context) async {
    var commonProvider = Provider.of<CommonProvider>(context, listen: false);
    expenditureDetails
      ..businessService = commonProvider.getMdmsId(languageList,
          'EXPENSE.${expenditureDetails.expenseType}', MDMSType.BusinessService)
      ..expensesAmount.first.taxHeadCode = commonProvider.getMdmsId(
          languageList,
          'EXPENSE.${expenditureDetails.expenseType}',
          MDMSType.TaxHeadCode)
      ..consumerType = 'EXPENSE'
      ..tenantId = 'pb'
      ..setText()
      ..vendorName = expenditureDetails.selectedVendor?.id ??
          expenditureDetails.vendorNameCtrl.text;

    try {
      Loaders.showLoadingDialog(context);

      var res = await ExpensesRepository()
          .addExpenses({'Challan': expenditureDetails.toJson()});
      Navigator.pop(context);
      var challanDetails = res['challans']?[0];
      navigatorKey.currentState?.pushNamed(Routes.SUCCESS_VIEW,
          arguments: SuccessHandler(
              '${ApplicationLocalizations.of(context).translate(i18.expense.EXPENDITURE_SUCESS)}',
              '${ApplicationLocalizations.of(context).translate(i18.expense.EXPENDITURE_AGAINST)} ${challanDetails['challanNo']} ${ApplicationLocalizations.of(context).translate(i18.expense.UNDER_MAINTAINANCE)} Rs. ${challanDetails['amount'][0]['amount']} ',
              i18.common.BACK_HOME));
    } on CustomException catch (e) {
      Navigator.pop(context);
      Notifiers.getToastMessage(
          '${ApplicationLocalizations.of(context).translate(i18.expense.UNABLE_TO_CREATE_EXPENSE)}',
          'ERROR');
    } catch (e) {
      Notifiers.getToastMessage(
          '${ApplicationLocalizations.of(context).translate(i18.expense.UNABLE_TO_CREATE_EXPENSE)}',
          'ERROR');
      Navigator.pop(context);
    }
  }

  Future<void> searchExpense(Map query, BuildContext context) async {
    Future.delayed(Duration(seconds: 5));
    try{
      Loaders.showLoadingDialog(context);

      var res = await ExpensesRepository()
          .searchExpense({});
      if(res != null && res.isNotEmpty){
       Navigator.pushNamed(context, Routes.EXPENSE_SEARCH, arguments: res);
      }else{

      }
    }catch(e) {
      Navigator.pop(context);
    }

  }

  Future<List<dynamic>> onSearchVendorList(pattern) async {
    if (vendorList.isEmpty) {
      await fetchVendors();
    }

    if (pattern.toString().trim().isEmpty) return <Vendor>[];

    return vendorList
        .where((vendor) => vendor.name
            .toLowerCase()
            .contains(pattern.toString().toLowerCase()))
        .toList();
  }

  Future<List<Vendor>> fetchVendors() async {
    try {
      var query = {
        'tenantId': 'pb',
        'offset': vendorList.length.toString(),
      };

      var res = await ExpensesRepository().getVendor(query);
      if (res != null) {
        vendorList.addAll(res);
        notifyListeners();
      }
      return vendorList;
    } catch (e) {
      return <Vendor>[];
    }
  }

  void onSuggestionSelected(vendor) {
    expenditureDetails
      ..selectedVendor = vendor
      ..vendorNameCtrl.text = vendor?.name ?? '';
  }

  Future<void> getExpenses() async {
    try {
      var res = await CoreRepository().getMdms(getExpenseMDMS('pb'));
      languageList = res;
      notifyListeners();
    } catch (e) {
      print(e);
    }
  }

  void validateExpensesDetails(BuildContext context) {
    if (formKey.currentState!.validate()) {
      addExpensesDetails(context);
    } else {
      autoValidation = true;
    }
    notifyListeners();
  }

  void onChangeOfDate(DateTime? dateTime) {
    // ctrl.text = DateFormats.getFilteredDate(dateTime.toString());
    notifyListeners();
  }

  void onChangeOfBillPaid(val) {
    if (expenditureDetails.billDateCtrl.text.trim().isNotEmpty ||
        expenditureDetails.paidDateCtrl.text.trim().isNotEmpty) {
      expenditureDetails.isBillPaid = val;
    } else {
      autoValidation = true;
    }
    notifyListeners();
  }

  void onChangeOfExpenses(val) {
    expenditureDetails.expenseType = val;
    notifyListeners();
  }

  List<DropdownMenuItem<Object>> getExpenseTypeList() {
    if (languageList?.mdmsRes?.expense?.expenseList != null) {
      return (languageList?.mdmsRes?.expense?.expenseList ?? <ExpenseType>[])
          .map((value) {
        return DropdownMenuItem(
          value: value.code,
          child: new Text(value.name!),
        );
      }).toList();
    }
    return <DropdownMenuItem<Object>>[];
  }
}
