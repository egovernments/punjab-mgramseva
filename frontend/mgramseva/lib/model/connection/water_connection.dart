import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:mgramseva/model/connection/property.dart';

part 'water_connection.g.dart';

@JsonSerializable()
class WaterConnection {
  @JsonKey(name: "propertyId")
  String? propertyId;
  @JsonKey(name: "tenantId")
  String? tenantId;
  @JsonKey(name: "action")
  String? action;
  @JsonKey(name: "documents")
  Documents? documents;
  @JsonKey(name: "proposedTaps")
  String? proposedTaps;
  @JsonKey(name: "arrears")
  int? arrears;
  @JsonKey(name: "meterId")
  String? meterId;
  @JsonKey(name: "previousReadingDate")
  int? previousReadingDate;
  @JsonKey(name: "proposedPipeSize")
  int? proposedPipeSize;
  @JsonKey(name: "additionalDetails")
  AdditionalDetails? additionalDetails;
  @JsonKey(name: "processInstance")
  ProcessInstance? processInstance;

  WaterConnection();
  factory WaterConnection.fromJson(Map<String, dynamic> json) =>
      _$WaterConnectionFromJson(json);
}

@JsonSerializable()
class ProcessInstance {
  @JsonKey(name: "action")
  String? action;

  ProcessInstance();
  factory ProcessInstance.fromJson(Map<String, dynamic> json) =>
      _$ProcessInstanceFromJson(json);
}
