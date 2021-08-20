// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'expense_dashboard.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ExpenseDashboard _$ExpenseDashboardFromJson(Map<String, dynamic> json) {
  return ExpenseDashboard()
    ..chartType = json['chartType'] as String?
    ..visualizationCode = json['visualizationCode'] as String?
    ..drillDownChartId = json['drillDownChartId'] as String?
    ..data = (json['data'] as List<dynamic>?)
        ?.map((e) => ExpenseDashboardRow.fromJson(e as Map<String, dynamic>))
        .toList();
}

Map<String, dynamic> _$ExpenseDashboardToJson(ExpenseDashboard instance) =>
    <String, dynamic>{
      'chartType': instance.chartType,
      'visualizationCode': instance.visualizationCode,
      'drillDownChartId': instance.drillDownChartId,
      'data': instance.data,
    };

ExpenseDashboardRow _$ExpenseDashboardRowFromJson(Map<String, dynamic> json) {
  return ExpenseDashboardRow()
    ..headerName = json['headerName'] as String?
    ..headerValue = json['headerValue'] as int?
    ..plots = (json['plots'] as List<dynamic>?)
        ?.map((e) => ExpensePlot.fromJson(e as Map<String, dynamic>))
        .toList();
}

Map<String, dynamic> _$ExpenseDashboardRowToJson(
        ExpenseDashboardRow instance) =>
    <String, dynamic>{
      'headerName': instance.headerName,
      'headerValue': instance.headerValue,
      'plots': instance.plots,
    };

ExpensePlot _$ExpensePlotFromJson(Map<String, dynamic> json) {
  return ExpensePlot()
    ..label = json['label'] as String?
    ..name = json['name'] as String?
    ..symbol = json['symbol'] as String?;
}

Map<String, dynamic> _$ExpensePlotToJson(ExpensePlot instance) =>
    <String, dynamic>{
      'label': instance.label,
      'name': instance.name,
      'symbol': instance.symbol,
    };
