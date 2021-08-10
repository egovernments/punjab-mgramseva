import 'dart:async';
import 'package:flutter/material.dart';
import 'package:mgramseva/model/connection/property.dart';
import 'package:mgramseva/model/connection/tenant_boundary.dart';
import 'package:mgramseva/model/connection/water_connection.dart';
import 'package:mgramseva/model/localization/language.dart';
import 'package:mgramseva/model/mdms/connection_type.dart';
import 'package:mgramseva/model/mdms/property_type.dart';
import 'package:mgramseva/providers/common_provider.dart';
import 'package:mgramseva/repository/consumer_details_repo.dart';
import 'package:mgramseva/repository/core_repo.dart';
import 'package:mgramseva/services/MDMS.dart';
import 'package:mgramseva/utils/Constants/I18KeyConstants.dart';
import 'package:mgramseva/utils/global_variables.dart';
import 'package:mgramseva/utils/loaders.dart';
import 'package:mgramseva/utils/notifyers.dart';
import 'package:provider/provider.dart';
import 'package:mgramseva/model/connection/water_connection.dart' as addition;

class ConsumerProvider with ChangeNotifier {
  var streamController = StreamController.broadcast();
  late GlobalKey<FormState> formKey;
  var autoValidation = false;
  late WaterConnection waterconnection;
  var boundaryList = <Boundary>[];
  late Property property;
  LanguageList? languageList;
  setModel() {
    waterconnection = WaterConnection.fromJson({
      "action": "INITIATE",
      "proposedTaps": 10,
      "proposedPipeSize": 10,
      "additionalDetails": {"initialMeterReading": "0"}
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
  }

  dispose() {
    streamController.close();
    super.dispose();
  }

  Future<void> setWaterConnection(data) async {
    waterconnection = data;
    waterconnection.getText();
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

  void validateExpensesDetails(context) async {
    var commonProvider = Provider.of<CommonProvider>(
        navigatorKey.currentContext!,
        listen: false);
    if (formKey.currentState!.validate()) {
      property.owners!.first.setText();
      property.address.setText();
      property.tenantId = commonProvider.userDetails!.selectedtenant!.code;
      property.address.city = commonProvider.userDetails!.selectedtenant!.name;
      waterconnection.setText();
      if (waterconnection.processInstance == null) {
        var processInstance = ProcessInstance();
        processInstance.action = 'INITIATE';
        waterconnection.processInstance = processInstance;
        waterconnection.tenantId =
            commonProvider.userDetails!.selectedtenant!.code;
        waterconnection.connectionHolders = property.owners;
        if (waterconnection.additionalDetails == null) {
          waterconnection.additionalDetails =
              addition.AdditionalDetails.fromJson({
            "locality": property.address.locality!.code,
            "initialMeterReading": 0,
          });
        } else {
          waterconnection.additionalDetails!.locality =
              property.address.locality!.code;
        }
      }

      try {
        Loaders.showLoadingDialog(context);
        var result1 = await ConsumerRepository().addProperty(property.toJson());
        waterconnection.propertyId = result1['Properties'].first!['propertyId'];
        var result2 =
            await ConsumerRepository().addconnection(waterconnection.toJson());
        if (result2 != null) {
          setModel();
          streamController.add(property);
          Notifiers.getToastMessage(
              context, i18.consumer.REGISTER_SUCCESS, 'SUCCESS');
          property.address.city = "";
          property.address.localityCtrl.text = "";
        }
      } catch (e) {
        Navigator.pop(context);
      }
    } else {
      autoValidation = true;
    }
  }

  void onChangeOfGender(String gender, Owners owners) {
    owners.gender = gender;
    notifyListeners();
  }

  void onChangeOfDate(value) {
    // waterconnection.previousReadingDate = value;
    notifyListeners();
  }

  Future<void> getPropertyTypeandConnectionType() async {
    try {
      var res = await CoreRepository()
          .getMdms(getConnectionTypePropertyTypeMDMS('pb'));
      languageList = res;
    } catch (e) {
      print(e);
    }
  }

  Future<Property?> getProperty(Map<String, dynamic> query) async {
    try {
      var res = await ConsumerRepository().getProperty(query);
      property = new Property.fromJson(res['Properties'].first);
      property.owners!.first.getText();
      property.address.getText();
      streamController.add(property);
      property.address.localityCtrl = boundaryList.firstWhere(
          (element) => element.code == property.address.locality!.code);
      onChangeOflocaity(property.address.localityCtrl);
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
      notifyListeners();
    } catch (e) {
      print(e);
    }
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
        print(value);
        return DropdownMenuItem(
          value: value,
          child: new Text(value.name!),
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
          child: new Text(value.name!),
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

  List<DropdownMenuItem<Object>> getConnectionTypeList() {
    if (languageList?.mdmsRes?.connection?.connectionTypeList != null) {
      return (languageList?.mdmsRes?.connection?.connectionTypeList ??
              <ConnectionType>[])
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
