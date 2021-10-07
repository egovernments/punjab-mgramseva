import 'package:json_annotation/json_annotation.dart';

part 'revenue_dashboard.g.dart';

@JsonSerializable()
class Revenue {
  @JsonKey(name: "month")
  String? month;

  @JsonKey(name: "surplus")
  double? surplus;

  @JsonKey(name: "demand")
  double? demand;

  @JsonKey(name: "arrears")
  double? arrears;

  @JsonKey(name: "pendingCollections")
  double? pendingCollections;

  @JsonKey(name: "actualCollections")
  double? actualCollections;

  @JsonKey(name: "expenditure")
  double? expenditure;

  @JsonKey(name: "pendingExpenditure")
  double? pendingExpenditure;

  @JsonKey(name: "actualPayment")
  double?  actualPayment;

  Revenue();

  factory Revenue.fromJson(Map<String, dynamic> json) =>
      _$RevenueFromJson(json);
}
