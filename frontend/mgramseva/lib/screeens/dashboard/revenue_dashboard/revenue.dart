

import 'package:charts_flutter/flutter.dart';
import 'package:mgramseva/model/dashboard/revenue_dashboard.dart';
import 'package:mgramseva/model/dashboard/revenue_chart.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:mgramseva/utils/models.dart';

class RevenueDataHolder {

  RevenueGraph? stackedBar;
  RevenueGraph? trendLine;
  List<TableDataRow>? revenueTable;
  var stackLoader = false;
  var trendLineLoader = false;
  var tableLoader = false;
  var expenseLabels = <Legend>[];
  var revenueLabels = <Legend>[];

  resetData(){
    stackedBar = null;
    trendLine = null;
    revenueTable = null;
    expenseLabels.clear();
    revenueLabels.clear();
  }
}

class RevenueGraphModel {
  final int month;
  final int trend;
  final String year;
  Color? color;

  RevenueGraphModel({this.month = 1, required this.trend, this.year = '', this.color});
}
