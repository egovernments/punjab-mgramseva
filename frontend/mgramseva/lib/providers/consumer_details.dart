import 'dart:async';

import 'package:flutter/material.dart';
import 'package:mgramseva/model/connection/property.dart';
import 'package:mgramseva/model/connection/tenant_boundary.dart';
import 'package:mgramseva/repository/consumer_details_repo.dart';

class ConsumerProvider with ChangeNotifier {
  var streamController = StreamController.broadcast();

  var boundaryList = <Boundary>[];
  var property = Property.fromJson({
    "landArea": "1",
    "tenantId": "pb.lodhipur",
    "propertyType": "BUILTUP.INDEPENDENTPROPERTY",
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

  void validateExpensesDetails() {
    property.owners!.first.setText();
    property.address!.setText();
    print(property.owners!.first.toJson());
    print(property.address!.toJson());
    // notifyListeners();
    ConsumerRepository().addProperty(property.toJson());
  }

  void onChangeOfGender(String gender, Owners owners) {
    owners.gender = gender;
    notifyListeners();
  }

  Future<void> fetchBoundary() async {
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
    print(val);
    property.address!.locality != val;
    // expenditureDetails.expenseType = val;
    notifyListeners();
  }

  List<DropdownMenuItem<Object>> getBoundaryList() {
    if (boundaryList.length > 0) {
      return (boundaryList).map((value) {
        return DropdownMenuItem(
          value: value.code,
          child: new Text(value.name!),
        );
      }).toList();
    }
    return <DropdownMenuItem<Object>>[];
  }
}
