import 'dart:async';

import 'package:flutter/material.dart';
import 'package:mgramseva/model/connection/property.dart';
import 'package:mgramseva/providers/common_provider.dart';
import 'package:mgramseva/repository/consumer_details_repo.dart';
import 'package:mgramseva/utils/global_variables.dart';
import 'package:provider/provider.dart';

class ConsumerProvider with ChangeNotifier {
  var streamController = StreamController.broadcast();
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
    var commonProvider = Provider.of<CommonProvider>(
        navigatorKey.currentContext!,
        listen: false);

// commonProvider.getMdmsId(languageList, 'EXPENSE.${expenditureDetails.expenseType}', MDMSType.BusinessService)

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
}
