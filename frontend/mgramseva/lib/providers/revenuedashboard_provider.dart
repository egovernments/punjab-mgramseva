import 'dart:async';

import 'package:flutter/material.dart';
import 'package:mgramseva/repository/dashboard.dart';
import 'package:mgramseva/routers/Routers.dart';
import 'package:mgramseva/utils/Constants/I18KeyConstants.dart';
import 'package:mgramseva/utils/error_logging.dart';
import 'package:mgramseva/utils/global_variables.dart';
import 'package:mgramseva/utils/models.dart';
import 'package:provider/provider.dart';

import 'dashboard_provider.dart';

class RevenueDashboard with ChangeNotifier {
  int selectedIndex = 0;
  var revenueStreamController = StreamController.broadcast();

  @override
  void dispose() {
    revenueStreamController.close();
    super.dispose();
  }

  Future<void> loadRevenueDetails(BuildContext context) async {
    try {
      var res = await DashBoardRepository().fetchRevenueDetails();
      var filteredList = <TableDataRow>[];
      if (res != null && res.isNotEmpty) {
        filteredList = res
            .map((e) => TableDataRow([
                  TableData('${e.month ?? '-'}', callBack: onTapOfMonth),
                  TableData('${e.surplus ?? '-'}'),
                  TableData('${e.demand ?? '-'}(${e.arrears})'),
                  TableData('${e.pendingCollections ?? '-'}'),
                  TableData('${e.actualCollections ?? '-'}'),
                  TableData('${e.expenditure ?? '-'}'),
                  TableData('${e.pendingExpenditure ?? '-'}'),
                  TableData('${e.actualPayment ?? '-'}'),
                ]))
            .toList();
      }
      revenueStreamController.add(filteredList);
    } catch (e, s) {
      ErrorHandler().allExceptionsHandler(context, e, s);
    }
  }

  void setSelectedTab(int index) {
    selectedIndex = index;
    notifyListeners();
  }

  List<String> getTabs(BuildContext context) {
    return [i18.dashboard.STACKED_BAR, i18.dashboard.TREND_LINE];
  }

  List<TableHeader> get revenueHeaderList => [
        TableHeader(i18.common.MONTH),
        TableHeader(i18.dashboard.SURPLUS_DEFICIT),
        TableHeader(i18.dashboard.DEMAND_ARREARS),
        TableHeader(i18.dashboard.PENIDNG_COLLECTIONS),
        TableHeader(i18.dashboard.ACTUAL_COLLECTIONS),
        TableHeader(i18.dashboard.EXPENDITURE),
        TableHeader(i18.dashboard.PENDING_EXPENDITURE),
        TableHeader(i18.dashboard.ACTUAL_PAYMENT),
      ];

  void onTapOfMonth(TableData tableData) {
    var dashBoardProvider = Provider.of<DashBoardProvider>(
        navigatorKey.currentContext!,
        listen: false);

    var monthIndex = 0;
    var date = monthIndex >= 4
        ? dashBoardProvider.selectedMonth.startDate
        : dashBoardProvider.selectedMonth.endDate;
    dashBoardProvider.onChangeOfDate(
        DatePeriod(DateTime(date.year, monthIndex, 1),
            DateTime(date.year, monthIndex + 1, 0), DateType.MONTH),
        navigatorKey.currentContext!);
    dashBoardProvider.scrollController.jumpTo(0.0);
  }
}
