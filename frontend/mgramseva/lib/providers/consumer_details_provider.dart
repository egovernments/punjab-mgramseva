import 'dart:async';
import 'package:flutter/material.dart';
import 'package:mgramseva/model/common/demand.dart';
import 'package:mgramseva/model/connection/property.dart';
import 'package:mgramseva/model/connection/tenant_boundary.dart';
import 'package:mgramseva/model/connection/water_connection.dart';
import 'package:mgramseva/model/connection/water_connections.dart';
import 'package:mgramseva/model/localization/language.dart';
import 'package:mgramseva/model/mdms/connection_type.dart';
import 'package:mgramseva/model/mdms/property_type.dart';
import 'package:mgramseva/providers/common_provider.dart';
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
import 'package:mgramseva/utils/notifyers.dart';
import 'package:provider/provider.dart';
import 'package:mgramseva/model/connection/water_connection.dart' as addition;

class ConsumerProvider with ChangeNotifier {
  late List<ConsumerWalkWidgets> consmerWalkthrougList;
  var streamController = StreamController.broadcast();
  late GlobalKey<FormState> formKey;
  var isfirstdemand = false;
  var autoValidation = false;
  int activeindex = 0;
  late WaterConnection waterconnection;
  var boundaryList = <Boundary>[];
  var selectedcycle;
  var selectedbill;
  late Property property;
  late List dates = [];
  late bool isEdit = false;
  LanguageList? languageList;
  bool phoneNumberAutoValidation = false;

  setModel() async {
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
      "source": "MUNICIPAL_RECORDS",
      "channel": "CITIZEN",
      "ownershipCategory": "INDIVIDUAL",
      "owners": [
        Owners.fromJson({"ownerType": "NONE"}).toJson()
      ],
      "address": Address().toJson()
    });

    property.address.gpNameCtrl.text =
        ApplicationLocalizations.of(navigatorKey.currentContext!)
                .translate(commonProvider.userDetails!.selectedtenant!.code!) +
            ' - ' +
            commonProvider.userDetails!.selectedtenant!.city!.code!;
  }

  dispose() {
    streamController.close();
    super.dispose();
  }

  void onChangeOfCheckBox(bool? value) {
    if (value == true)
      waterconnection.status = 'Inactive';
    else
      waterconnection.status = 'Active';
    notifyListeners();
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
      if (waterconnections.waterConnection!.isNotEmpty) {
        setWaterConnection(waterconnections.waterConnection!.first);
        getProperty({
          "tenantId": commonProvider.userDetails!.selectedtenant!.code,
          "propertyIds": waterconnections.waterConnection!.first.propertyId
        });
      }
    } catch (e) {}
  }

  Future<void> setWaterConnection(data) async {
    isEdit = true;
    waterconnection = data;
    waterconnection.getText();

    List<Demand>? demand = await ConsumerRepository().getDemandDetails({
      "consumerCode": waterconnection.connectionNo,
      "businessService": "WS",
      "tenantId": waterconnection.tenantId
    });
    if (waterconnection.connectionType == 'Metered' &&
        waterconnection.additionalDetails!.meterReading.toString() != '0') {
      var meterReading = waterconnection.additionalDetails!.meterReading
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
    if (demand?.isEmpty == true) {
      isfirstdemand = false;
    } else if (demand?.length == 1 &&
        demand?.first.consumerType == 'waterConnection-arrears') {
      isfirstdemand = false;
    } else {
      isfirstdemand = true;
    }

    notifyListeners();
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
      waterconnection.setText();
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
        });
      } else {
        waterconnection.additionalDetails!.locality =
            property.address.locality!.code;
        waterconnection.additionalDetails!.initialMeterReading =
            waterconnection.previousReading;
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
            Navigator.pop(context);
          }
        } else {
          property.creationReason = 'UPDATE';

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
      var res = await CoreRepository().getMdms(
          getConnectionTypePropertyTypeTaxPeriodMDMS(
              commonProvider.userDetails!.userRequest!.tenantId.toString(),
              (DateFormats.dateToTimeStamp(DateFormats.getFilteredDate(
                  new DateTime.now().toLocal().toString())))));
      languageList = res;
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

      property.address.gpNameCtrl
          .text = ApplicationLocalizations.of(navigatorKey.currentContext!)
              .translate(commonProvider.userDetails!.selectedtenant!.code!) +
          ' - ' +
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
    boundaryList = [];
    try {
      var result = await ConsumerRepository().getLocations({
        "hierarchyTypeCode": "REVENUE",
        "boundaryType": "Locality",
        "tenantId": commonProvider.userDetails!.selectedtenant!.code
      });
      boundaryList.addAll(
          TenantBoundary.fromJson(result['TenantBoundary'][0]).boundary!);
      if (boundaryList.length == 1) {
        property.address.localityCtrl = boundaryList.first;
        onChangeOflocaity(property.address.localityCtrl);
      }
      notifyListeners();
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

  onChangeOfPropertyType(val) {
    property.propertyType = val;
    notifyListeners();
  }

  List<DropdownMenuItem<Object>> getBoundaryList() {
    if (boundaryList.length > 0) {
      return (boundaryList).map((value) {
        return DropdownMenuItem(
          value: value,
          child: new Text(
              ApplicationLocalizations.of(navigatorKey.currentContext!)
                  .translate(value.code!)),
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
          child: new Text(
              ApplicationLocalizations.of(navigatorKey.currentContext!)
                  .translate(value.code!)),
        );
      }).toList();
    }
    return <DropdownMenuItem<Object>>[];
  }

  onChangeOfConnectionType(val) {
    waterconnection.connectionType = val;
    waterconnection.meterIdCtrl.clear();
    waterconnection.previousReadingDateCtrl.clear();

    notifyListeners();
  }

  onChangeBillingcycle(val) {
    selectedcycle = val;
    var date = val;
    waterconnection.meterInstallationDateCtrl.text = selectedcycle;
  }

//Displaying ConnectionType data Fetched From MDMD (Ex Metered, Non Metered..)
  List<DropdownMenuItem<Object>> getConnectionTypeList() {
    if (languageList?.mdmsRes?.connection?.connectionTypeList != null) {
      return (languageList?.mdmsRes?.connection?.connectionTypeList ??
              <ConnectionType>[])
          .map((value) {
        return DropdownMenuItem(
          value: value.code,
          child: new Text(
              ApplicationLocalizations.of(navigatorKey.currentContext!)
                  .translate(value.code!)),
        );
      }).toList();
    }
    return <DropdownMenuItem<Object>>[];
  }

  //Displaying Billing Cycle Vaule (EX- JAN-2021,,)
  List<DropdownMenuItem<Object>> getBillingCycle() {
    if (languageList?.mdmsRes?.taxPeriodList!.TaxPeriodList! != null &&
        dates.length == 0) {
      var date2 = DateFormats.getFormattedDateToDateTime(
          DateFormats.timeStampToDate(DateTime.now().millisecondsSinceEpoch));
      var date1 = DateFormats.getFormattedDateToDateTime(
          DateFormats.timeStampToDate(languageList!
              .mdmsRes?.taxPeriodList!.TaxPeriodList!.first.fromDate));
      var d = date2 as DateTime;
      var now = date1 as DateTime;
      var days = d.day - now.day;
      var years = d.year - now.year;
      var months = d.month - now.month;
      if (months < 0 || (months == 0 && days < 0)) {
        years--;
        months += (days < 0 ? 11 : 12);
      }
      for (var i = 0; i < months; i++) {
        var prevMonth = new DateTime(now.year, date1.month + i, 1);
        var r = {"code": prevMonth, "name": prevMonth};
        dates.add(r);
      }
    }
    if (dates.length > 0 && waterconnection.connectionType == 'Non_Metered') {
      return (dates).map((value) {
        var d = value['name'];
        return DropdownMenuItem(
          value: value['code'].toLocal().toString(),
          child: Text(ApplicationLocalizations.of(navigatorKey.currentContext!)
                  .translate(Constants.MONTHS[d.month - 1]) +
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
}
