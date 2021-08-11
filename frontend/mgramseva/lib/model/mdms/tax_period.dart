import 'package:json_annotation/json_annotation.dart';
part 'tax_period.g.dart';

@JsonSerializable()
class TaxPeriod {

  @JsonKey(name: "fromDate")
  int? fromDate;

  @JsonKey(name: "toDate")
  int? toDate;

  @JsonKey(name: "periodCycle")
  String? periodCycle;

  @JsonKey(name: "service")
  String? service;

  @JsonKey(name: "code")
  String? code;

  @JsonKey(name: "financialYear")
  String? financialYear;

  TaxPeriod();

  factory TaxPeriod.fromJson(Map<String, dynamic> json) =>
      _$TaxPeriodFromJson(json);

  Map<String, dynamic> toJson() => _$TaxPeriodToJson(this);
}