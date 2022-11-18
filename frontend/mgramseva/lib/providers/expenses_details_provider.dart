import 'dart:async';
import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:mgramseva/model/connection/tenant_boundary.dart';
import 'package:mgramseva/model/expensesDetails/expenses_details.dart';
import 'package:mgramseva/model/expensesDetails/vendor.dart';
import 'package:mgramseva/model/file/file_store.dart';
import 'package:mgramseva/model/localization/language.dart';
import 'package:mgramseva/model/mdms/expense_type.dart';
import 'package:mgramseva/model/success_handler.dart';
import 'package:mgramseva/repository/consumer_details_repo.dart';
import 'package:mgramseva/repository/core_repo.dart';
import 'package:mgramseva/repository/expenses_repo.dart';
import 'package:mgramseva/routers/Routers.dart';
import 'package:mgramseva/screeens/AddExpense/AddExpenseWalkThrough/expenseWalkThrough.dart';
import 'package:mgramseva/services/MDMS.dart';
import 'package:mgramseva/utils/Locilization/application_localizations.dart';
import 'package:mgramseva/utils/common_methods.dart';

import 'package:mgramseva/utils/constants.dart';
import 'package:mgramseva/utils/custom_exception.dart';
import 'package:mgramseva/utils/date_formats.dart';
import 'package:mgramseva/utils/error_logging.dart';
import 'package:mgramseva/utils/global_variables.dart';
import 'package:mgramseva/utils/loaders.dart';
import 'package:mgramseva/utils/models.dart';
import 'package:mgramseva/utils/notifyers.dart';
import 'package:mgramseva/widgets/CommonSuccessPage.dart';
import 'package:mgramseva/widgets/FilePicker.dart';
import 'package:provider/provider.dart';
import 'package:mgramseva/utils/Constants/I18KeyConstants.dart';
import 'package:url_launcher/url_launcher.dart';

import 'common_provider.dart';
import 'package:universal_html/html.dart' as html;

import 'language.dart';

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
  var phoneNumberAutoValidation = false;
  var dateAutoValidation = false;
  GlobalKey<FilePickerDemoState>? filePickerKey;


  dispose() {
    streamController.close();
    super.dispose();
  }

  Future<void> getExpensesDetails(BuildContext context,
      ExpensesDetailsModel? expensesDetails, String? id) async {
    try {
      if(expensesDetails != null || id != null) await fetchVendors();
      else fetchVendors();
      if (expensesDetails != null) {
        expenditureDetails = expensesDetails;
        getStoreFileDetails();
      } else if (id != null) {
        var commonProvider =
            Provider.of<CommonProvider>(context, listen: false);
        var query = {
          'tenantId': commonProvider.userDetails?.selectedtenant?.code,
          'challanNo': id
        };
        var expenditure = await ExpensesRepository().searchExpense(query);
        if (expenditure != null && expenditure.isNotEmpty) {
          expenditureDetails = expenditure.first;
          getStoreFileDetails();
        } else {
          streamController.add(i18.expense.NO_EXPENSE_RECORD_FOUND);
          return;
        }
      }

      this.expenditureDetails.getText();
      streamController.add(this.expenditureDetails);
    } on CustomException catch (e, s) {
      ErrorHandler.handleApiException(context, e, s);
      streamController.addError('error');
    } catch (e, s) {
      ErrorHandler.logError(e.toString(), s);
      streamController.addError('error');
    }
  }

  Future<void> getStoreFileDetails() async {
    if (expenditureDetails.fileStoreId == null) return;
    try {
      expenditureDetails.fileStoreList =
          await CoreRepository().fetchFiles([expenditureDetails.fileStoreId!]);
      notifyListeners();
    } catch (e, s) {
      ErrorHandler.logError(e.toString(), s);
    }
  }

  Future<void> addExpensesDetails(BuildContext context, bool isUpdate) async {
    late Map body;
    if (isNewVendor()) {
      if (!(await createVendor(context))) return;
    }

    setEnteredDetails(context, isUpdate);
    body = {'Challan': expenditureDetails.toJson()};

    try {
      Loaders.showLoadingDialog(context);

      var res = await ExpensesRepository().addExpenses(body, isUpdate);
      Navigator.pop(context);
      var challanDetails = res['challans']?[0];
      String localizationText =
          getLocalizedData(isUpdate, context, challanDetails);

      navigatorKey.currentState
          ?.push(MaterialPageRoute(builder: (BuildContext context) {
        return isUpdate
            ? CommonSuccess(
                SuccessHandler(
                    i18.expense.MODIFIED_EXPENDITURE_SUCCESSFULLY,
                    localizationText,
                    i18.common.BACK_HOME,
                    isUpdate ? Routes.EXPENSE_UPDATE : Routes.EXPENSES_ADD,
                    subtitleFun: () =>
                        getLocalizedData(isUpdate, context, challanDetails)),
                backButton: true,
              )
            : CommonSuccess(
                SuccessHandler(
                    i18.expense.CORE_EXPENSE_EXPENDITURE_SUCESS,
                    localizationText,
                    i18.expense.ADD_NEW_EXPENSE,
                    isUpdate ? Routes.EXPENSE_UPDATE : Routes.EXPENSES_ADD,
                    subHeader:
                        '${ApplicationLocalizations.of(context).translate(i18.demandGenerate.BILL_ID_NO)}',
                    subHeaderText: '${challanDetails['challanNo'] ?? ''}',
                    subtitleFun: () =>
                        getLocalizedData(isUpdate, context, challanDetails)),
                backButton: true,
                callBack: onClickOfBackButton,
              );
      }));
    } on CustomException catch (e, s) {
      Navigator.pop(context);

      if (ErrorHandler.handleApiException(context, e, s)) {
        Notifiers.getToastMessage(context, e.message, 'ERROR');
      }
    } catch (e, s) {
      Notifiers.getToastMessage(context, e.toString(), 'ERROR');
      ErrorHandler.logError(e.toString(), s);
      Navigator.pop(context);
    }
  }

  String getLocalizedData(
      bool isUpdate, BuildContext context, Map challanDetails) {
    late String localizationText;
    if (isUpdate) {
      localizationText =
          '${ApplicationLocalizations.of(context).translate(i18.expense.EXPENDITURE_BILL_ID)}';
      localizationText = localizationText.replaceFirst(
          '{Bill ID}', '${challanDetails['challanNo'] ?? ''}');
    } else {
      localizationText =
          '${ApplicationLocalizations.of(context).translate(i18.expense.EXPENDITURE_SUCESS)}';
      localizationText = localizationText.replaceFirst(
          '{Vendor}', expenditureDetails.vendorNameCtrl.text.trim());
      localizationText = localizationText.replaceFirst(
          '{Amount}', expenditureDetails.expensesAmount?.first.amount ?? '');
      localizationText = localizationText.replaceFirst('{type of expense}',
          '${ApplicationLocalizations.of(context).translate(expenditureDetails.expenseType ?? '')}');
    }
    return localizationText;
  }

  void onClickOfBackButton() {
    suggestionsBoxController = SuggestionsBoxController();
    expenditureDetails = ExpensesDetailsModel();
    getExpensesDetails(navigatorKey.currentContext!, null, null);
    autoValidation = false;
    phoneNumberAutoValidation = false;
    dateAutoValidation = false;
    if(filePickerKey != null){
      filePickerKey?.currentState?.reset();
    }
    notifyListeners();
    Navigator.pop(navigatorKey.currentContext!);
  }

  void setEnteredDetails(BuildContext context, bool isUpdate) {
    var commonProvider = Provider.of<CommonProvider>(context, listen: false);
    expenditureDetails
      ..businessService = commonProvider.getMdmsId(languageList,
          'EXPENSE.${expenditureDetails.expenseType}', MDMSType.BusinessService)
      ..expensesAmount?.first.taxHeadCode = languageList
          ?.mdmsRes?.expense?.expenseList
          ?.firstWhere((e) => e.code == expenditureDetails.expenseType)
          .taxHeadCode
      ..consumerType = 'EXPENSE'
      ..tenantId = commonProvider.userDetails?.selectedtenant?.code
      ..setText();

    if (expenditureDetails.selectedVendor == null &&
        expenditureDetails.vendorNameCtrl.text.trim().isNotEmpty) {
      var indexOf = vendorList.indexWhere((element) =>
          element.name == expenditureDetails.vendorNameCtrl.text.trim());
      if (indexOf != -1) {
        expenditureDetails.selectedVendor = vendorList[indexOf];
      }
    }

    expenditureDetails
      ..vendorId = expenditureDetails.selectedVendor?.id ??
          expenditureDetails.vendorNameCtrl.text
      ..vendorName = expenditureDetails.selectedVendor?.name ??
          expenditureDetails.vendorNameCtrl.text.trim();

    if (isUpdate) {
      if (expenditureDetails.isBillPaid!) {
        expenditureDetails.applicationStatus = 'PAID';
      }
      expenditureDetails.citizen?.mobileNumber =
          expenditureDetails.citizen?.userName;
      if (expenditureDetails.isBillCancelled!) {
        expenditureDetails.applicationStatus = 'CANCELLED';
      }
    }
  }

  void fileStoreIdCallBack(List<FileStore>? fileStoreIds) {
    if (fileStoreIds != null && fileStoreIds.isNotEmpty) {
      expenditureDetails.fileStoreId = fileStoreIds.first.fileStoreId;
    } else {
      expenditureDetails.fileStoreId = null;
      expenditureDetails.fileStoreList = null;
    }
    notifyListeners();
  }

  Future<bool> createVendor(BuildContext context) async {
    bool status = false;
    var commonProvider = Provider.of<CommonProvider>(context, listen: false);
    var languageProvider = Provider.of<LanguageProvider>(context, listen: false);
    try {
      Loaders.showLoadingDialog(context);
      var boundaryList = [];
      String? code;
      var result = await ConsumerRepository().getLocations({
        "hierarchyTypeCode": "REVENUE",
        "boundaryType": "Locality",
        "tenantId": commonProvider.userDetails!.selectedtenant!.code
      });
      if (result['TenantBoundary'] != null &&
          result['TenantBoundary'].length > 0) {
        boundaryList.addAll(
            TenantBoundary.fromJson(result['TenantBoundary'][0]).boundary!);
      }
      if (boundaryList.length > 0) {
        code = boundaryList.first.code;
      } else {
        code = commonProvider.userDetails?.selectedtenant?.city?.code;
      }

      var body = {
        "vendor": {
          "tenantId": commonProvider.userDetails?.selectedtenant?.code,
          "name": expenditureDetails.vendorNameCtrl.text.trim(),
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
            "buildingName": null,
            "street": null,
            "locality": {
              "code": code,
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
            "tenantId": commonProvider.userDetails?.selectedtenant?.code,
            "name": expenditureDetails.vendorNameCtrl.text.trim(),
            "fatherOrHusbandName": languageProvider.selectedLanguage!.enableRegEx
                ? ApplicationLocalizations.of(context)
                .translate(i18.expense.DEFAULT_NAME)
                : "defaultName",
            "relationship": "FATHER",
            "gender": "MALE",
            "dob": 550261800000,
            "emailId": "example@gmail.com",
            "mobileNumber": expenditureDetails.mobileNumberController.text.trim()
          },
          "vehicles": [],
          "drivers": [],
          "source": "WhatsApp"
        }
      };

      var res = await ExpensesRepository().createVendor(body);
      if (res != null) {
        expenditureDetails.selectedVendor = Vendor(res['name'], res['id']);
        status = true;
      }
    } on CustomException catch (e, s) {
      Notifiers.getToastMessage(context, e.message, 'ERROR');
    } catch (e) {
      Notifiers.getToastMessage(context, e.toString(), 'ERROR');
    }
    Navigator.pop(context);
    return status;
  }

  Future<void> searchExpense(Map<String, dynamic> query,
      String Function() criteria, BuildContext context) async {
    try {
      Loaders.showLoadingDialog(context);

      var res = await ExpensesRepository().searchExpense(query);
      Navigator.pop(context);
      if (res != null && res.isNotEmpty) {
        Navigator.pushNamed(context, Routes.EXPENSE_RESULT,
            arguments: SearchResult(criteria, res));
      } else {
        Notifiers.getToastMessage(
            context, i18.expense.NO_EXPENSES_FOUND, 'ERROR');
      }
    } on CustomException catch (e, s) {
      Notifiers.getToastMessage(context, e.message, 'ERROR');
      Navigator.pop(context);
    } catch (e) {
      Notifiers.getToastMessage(context, e.toString(), 'ERROR');
      Navigator.pop(context);
    }
  }

  Future<List<dynamic>> onSearchVendorList(pattern) async {
    await Future.delayed(Duration(milliseconds: 100));
    notifyListeners();

    if (pattern.toString().trim().isEmpty) return <Vendor>[];

    return vendorList.where((vendor) {
      if (vendor.name.trim()
          .toLowerCase()
          .contains(pattern.toString().trim().toLowerCase())) {
        return true;
      } else {
        // if(!(expenditureDetails.selectedVendor != null && expenditureDetails.vendorId == expenditureDetails.selectedVendor?.id
        //     && expenditureDetails.selectedVendor?.name == pattern.toString().trim()))
        expenditureDetails
          ..selectedVendor = null
          ..mobileNumberController.clear();
        return false;
      }
    }).toList();
  }

  bool isNewVendor() {
    var vendorName = expenditureDetails.vendorNameCtrl.text.trim();
    if (vendorName.isEmpty) {
      return true;
    } else if(expenditureDetails.selectedVendor?.id != null){
      if(expenditureDetails.selectedVendor != null && (expenditureDetails.selectedVendor?.owner?.mobileNumber == null || expenditureDetails.selectedVendor!.owner!.mobileNumber.isEmpty)){
        var mobileNumber = vendorList.firstWhere((vendor) => vendor.id == expenditureDetails.vendorId, orElse: () => Vendor('', '')).owner?.mobileNumber ?? '';
        expenditureDetails.selectedVendor?.owner = Owner(mobileNumber);
        expenditureDetails.mobileNumberController.text = mobileNumber;
      }
      return false;
    }
    else {
      return true;
    }
  }

  Future<List<Vendor>> fetchVendors() async {
    var commonProvider = Provider.of<CommonProvider>(
        navigatorKey.currentContext!,
        listen: false);

    try {
      var query = {
        'tenantId': commonProvider.userDetails?.selectedtenant?.code,
        'limit' : '-1'
      };

      var res = await ExpensesRepository().getVendor(query);
      if (res != null) {
        vendorList = res;
        notifyListeners();
      }
      return vendorList;
    } catch (e, s) {
      ErrorHandler.logError(e.toString(), s);
      return <Vendor>[];
    }
  }

  void onSuggestionSelected(vendor) {
    expenditureDetails
      ..selectedVendor = vendor
      ..vendorNameCtrl.text = vendor?.name ?? ''
      ..mobileNumberController.text = vendor?.owner?.mobileNumber ?? '';
    notifyListeners();
  }

  Future<void> getExpenses() async {
    try {
      var commonProvider = Provider.of<CommonProvider>(
          navigatorKey.currentContext!,
          listen: false);
      var res = await CoreRepository().getMdms(getExpenseMDMS(
          commonProvider.userDetails!.userRequest!.tenantId.toString()));
      languageList = res;
      notifyListeners();
    } catch (e, s) {
      ErrorHandler.logError(e.toString(), s);
    }
  }

  void validateExpensesDetails(BuildContext context, [isUpdate = false]) {
    FocusScope.of(context).unfocus();
    if (formKey.currentState!.validate()) {
      addExpensesDetails(context, isUpdate);
    } else {
      autoValidation = true;
    }
    notifyListeners();
  }

  void onChangeOfDate(DateTime? dateTime) {
    notifyListeners();
  }

  void onChangeOfStartEndDate(DateTime? dateTime){
    dateAutoValidation = true;
    notifyListeners();
  }

  void onChangeOfBillDate(DateTime? dateTime){
    if(dateTime == null) return;

    if(expenditureDetails.fromDateCtrl.text.trim().isEmpty && expenditureDetails.toDateCtrl.text.trim().isEmpty) {
      expenditureDetails.fromDateCtrl.text =
          DateFormats.timeStampToDate(dateTime.millisecondsSinceEpoch);
      expenditureDetails.toDateCtrl.text =
          DateFormats.timeStampToDate(dateTime.millisecondsSinceEpoch);
    }
    notifyListeners();
  }

  String? fromToDateValidator(DateTime? dateTime, [bool isFromDate = false]){
    var fromDate = DateFormats.getFormattedDateToDateTime(expenditureDetails.fromDateCtrl.text.trim());
    var toDate = DateFormats.getFormattedDateToDateTime(expenditureDetails.toDateCtrl.text.trim());
    var billDate = DateFormats.getFormattedDateToDateTime(expenditureDetails.billDateCtrl.text.trim());

    if(isFromDate){
      if(fromDate == null) return '${ApplicationLocalizations.of(navigatorKey.currentContext!).translate(i18.expense.EXPENSE_START_DATE_MANDATORY)}';
      else if(billDate != null && fromDate.isAfter(billDate)) return  '${ApplicationLocalizations.of(navigatorKey.currentContext!).translate(i18.expense.FROM_DATE_CANNOT_BE_AFTER_BILL_DATE)}';
    }else{
      if(toDate == null){
        return '${ApplicationLocalizations.of(navigatorKey.currentContext!).translate(i18.expense.EXPENSE_END_DATE_MANDATORY)}';
      }else if(billDate != null && toDate.isAfter(billDate)) return '${ApplicationLocalizations.of(navigatorKey.currentContext!).translate(i18.expense.TO_DATE_CANNOT_BE_AFTER_BILL_DATE)}';
      else if(fromDate != null && fromDate.isAfter(toDate)){
        return '${ApplicationLocalizations.of(navigatorKey.currentContext!).translate(i18.expense.EXPENSE_END_START_DATE_VALIDATION)}';
      }
    }
    return null;
  }

  void onTapOfAttachment(FileStore store, BuildContext context) async {
    if (store.url == null) return;
    var random = new Random();
    var fileName = CommonMethods.getExtension(store.url!);
    CoreRepository().fileDownload(context, store.url!, '${random.nextInt(200)}${random.nextInt(100)}$fileName');
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
          child: new Text((value.code!)),
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

  onChangeOfMobileNumber(val) {
    var mobileNumber = expenditureDetails.mobileNumberController.text.trim();
    if (mobileNumber.length < 10 || vendorList.isEmpty) return;
    var index = vendorList
        .indexWhere((e) => e.owner?.mobileNumber.trim() == mobileNumber);

    if (index != -1) {
      expenditureDetails.vendorNameCtrl.text = vendorList[index].name.trim();
      expenditureDetails.selectedVendor =
          Vendor(vendorList[index].name.trim(), vendorList[index].id);
      expenditureDetails.selectedVendor?.owner ??= Owner(mobileNumber);
    }
  }

  callNotifyer() {
    notifyListeners();
  }
}
