import 'dart:async';

import 'package:flutter/material.dart';
import 'package:mgramseva/model/mdms/department.dart';
import 'package:mgramseva/repository/core_repo.dart';
import 'package:mgramseva/repository/water_services_calculation.dart';
import 'package:mgramseva/utils/error_logging.dart';
import 'package:mgramseva/utils/global_variables.dart';
import 'package:provider/provider.dart';

import '../repository/ifix_hierarchy_repo.dart';
import 'common_provider.dart';

class IfixHierarchyProvider with ChangeNotifier {
  Department? departments;
  Map<String, Map<String, String>> hierarchy = {};
  WCBillingSlabs? wcBillingSlabs;
  var streamController = StreamController.broadcast();
  var streamControllerRate = StreamController.broadcast();

  dispose() {
    streamController.close();
    super.dispose();
  }

  Future<void> getDepartments() async {
    try {
      var commonProvider = Provider.of<CommonProvider>(
          navigatorKey.currentContext!,
          listen: false);
      var userResponse = await IfixHierarchyRepo().fetchDepartments(
          commonProvider.userDetails!.selectedtenant!.city!.code!, true);
      departments = userResponse;
      hierarchy.clear();
      if (departments != null) {
        parseDepartments(departments!);
      }
      streamController.add(userResponse);
      callNotifier();
    } catch (e, s) {
      hierarchy.clear();
      ErrorHandler().allExceptionsHandler(navigatorKey.currentContext!, e, s);
      streamController.addError('error');
    }
  }

  Future<void> getBillingSlabs() async {
    try {
      var commonProvider = Provider.of<CommonProvider>(
          navigatorKey.currentContext!,
          listen: false);
      var mdmsRates = await CoreRepository()
          .getRateFromMdms(commonProvider.userDetails!.selectedtenant!.code!);
      wcBillingSlabs = mdmsRates;
      streamControllerRate.add(wcBillingSlabs);
      callNotifier();
    } catch (e, s) {
      ErrorHandler().allExceptionsHandler(navigatorKey.currentContext!, e, s);
      streamController.addError('error');
    }
  }

  void callNotifier() {
    notifyListeners();
  }

  void parseDepartments(Department department) {
    final Map<String, String> departmentData = {
      'departmentId': department.departmentId ?? '',
      'code': department.code ?? '',
      'name': department.name ?? '',
      'hierarchyLevel': department.hierarchyLevel.toString(),
    };
    hierarchy.addAll({department.hierarchyLevel.toString(): departmentData});
    callNotifier();
    for (final child in department.children ?? []) {
      parseDepartments(child);
    }
  }
}
