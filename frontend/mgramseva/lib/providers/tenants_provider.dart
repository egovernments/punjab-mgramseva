import 'dart:async';

import 'package:flutter/material.dart';
import 'package:mgramseva/model/mdms/tenants.dart';
import 'package:mgramseva/repository/tendants_repo.dart';
import 'package:mgramseva/services/MDMS.dart';

class TenantsProvider with ChangeNotifier {
  Tenant? tenants;
  var streamController = StreamController.broadcast();

  dispose() {
    streamController.close();
    super.dispose();
  }

  Future<void> getTenants() async {
    try {
      var userResponse = await TenantRepo().fetchTenants(getTenantsMDMS('pb'));
      print(userResponse);
      if (userResponse != null) {
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
    print(tenants);
    return tenants!.tenantsList!.length;
  }
}
