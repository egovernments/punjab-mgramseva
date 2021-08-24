import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:mgramseva/model/expensesDetails/expenses_details.dart';
import 'package:mgramseva/model/expensesDetails/vendor.dart';
import 'package:mgramseva/model/file/file_store.dart';
import 'package:mgramseva/model/localization/language.dart';
import 'package:mgramseva/model/mdms/expense_type.dart';
import 'package:mgramseva/model/success_handler.dart';
import 'package:mgramseva/repository/core_repo.dart';
import 'package:mgramseva/repository/expenses_repo.dart';
import 'package:mgramseva/routers/Routers.dart';
import 'package:mgramseva/screeens/AddExpense/AddExpenseWalkThrough/expenseWalkThrough.dart';
import 'package:mgramseva/services/MDMS.dart';
import 'package:mgramseva/utils/Locilization/application_localizations.dart';

import 'package:mgramseva/utils/constants.dart';
import 'package:mgramseva/utils/custom_exception.dart';
import 'package:mgramseva/utils/error_logging.dart';
import 'package:mgramseva/utils/global_variables.dart';
import 'package:mgramseva/utils/loaders.dart';
import 'package:mgramseva/utils/models.dart';
import 'package:mgramseva/utils/notifyers.dart';
import 'package:provider/provider.dart';
import 'package:mgramseva/utils/Constants/I18KeyConstants.dart';
import 'package:url_launcher/url_launcher.dart';

import 'common_provider.dart';
import 'package:universal_html/html.dart' as html;

class ExpensesDetailsProvider with ChangeNotifier {
  late List<ExpenseWalkWidgets> expenseWalkthrougList;
  var streamController = StreamController.broadcast();
  var expenditureDetails = ExpensesDetailsModel();
  late GlobalKey<FormState> formKey;
  var autoValidation = false;
  int activeindex = 0;
  LanguageList? languageList;
  var vendorList = <Vendor>[];
  late SuggestionsBoxController suggestionsBoxController;

  dispose() {
    streamController.close();
    super.dispose();
  }

  Future<void> getExpensesDetails(BuildContext context, ExpensesDetailsModel? expensesDetails, String? id) async {
    try {

      if(expensesDetails != null){
        expenditureDetails = expensesDetails;
        getStoreFileDetails();
      }else if(id != null){
        var expenditure = await ExpensesRepository().searchExpense({'challanNo' : id});
        if(expenditure != null && expenditure.isNotEmpty){
          expenditureDetails = expenditure!.first;
          getStoreFileDetails();
        }else{
          streamController.add(i18.expense.NO_EXPENSE_RECORD_FOUND);
          return;
        }
      }

      this.expenditureDetails.getText();
      streamController.add(this.expenditureDetails);
    } on CustomException catch (e,s){
      ErrorHandler.handleApiException(context, e,s);
      streamController.addError('error');
    } catch (e, s) {
      ErrorHandler.logError(e.toString(),s);
      streamController.addError('error');
    }
  }

  void getStoreFileDetails() async {
    if(expenditureDetails.fileStoreId == null) return;
    try{
      expenditureDetails.fileStoreList = await CoreRepository().fetchFiles([expenditureDetails.fileStoreId!]);
    }catch(e,s){
      ErrorHandler.logError(e.toString(),s);
    }
  }

  Future<void> addExpensesDetails(BuildContext context, bool isUpdate) async {
    late Map body;
    if(isNewVendor()){
      if(!(await createVendor(context))) return;
    }

    setEnteredDetails(context, isUpdate);
    body = {'Challan': expenditureDetails.toJson()};

    try {

      Loaders.showLoadingDialog(context);

      var res = await ExpensesRepository()
          .addExpenses(body, isUpdate);
      Navigator.pop(context);
      var challanDetails = res['challans']?[0];
      navigatorKey.currentState?.pushNamed(Routes.SUCCESS_VIEW,
          arguments: isUpdate ?
          SuccessHandler(
              i18.expense.MODIFIED_EXPENDITURE_SUCCESSFULLY,
              '${ApplicationLocalizations.of(context).translate(i18.expense.EXPENDITURE_BILL_ID)} ${challanDetails['challanNo']} ${ApplicationLocalizations.of(context).translate(i18.expense.HAS_BEEN_MODIFIED)} ',
              i18.common.BACK_HOME, isUpdate ? Routes.EXPENSE_UPDATE : Routes.EXPENSES_ADD)
              : SuccessHandler(
              i18.expense.EXPENDITURE_SUCESS,
              '${ApplicationLocalizations.of(context).translate(i18.expense.EXPENDITURE_AGAINST)} ${challanDetails['challanNo']} ${ApplicationLocalizations.of(context).translate(i18.expense.UNDER_MAINTAINANCE)} Rs. ${challanDetails['amount'][0]['amount']} ',
              i18.common.BACK_HOME, isUpdate ? Routes.EXPENSE_UPDATE : Routes.EXPENSES_ADD));
    } on CustomException catch (e,s) {
      Navigator.pop(context);

      if(ErrorHandler.handleApiException(context, e,s)) {
        Notifiers.getToastMessage(
            context,
           e.message,
            'ERROR');
      }
    } catch (e, s) {
      Notifiers.getToastMessage(
          context,
          e.toString(),
          'ERROR');
      ErrorHandler.logError(e.toString(),s);
      Navigator.pop(context);
    }
  }

  void setEnteredDetails(BuildContext context, bool isUpdate){
    var commonProvider = Provider.of<CommonProvider>(context, listen: false);
    expenditureDetails
      ..businessService = commonProvider.getMdmsId(languageList,
          'EXPENSE.${expenditureDetails.expenseType}', MDMSType.BusinessService)
      ..expensesAmount?.first.taxHeadCode = commonProvider.getMdmsId(
          languageList,
          'EXPENSE.${expenditureDetails.expenseType}',
          MDMSType.TaxHeadCode)
      ..consumerType = 'EXPENSE'
      ..tenantId = 'pb'
      ..setText()
      ..vendorId = expenditureDetails.selectedVendor?.id ??
          expenditureDetails.vendorNameCtrl.text
      ..vendorName = expenditureDetails.selectedVendor?.name ??
          expenditureDetails.vendorNameCtrl.text;

    if(isUpdate) {
      if (expenditureDetails.isBillPaid!) {
        expenditureDetails.applicationStatus = 'PAID';
      }
      expenditureDetails.citizen?.mobileNumber = expenditureDetails.citizen?.userName;
      if (expenditureDetails.isBillCancelled!){
        expenditureDetails.applicationStatus = 'CANCELLED';
      }
    }
  }

  void fileStoreIdCallBack(List<FileStore>? fileStoreIds) {
    if(fileStoreIds != null && fileStoreIds.isNotEmpty){
      expenditureDetails.fileStoreId = fileStoreIds.first.fileStoreId;

    }else{
      expenditureDetails.fileStoreId = null;
      expenditureDetails.fileStoreList = null;
    }
    notifyListeners();
  }


  Future<bool> createVendor(BuildContext context) async {
    bool status = false;
    var commonProvider = Provider.of<CommonProvider>(context, listen: false);

    var body = {
     "vendor": {
       "tenantId": commonProvider.userDetails?.selectedtenant?.code,
       "name": expenditureDetails.vendorNameCtrl.text,
       "address": {
         "tenantId": commonProvider.userDetails?.selectedtenant?.code,
         "doorNo": null,
         "plotNo": null,
         "landmark": null,
         "city": null,
         "district": null,
         "region": null,
         "state": "punjab",
         "country": "in",
         "pincode": null,
         "additionDetails": null,
         "buildingName":null,
         "street": null,
         "locality": {
           "code": commonProvider.userDetails?.selectedtenant?.city?.code,
           "name": null,
           "label": null,
           "latitude": null,
           "longitude": null,
           "area": "null",
           "pincode": null,
           "boundaryNum": 1,
           "children": []
         },
         "geoLocation": {
           "latitude": 0,
           "longitude": 0,
           "additionalDetails": {}
         }
       },
       "owner": {
         "tenantId": "pb.lodhipur",
         "name": expenditureDetails.vendorNameCtrl.text,
         "fatherOrHusbandName": "defaultName",
         "relationship": "FATHER",
         "gender": "MALE",
         "dob": 550261800000,
         "emailId": "example@gmail.com",
         "mobileNumber": expenditureDetails.mobileNumberController.text
       },
       "vehicles": [],
       "drivers": [],
       "source": "WhatsApp"
     }
   };

   try {
     Loaders.showLoadingDialog(context);

     var res = await ExpensesRepository()
         .createVendor(body);
     if(res != null){
       expenditureDetails.selectedVendor = Vendor(res['name'], res['id']);
       status = true;
     }
   } on CustomException catch(e,s){
     Notifiers.getToastMessage(context,
         e.message, 'ERROR');
   }catch(e) {
     Notifiers.getToastMessage(context,
         e.toString(), 'ERROR');
   }
   Navigator.pop(context);
   return status;
  }

  Future<void> searchExpense(Map<String, dynamic> query, String criteria, BuildContext context) async {

    try {
      Loaders.showLoadingDialog(context);

      var res = await ExpensesRepository()
          .searchExpense(query);
      Navigator.pop(context);
      if (res != null && res.isNotEmpty) {
        Navigator.pushNamed(context, Routes.EXPENSE_RESULT,
            arguments: SearchResult(criteria, res));
      } else {
        Notifiers.getToastMessage(context,
            i18.expense.NO_EXPENSES_FOUND, 'ERROR');
      }
    } on CustomException catch(e,s){
      Notifiers.getToastMessage(context,
              e.message, 'ERROR');
      Navigator.pop(context);
    }catch(e) {
      Notifiers.getToastMessage(context,
              e.toString(), 'ERROR');
      Navigator.pop(context);
    }

  }

  Future<List<dynamic>> onSearchVendorList(pattern) async {
    notifyListeners();
    if (vendorList.isEmpty) {
      await fetchVendors();
    }

    if (pattern.toString().trim().isEmpty) return <Vendor>[];

    return vendorList
        .where((vendor) {
          if(vendor.name
          .toLowerCase()
          .contains(pattern.toString().toLowerCase())){
            return true;
          }else{
            return false;
          }
    })
        .toList();
  }

  bool isNewVendor(){
    var vendorName = expenditureDetails.vendorNameCtrl.text.trim();
    if(vendorName.isEmpty) {
      return false;
    }else if(vendorList.isEmpty || (vendorList.indexWhere((e) => e.name.toLowerCase().trim() == vendorName.toLowerCase())) == -1){
      return true;
    }else{
      return false;
    }
  }

  Future<List<Vendor>> fetchVendors() async {
    var commonProvider = Provider.of<CommonProvider>(navigatorKey.currentContext!, listen: false);

    try {
      var query = {
        'tenantId': commonProvider.userDetails?.selectedtenant?.code,
      };

      var res = await ExpensesRepository().getVendor(query);
      if (res != null) {
        vendorList = res;
        notifyListeners();
      }
      return vendorList;
    } catch (e,s) {
      ErrorHandler.logError(e.toString(),s);
      return <Vendor>[];
    }
  }

  void onSuggestionSelected(vendor) {
    expenditureDetails
      ..selectedVendor = vendor
      ..vendorNameCtrl.text = vendor?.name ?? '';
    notifyListeners();
  }

  Future<void> getExpenses() async {
    try {
      var res = await CoreRepository().getMdms(getExpenseMDMS('pb'));
      languageList = res;
      notifyListeners();
    } catch (e,s) {
      ErrorHandler.logError(e.toString(),s);
    }
  }

  void validateExpensesDetails(BuildContext context, [isUpdate = false]) {
    if (formKey.currentState!.validate()) {
      addExpensesDetails(context, isUpdate);
    } else {
      autoValidation = true;
    }
    notifyListeners();
  }

  void onChangeOfDate(DateTime? dateTime) {
    // ctrl.text = DateFormats.getFilteredDate(dateTime.toString());
    notifyListeners();
  }

  void onTapOfAttachment(FileStore store) async {
      if(store.url == null) return;

      if(kIsWeb) {
        html.AnchorElement anchorElement = new html.AnchorElement(
            href: store.url);
        anchorElement.download = store.url;
        anchorElement.click();
      }else{
        await canLaunch(store.url!) ?  launch(store.url!) : ErrorHandler.logError('failed to launch the url ${store.url}');
      }
  }
  void setwalkthrough(value) {
    expenseWalkthrougList = value;
  }

  void onChangeOfCheckBox(bool? value) {
    expenditureDetails.isBillCancelled = value;
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

  incrementindex(index, expenseKey) async {
    activeindex = index + 1;
    await Scrollable.ensureVisible(expenseKey.currentContext!,
        duration: new Duration(milliseconds: 100));
  }
}
