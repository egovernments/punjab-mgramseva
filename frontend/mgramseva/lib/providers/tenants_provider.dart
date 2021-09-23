import 'dart:async';

import 'package:flutter/material.dart';
import 'package:mgramseva/model/mdms/tenants.dart';
import 'package:mgramseva/repository/tendants_repo.dart';
import 'package:mgramseva/services/MDMS.dart';
import 'package:mgramseva/utils/global_variables.dart';
import 'package:provider/provider.dart';

import 'common_provider.dart';

class TenantsProvider with ChangeNotifier {
  Tenant? tenants;
  var streamController = StreamController.broadcast();

  dispose() {
    streamController.close();
    super.dispose();
  }

  Future<void> getTenants() async {
    try {
      var commonProvider = Provider.of<CommonProvider>(
          navigatorKey.currentContext!,
          listen: false);
      var userResponse = await TenantRepo().fetchTenants(getTenantsMDMS(commonProvider.userDetails!.userRequest!.tenantId.toString()));
      if (userResponse != null) {
        tenants = userResponse;
        streamController.add(userResponse);
      }
    } catch (e) {
      print("its an error");
      print(e);
      streamController.addError('error');
    }
  }

  void callNotifyer() {
    notifyListeners();
  }

  getTenant() {
    return tenants!.tenantsList!.length;
  }
}
