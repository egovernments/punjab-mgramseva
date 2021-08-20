import 'package:json_annotation/json_annotation.dart';

part 'expense_dashboard.g.dart';

@JsonSerializable()
class ExpenseDashboard {
  @JsonKey(name: "chartType")
  String? chartType;

  @JsonKey(name: "visualizationCode")
  String? visualizationCode;

  @JsonKey(name: "drillDownChartId")
  String? drillDownChartId;

  @JsonKey(name: "data")
  List<ExpenseDashboardRow>? data;

  ExpenseDashboard();
  factory ExpenseDashboard.fromJson(Map<String, dynamic> json) =>
      _$ExpenseDashboardFromJson(json);

  Map<String, dynamic> toJson() => _$ExpenseDashboardToJson(this);
}


@JsonSerializable()
class ExpenseDashboardRow {
  @JsonKey(name: "headerName")
  String? headerName;

  @JsonKey(name: "headerValue")
  int? headerValue;

  @JsonKey(name: "plots")
  List<ExpensePlot>? plots;

  ExpenseDashboardRow();
  factory ExpenseDashboardRow.fromJson(Map<String, dynamic> json) =>
      _$ExpenseDashboardRowFromJson(json);

  Map<String, dynamic> toJson() => _$ExpenseDashboardRowToJson(this);
}


@JsonSerializable()
class ExpensePlot {
  @JsonKey(name: "label")
  String? label;

  @JsonKey(name: "name")
  String? name;

  @JsonKey(name: "symbol")
  String? symbol;

  ExpensePlot();
  factory ExpensePlot.fromJson(Map<String, dynamic> json) =>
      _$ExpensePlotFromJson(json);

  Map<String, dynamic> toJson() => _$ExpensePlotToJson(this);
}