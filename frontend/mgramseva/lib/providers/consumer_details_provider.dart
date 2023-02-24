import 'dart:async';

import 'package:flutter/material.dart';
import 'package:mgramseva/model/common/demand.dart';
import 'package:mgramseva/model/connection/property.dart';
import 'package:mgramseva/model/connection/tenant_boundary.dart';
import 'package:mgramseva/model/connection/water_connection.dart' as addition;
import 'package:mgramseva/model/connection/water_connection.dart';
import 'package:mgramseva/model/connection/water_connections.dart';
import 'package:mgramseva/model/localization/language.dart';
import 'package:mgramseva/model/mdms/category_type.dart';
import 'package:mgramseva/model/mdms/connection_type.dart';
import 'package:mgramseva/model/mdms/payment_type.dart';
import 'package:mgramseva/model/mdms/property_type.dart';
import 'package:mgramseva/model/mdms/sub_category_type.dart';
import 'package:mgramseva/model/mdms/tax_period.dart';
import 'package:mgramseva/providers/common_provider.dart';
import 'package:mgramseva/repository/billing_service_repo.dart';
import 'package:mgramseva/repository/consumer_details_repo.dart';
import 'package:mgramseva/repository/core_repo.dart';
import 'package:mgramseva/repository/search_connection_repo.dart';
import 'package:mgramseva/screeens/ConsumerDetails/ConsumerDetailsWalkThrough/walkthrough.dart';
import 'package:mgramseva/services/MDMS.dart';
import 'package:mgramseva/utils/Constants/I18KeyConstants.dart';
import 'package:mgramseva/utils/Locilization/application_localizations.dart';
import 'package:mgramseva/utils/common_methods.dart';
import 'package:mgramseva/utils/constants.dart';
import 'package:mgramseva/utils/date_formats.dart';
import 'package:mgramseva/utils/error_logging.dart';
import 'package:mgramseva/utils/global_variables.dart';
import 'package:mgramseva/utils/loaders.dart';
import 'package:mgramseva/utils/models.dart';
import 'package:mgramseva/utils/notifyers.dart';
import 'package:mgramseva/widgets/SearchSelectFieldBuilder.dart';
import 'package:mgramseva/widgets/dialog.dart';
import 'package:provider/provider.dart';

class ConsumerProvider with ChangeNotifier {
  late List<ConsumerWalkWidgets> consmerWalkthrougList;
  var streamController = StreamController.broadcast();
  late GlobalKey<FormState> formKey;
  var isfirstdemand = false;
  var autoValidation = false;
  int activeindex = 0;
  late WaterConnection waterconnection;
  var boundaryList = <Boundary>[];
  var categoryList = [];
  var selectedcycle;
  TaxPeriod? billYear;
  var selectedbill;
  late Property property;
  late List dates = [];
  late bool isEdit = false;
  LanguageList? languageList;
  PaymentType? paymentType;
  bool phoneNumberAutoValidation = false;
  GlobalKey<SearchSelectFieldState>? searchPickerKey;

  setModel() async {
    waterconnection.BillingCycleCtrl.text = "";
    var commonProvider = Provider.of<CommonProvider>(
        navigatorKey.currentContext!,
        listen: false);
    isEdit = false;
    waterconnection = WaterConnection.fromJson({
      "action": "SUBMIT",
      "proposedTaps": 1,
      "proposedPipeSize": 10,
      "noOfTaps": 1
    });

    property = Property.fromJson({
      "landArea": 1,
      "usageCategory": "RESIDENTIAL",
      "creationReason": "CREATE",
      "noOfFloors": 1,
      "source": "WS",
      "channel": "CITIZEN",
      "ownershipCategory": "INDIVIDUAL",
      "owners": [
        Owners.fromJson({"ownerType": "NONE"}).toJson()
      ],
      "address": Address().toJson()
    });
    if (boundaryList.length == 1) {
      property.address.localityCtrl = boundaryList.first;
      onChangeOflocaity(property.address.localityCtrl);
    }
    if (commonProvider.userDetails?.selectedtenant?.code != null) {
      property.address.gpNameCtrl.text =
          commonProvider.userDetails!.selectedtenant!.code!;
      property.address.gpNameCityCodeCtrl.text =
          commonProvider.userDetails!.selectedtenant!.city!.code!;
    }
  }

  dispose() {
    streamController.close();
    super.dispose();
  }

  void onChangeOfCheckBox(bool? value, BuildContext context) {
    if (value ?? false) showInActiveAlert(context);
    if (value == true)
      waterconnection.status = Constants.CONNECTION_STATUS.first;
    else
      waterconnection.status = Constants.CONNECTION_STATUS[1];
    notifyListeners();
  }

  showInActiveAlert(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return CustomDialog(
          title: i18.common.ALERT,
          content: i18.consumer.ALL_DEMANDS_REVERSED,
          actions: [
            {'label': i18.common.OK, 'callBack': () => Navigator.pop(context)}
          ],
        );
      },
    );
  }

  Future<void> getWaterConnection(id) async {
    try {
      var commonProvider = Provider.of<CommonProvider>(
          navigatorKey.currentContext!,
          listen: false);
      WaterConnections waterconnections =
          await SearchConnectionRepository().getconnection({
        "tenantId": commonProvider.userDetails!.selectedtenant!.code,
        "connectionNumber": id.split('_').join('/')
      });
      if (waterconnections.waterConnection != null &&
          waterconnections.waterConnection!.isNotEmpty) {
        setWaterConnection(waterconnections.waterConnection?.first);
        fetchBoundary();
        getProperty({
          "tenantId": commonProvider.userDetails?.selectedtenant?.code,
          "propertyIds": waterconnections.waterConnection?.first.propertyId
        });
      }
    } catch (e) {}
  }

  Future<void> setWaterConnection(data) async {
    try {
      await getConnectionTypePropertyTypeTaxPeriod();
      await getPaymentType();
      isEdit = true;
      waterconnection = data;
      waterconnection.getText();
      selectedcycle = DateFormats.timeStampToDate(
                  waterconnection.previousReadingDate,
                  format: 'yyyy-MM-dd')
              .toString() +
          " 00:00:00.000";
      if (waterconnection.previousReadingDate != null &&
          (languageList?.mdmsRes?.billingService?.taxPeriodList?.isNotEmpty ??
              false)) {
        var date = DateTime.fromMillisecondsSinceEpoch(
            waterconnection.previousReadingDate!);
        DatePeriod datePeriod;
        if (date.month > 3)
          datePeriod = DatePeriod(DateTime(date.year, 4),
              DateTime(date.year + 1, 3, 31, 23, 59, 59, 999), DateType.YEAR);
        else
          datePeriod = DatePeriod(DateTime(date.year - 1, 4),
              DateTime(date.year, 3, 31, 23, 59, 59, 999), DateType.YEAR);

        billYear = languageList?.mdmsRes?.billingService?.taxPeriodList
            ?.firstWhere((e) {
          var date = DateTime.fromMillisecondsSinceEpoch(e.fromDate!);
          return date.month == datePeriod.startDate.month &&
              date.year == datePeriod.startDate.year;
        });
      }
      List<Demand>? demand = await ConsumerRepository().getDemandDetails({
        "consumerCode": waterconnection.connectionNo,
        "businessService": "WS",
        "tenantId": waterconnection.tenantId,
        // "status": "ACTIVE"
      });

      var paymentDetails = await BillingServiceRepository().fetchdBillPayments({
        "tenantId": waterconnection.tenantId,
        "consumerCodes": waterconnection.connectionNo,
        "businessService": "WS"
      });

      if (waterconnection.connectionType == 'Metered' &&
          waterconnection.additionalDetails?.meterReading.toString() != '0') {
        var meterReading = waterconnection.additionalDetails?.meterReading
            .toString()
            .padLeft(5, '0');
        waterconnection.om_1Ctrl.text =
            meterReading.toString().characters.elementAt(0);
        waterconnection.om_2Ctrl.text =
            meterReading.toString().characters.elementAt(1);
        waterconnection.om_3Ctrl.text =
            meterReading.toString().characters.elementAt(2);
        waterconnection.om_4Ctrl.text =
            meterReading.toString().characters.elementAt(3);
        waterconnection.om_5Ctrl.text =
            meterReading.toString().characters.elementAt(4);
      }

      demand =
          demand?.where((element) => element.status != 'CANCELLED').toList();

      if (demand?.isEmpty == true) {
        isfirstdemand = false;
      } else if (demand?.length == 1 &&
          demand?.first.consumerType == 'waterConnection-arrears') {
        isfirstdemand = false;
      } else if (demand?.length == 1 &&
          demand?.first.consumerType == 'waterConnection-advance' &&
          demand?.first.demandDetails?.first.taxHeadMasterCode ==
              'WS_ADVANCE_CARRYFORWARD') {
        isfirstdemand = false;
      } else {
        isfirstdemand = true;
      }

      if (paymentDetails.payments != null &&
          paymentDetails.payments!.isNotEmpty) {
        isfirstdemand = true;
      }
      notifyListeners();
    } catch (e, s) {
      ErrorHandler().allExceptionsHandler(navigatorKey.currentContext!, e, s);
    }
  }

  Future<void> getConsumerDetails() async {
    try {
      streamController.add(property);
    } catch (e) {
      print(e);
      streamController.addError('error');
    }
  }

  void validateConsumerDetails(context) async {
    var commonProvider = Provider.of<CommonProvider>(
        navigatorKey.currentContext!,
        listen: false);
    if (formKey.currentState!.validate()) {
      waterconnection.setText();
      property.owners!.first.setText();
      property.address.setText();

      property.tenantId = commonProvider.userDetails!.selectedtenant!.code;
      property.address.city = commonProvider.userDetails!.selectedtenant!.name;
      if (waterconnection.processInstance == null) {
        var processInstance = ProcessInstance();
        processInstance.action = 'SUBMIT';
        waterconnection.processInstance = processInstance;
      }
      waterconnection.tenantId =
          commonProvider.userDetails!.selectedtenant!.code;
      waterconnection.connectionHolders = property.owners;
      waterconnection.noOfTaps = 1;
      waterconnection.propertyType = property.propertyType;
      if (waterconnection.connectionType == 'Metered') {
        waterconnection.meterInstallationDate =
            waterconnection.previousReadingDate;

        // ignore: unrelated_type_equality_checks
        waterconnection.previousReading =
            (waterconnection.om_1Ctrl.text == "" &&
                    waterconnection.om_2Ctrl.text == "" &&
                    waterconnection.om_3Ctrl.text == "" &&
                    waterconnection.om_4Ctrl.text == "" &&
                    waterconnection.om_5Ctrl.text == "")
                ? 0
                : int.parse(waterconnection.om_1Ctrl.text +
                    waterconnection.om_2Ctrl.text +
                    waterconnection.om_3Ctrl.text +
                    waterconnection.om_4Ctrl.text +
                    waterconnection.om_5Ctrl.text);
      } else {
        waterconnection.previousReadingDate =
            waterconnection.meterInstallationDate;
      }

      if (waterconnection.additionalDetails == null) {
        waterconnection.additionalDetails =
            addition.AdditionalDetails.fromJson({
          "locality": property.address.locality?.code,
          "street": property.address.street,
          "doorNo": property.address.doorNo,
          "initialMeterReading": waterconnection.previousReading,
          "propertyType": property.propertyType,
          "meterReading": waterconnection.previousReading,
          "category": waterconnection.categoryCtrl.text.trim().isEmpty
              ? null
              : waterconnection.additionalDetails?.category,
          "subCategory": waterconnection.subCategoryCtrl.text.trim().isEmpty
              ? null
              : waterconnection.additionalDetails?.subCategory,
          "aadharNumber": waterconnection.addharCtrl.text.trim().isEmpty
              ? null
              : waterconnection.addharCtrl.text.trim()
        });
      } else {
        waterconnection.additionalDetails!.locality =
            property.address.locality!.code;
        waterconnection.additionalDetails!.initialMeterReading =
            waterconnection.previousReading;
        waterconnection.additionalDetails!.category =
            waterconnection.categoryCtrl.text.trim().isEmpty
                ? null
                : waterconnection.additionalDetails?.category;
        waterconnection.additionalDetails!.subCategory =
            waterconnection.subCategoryCtrl.text.trim().isEmpty
                ? null
                : waterconnection.additionalDetails?.subCategory;
        waterconnection.additionalDetails!.aadharNumber =
            waterconnection.addharCtrl.text.trim().isEmpty
                ? null
                : waterconnection.addharCtrl.text.trim();
        waterconnection.additionalDetails!.street = property.address.street;
        waterconnection.additionalDetails!.doorNo = property.address.doorNo;
        waterconnection.additionalDetails!.meterReading =
            waterconnection.previousReading;
        waterconnection.additionalDetails!.propertyType = property.propertyType;
      }

      try {
        Loaders.showLoadingDialog(context);
        //IF the Consumer Detaisl Screen is in Edit Mode
        if (!isEdit) {
          var result1 =
              await ConsumerRepository().addProperty(property.toJson());
          waterconnection.propertyId =
              result1['Properties'].first!['propertyId'];

          var result2 = await ConsumerRepository()
              .addconnection(waterconnection.toJson());
          if (result2 != null) {
            setModel();
            phoneNumberAutoValidation = false;
            streamController.add(property);
            Notifiers.getToastMessage(
                context, i18.consumer.REGISTER_SUCCESS, 'SUCCESS');
            selectedcycle = '';
            waterconnection.connectionType = '';
            Navigator.pop(context);
          }
        } else {
          property.creationReason = 'UPDATE';
          property.address.geoLocation = GeoLocation();
          property.address.geoLocation?.latitude = null;
          property.address.geoLocation?.longitude = null;
          property.source = 'WS';
          if (waterconnection.status == 'Inactive') {
            waterconnection.paymentType = null;
            waterconnection.penalty = null;
            waterconnection.arrears = null;
            waterconnection.advance = null;
          }
          var result1 =
              await ConsumerRepository().updateProperty(property.toJson());
          var result2 = await ConsumerRepository()
              .updateconnection(waterconnection.toJson());

          if (result2 != null && result1 != null)
            Notifiers.getToastMessage(
                context, i18.consumer.UPDATED_SUCCESS, 'SUCCESS');
          Navigator.pop(context);
          CommonMethods.home();
        }
      } catch (e, s) {
        Navigator.pop(context);
        ErrorHandler().allExceptionsHandler(context, e, s);
      }
    } else {
      autoValidation = true;
      notifyListeners();
    }
  }

  void onChangeOfGender(String gender, Owners owners) {
    owners.gender = gender;
    notifyListeners();
  }

  void onChangeOfDate(value) {
    notifyListeners();
  }

  Future<void> getConnectionTypePropertyTypeTaxPeriod() async {
    try {
      var commonProvider = Provider.of<CommonProvider>(
          navigatorKey.currentContext!,
          listen: false);

      var dateTime = DateTime.now();
      if (dateTime.month == 4) {
        dateTime = DateTime(dateTime.year, dateTime.month - 1, dateTime.day);
      }

      var res = await CoreRepository().getMdms(
          getConnectionTypePropertyTypeTaxPeriodMDMS(
              commonProvider.userDetails!.userRequest!.tenantId.toString(),
              (DateFormats.dateToTimeStamp(DateFormats.getFilteredDate(
                  dateTime.toLocal().toString())))));
      languageList = res;
    } catch (e) {
      print(e);
    }
  }

  Future<void> getPaymentType() async {
    var commonProvider = Provider.of<CommonProvider>(
        navigatorKey.currentContext!,
        listen: false);
    try {
      var res = await CommonProvider.getMdmsBillingService(
          commonProvider.userDetails!.selectedtenant?.code.toString() ??
              commonProvider.userDetails!.userRequest!.tenantId.toString());
      if (res.mdmsRes?.billingService?.taxHeadMasterList != null &&
          res.mdmsRes!.billingService!.taxHeadMasterList!.isNotEmpty) {
        paymentType = res;
      } else {
        var res = await CommonProvider.getMdmsBillingService(
            commonProvider.userDetails!.userRequest!.tenantId.toString());
        paymentType = res;
      }
      notifyListeners();
    } catch (e) {
      print(e);
    }
  }

  Future<Property?> getProperty(Map<String, dynamic> query) async {
    try {
      var commonProvider = Provider.of<CommonProvider>(
          navigatorKey.currentContext!,
          listen: false);
      var res = await ConsumerRepository().getProperty(query);
      if (res != null)
        property = new Property.fromJson(res['Properties'].first);
      property.owners!.first.getText();
      property.address.getText();

      property.address.localityCtrl = boundaryList.firstWhere(
          (element) => element.code == property.address.locality!.code);
      onChangeOflocaity(property.address.localityCtrl);

      property.address.gpNameCtrl.text =
          commonProvider.userDetails!.selectedtenant!.code!;
      property.address.gpNameCityCodeCtrl.text =
          commonProvider.userDetails!.selectedtenant!.city!.code!;
      streamController.add(property);
      notifyListeners();
    } catch (e) {
      print(e);
    }
  }

  Future<void> fetchBoundary() async {
    var commonProvider = Provider.of<CommonProvider>(
        navigatorKey.currentContext!,
        listen: false);

    try {
      var result = await ConsumerRepository().getLocations({
        "hierarchyTypeCode": "REVENUE",
        "boundaryType": "Locality",
        "tenantId": commonProvider.userDetails!.selectedtenant!.code
      });
      boundaryList = [];
      boundaryList.addAll(
          TenantBoundary.fromJson(result['TenantBoundary'][0]).boundary!);
      if (boundaryList.length == 1) {
        property.address.localityCtrl = boundaryList.first;
        onChangeOflocaity(property.address.localityCtrl);
      }
      // notifyListeners();
    } catch (e) {
      print(e);
    }
  }

  void setwallthrough(value) {
    consmerWalkthrougList = value;
  }

  void onChangeOflocaity(val) {
    property.address.locality ??= Locality();
    property.address.locality?.code = val.code;
    property.address.locality?.area = val.area;
    notifyListeners();
  }

  void onChangeOfCategory(val) {
    waterconnection.additionalDetails ??= addition.AdditionalDetails();
    waterconnection.additionalDetails?.category = val;
    notifyListeners();
  }

  void onChangeOfSubCategory(val) {
    waterconnection.additionalDetails ??= addition.AdditionalDetails();
    waterconnection.additionalDetails?.subCategory = val;
    notifyListeners();
  }

  onChangeOfPropertyType(val) {
    property.propertyType = val;
    notifyListeners();
  }

  List<DropdownMenuItem<Object>> getBoundaryList() {
    if (boundaryList.length > 0) {
      return (boundaryList).map((value) {
        return DropdownMenuItem(
          value: value,
          child: new Text(value.code!),
        );
      }).toList();
    }
    return <DropdownMenuItem<Object>>[];
  }

  List<DropdownMenuItem<Object>> getCategoryList() {
    if (languageList?.mdmsRes?.category != null) {
      return (languageList?.mdmsRes?.category?.categoryList ?? <CategoryType>[])
          .map((value) {
        return DropdownMenuItem(
          value: value.code,
          child: new Text((value.code!)),
        );
      }).toList();
    }
    return <DropdownMenuItem<Object>>[];
  }

  List<DropdownMenuItem<Object>> getSubCategoryList() {
    if (languageList?.mdmsRes?.subCategory != null) {
      return (languageList?.mdmsRes?.subCategory?.subcategoryList ??
              <SubCategoryType>[])
          .map((value) {
        return DropdownMenuItem(
          value: value.code,
          child: new Text((value.code!)),
        );
      }).toList();
    }
    return <DropdownMenuItem<Object>>[];
  }

  List<DropdownMenuItem<Object>> getPropertTypeList() {
    if (languageList?.mdmsRes?.propertyTax?.PropertyTypeList != null) {
      return (languageList?.mdmsRes?.propertyTax?.PropertyTypeList ??
              <PropertyType>[])
          .map((value) {
        return DropdownMenuItem(
          value: value.code,
          child: new Text(value.code!),
        );
      }).toList();
    }
    return <DropdownMenuItem<Object>>[];
  }

  onChangeOfConnectionType(val) {
    waterconnection.connectionType = val;
    waterconnection.meterIdCtrl.clear();
    waterconnection.previousReadingDateCtrl.clear();
    billYear = null;
    selectedcycle = null;
    waterconnection.BillingCycleCtrl.clear();
    waterconnection.meterInstallationDateCtrl.clear();
    searchPickerKey?.currentState?.Options.clear();

    notifyListeners();
  }

  onChangeBillingcycle(val) {
    selectedcycle = val;
    var date = val;
    waterconnection.previousReadingDateCtrl.clear();
    waterconnection.BillingCycleCtrl.text = selectedcycle ?? '';
    waterconnection.meterInstallationDateCtrl.text = selectedcycle ?? '';
    notifyListeners();
  }

//Displaying ConnectionType data Fetched From MDMD (Ex Metered, Non Metered..)
  List<DropdownMenuItem<Object>> getConnectionTypeList() {
    if (languageList?.mdmsRes?.connection?.connectionTypeList != null) {
      return (languageList?.mdmsRes?.connection?.connectionTypeList ??
              <ConnectionType>[])
          .map((value) {
        return DropdownMenuItem(
          value: value.code,
          child: new Text((value.code!)),
        );
      }).toList();
    }
    return <DropdownMenuItem<Object>>[];
  }

  //Displaying Billing Cycle Vaule (EX- JAN-2021,,)
  List<DropdownMenuItem<Object>> getBillingCycle() {
    dates = [];
    if (billYear != null) {
      late DatePeriod ytd;
      if (DateTime.now().month >= 4) {
        ytd = DatePeriod(
            DateTime(DateTime.now().year, 4),
            DateTime(DateTime.now().year + 1, 4, 0, 23, 59, 59, 999),
            DateType.YTD);
      } else {
        ytd = DatePeriod(
            DateTime(DateTime.now().year - 1, 4), DateTime.now(), DateType.YTD);
      }

      var date1 = DateFormats.getFormattedDateToDateTime(
          DateFormats.timeStampToDate(billYear?.fromDate)) as DateTime;
      var isCurrentYtdSelected = date1.year == ytd.startDate.year;

      /// Get months based on selected billing year
      var months = CommonMethods.getPastMonthUntilFinancialYear(date1.year);

      /// if its current ytd year means removing till current month
      if (isCurrentYtdSelected) {
        switch (DateTime.now().month) {
          case 1:
            months.removeRange(0, 3);
            break;
          case 2:
            months.removeRange(0, 2);
            break;
          case 3:
            months.removeRange(0, 1);
            break;
        }
      }

      for (var i = 0; i < months.length; i++) {
        var prevMonth = months[i].startDate;
        var r = {"code": prevMonth, "name": prevMonth};
        dates.add(r);
      }
    }
    if (dates.length > 0 && waterconnection.connectionType == 'Non_Metered') {
      return (dates).map((value) {
        var d = value['name'];
        return DropdownMenuItem(
          value: value['code'].toLocal().toString(),
          child: new Text(
              ApplicationLocalizations.of(navigatorKey.currentContext!)
                      .translate((Constants.MONTHS[d.month - 1])) +
                  " - " +
                  d.year.toString()),
        );
      }).toList();
    }
    return <DropdownMenuItem<Object>>[];
  }

  incrementindex(index, consumerGenderKey) async {
    if (boundaryList.length > 1) {
      activeindex = index + 1;
    } else {
      if (activeindex == 4) {
        activeindex = index + 2;
      } else {
        activeindex = index + 1;
      }
    }
    await Scrollable.ensureVisible(consumerGenderKey.currentContext!,
        duration: new Duration(milliseconds: 100));
  }

  callNotifyer() {
    notifyListeners();
  }

  void onChangeOfBillYear(val) {
    billYear = val;
    selectedcycle = null;
    waterconnection.previousReadingDateCtrl.clear();
    waterconnection.BillingCycleCtrl.clear();
    waterconnection.meterInstallationDateCtrl.clear();
    searchPickerKey?.currentState?.Options.clear();
    // waterconnection.billingCycleYearCtrl.text = billYear;
    notifyListeners();
  }

  List<DropdownMenuItem<Object>> getFinancialYearList() {
    if (languageList?.mdmsRes?.billingService?.taxPeriodList != null) {
      CommonMethods.getFilteredFinancialYearList(
          languageList?.mdmsRes?.billingService?.taxPeriodList ??
              <TaxPeriod>[]);
      return (languageList?.mdmsRes?.billingService?.taxPeriodList ??
              <TaxPeriod>[])
          .map((value) {
        return DropdownMenuItem(
          value: value,
          child: new Text((value.financialYear!)),
        );
      }).toList();
    }
    return <DropdownMenuItem<Object>>[];
  }

  void onChangeOfAmountType(value) {
    waterconnection.paymentType = value;

    if (!isEdit) {
      waterconnection.penaltyCtrl.clear();
      waterconnection.advanceCtrl.clear();
      waterconnection.arrearsCtrl.clear();
    } else {}
    notifyListeners();
  }

  List<KeyValue> getPaymentTypeList() {
    if (CommonProvider.getPenaltyOrAdvanceStatus(paymentType, true))
      return Constants.CONSUMER_PAYMENT_TYPE;
    return [Constants.CONSUMER_PAYMENT_TYPE.first];
  }
}
