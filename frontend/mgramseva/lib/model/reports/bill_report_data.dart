import 'package:json_annotation/json_annotation.dart';

@JsonSerializable()
class BillReportData {
  @JsonKey(name: "tenantName")
  String? tenantName;
  @JsonKey(name: "consumerName")
  String? consumerName;
  @JsonKey(name: "connectionNo")
  String? connectionNo;
  @JsonKey(name: "oldConnectionNo")
  String? oldConnectionNo;
  @JsonKey(name: "consumerCreatedOnDate")
  String? consumerCreatedOnDate;
  @JsonKey(name: "previousArrear")
  String? previousArrear;
  @JsonKey(name: "totalBillGenerated")
  String? totalBillGenerated;
  @JsonKey(name: "demandAmount")
  double? demandAmount;
  @JsonKey(name: "userId")
  String? userId;
}