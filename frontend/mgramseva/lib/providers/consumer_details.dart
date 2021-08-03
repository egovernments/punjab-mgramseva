import 'dart:async';

import 'package:flutter/material.dart';
import 'package:mgramseva/constants/houseconnectiondetails.dart';
import 'package:mgramseva/model/connection/property.dart';
import 'package:mgramseva/model/connection/tenant_boundary.dart';
import 'package:mgramseva/model/connection/water_connection.dart';
import 'package:mgramseva/model/localization/language.dart';
import 'package:mgramseva/model/mdms/connection_type.dart';
import 'package:mgramseva/model/mdms/property_type.dart';
import 'package:mgramseva/repository/consumer_details_repo.dart';
import 'package:mgramseva/repository/core_repo.dart';
import 'package:mgramseva/services/MDMS.dart';

class ConsumerProvider with ChangeNotifier {
  var streamController = StreamController.broadcast();
  late GlobalKey<FormState> formKey;
  LanguageList? languageList;
  var waterconnection = WaterConnection.fromJson({
    "tenantId": "pb.lodhipur",
    "action": "INITIATE",
    "proposedTaps": "10",
    "proposedPipeSize": 10,
  });
  var boundaryList = <Boundary>[];
  var property = Property.fromJson({
    "landArea": "1",
    "tenantId": "pb.lodhipur",
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

  dispose() {
    streamController.close();
    super.dispose();
  }

  Future<void> getConsumerDetails() async {
    try {
      streamController.add(property);
    } catch (e) {
      print(e);
      streamController.addError('error');
    }
  }

  void validateExpensesDetails() async {
    if (formKey.currentState!.validate()) {
      property.owners!.first.setText();
      property.address.setText();
      property.address.city = 'lodhipur';
      waterconnection.setText();
      if (waterconnection.processInstance == null) {
        var processInstance = ProcessInstance();
        processInstance.action = 'INITIATE';
        waterconnection.processInstance = processInstance;
      }

      // notifyListeners();
      try {
        var result = await ConsumerRepository().addProperty(property.toJson());
        // result.then((value) => {print(value['Properties'].first.propertyId)});
        waterconnection.propertyId = result['Properties'].first!['propertyId'];
        result =
            await ConsumerRepository().addconnection(waterconnection.toJson());
      } catch (e) {
        print(e);
      }
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

  Future<void> fetchBoundary() async {
    boundaryList = [];
    try {
      var result = await ConsumerRepository().getLocations({
        "hierarchyTypeCode": "REVENUE",
        "boundaryType": "Locality",
        "tenantId": "pb.lodhipur"
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
    // property.address.locality?.code = val.code;
    // property.address.locality?.area = val.area;
    notifyListeners();
  }

  List<DropdownMenuItem<Object>> getBoundaryList() {
    if (boundaryList.length > 0) {
      return (boundaryList).map((value) {
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
    print(val);
    waterconnection.connectionType = val;
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
