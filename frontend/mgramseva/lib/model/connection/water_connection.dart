import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:mgramseva/model/connection/property.dart';
import 'package:mgramseva/utils/date_formats.dart';

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

  @JsonKey(ignore: true)
  var arrearsCtrl = TextEditingController();

  @JsonKey(ignore: true)
  var meterIdCtrl = TextEditingController();

  @JsonKey(ignore: true)
  var previousReadingDateCtrl = TextEditingController();

  setText() {
    meterId = meterIdCtrl.text;
    arrears = int.parse(arrearsCtrl.text);
    previousReadingDate =
        DateFormats.dateToTimeStamp(previousReadingDateCtrl.text);
  }

  WaterConnection();

  factory WaterConnection.fromJson(Map<String, dynamic> json) =>
      _$WaterConnectionFromJson(json);
  Map<String, dynamic> toJson() => _$WaterConnectionToJson(this);
}

@JsonSerializable()
class ProcessInstance {
  @JsonKey(name: "action")
  String? action;

  ProcessInstance();
  factory ProcessInstance.fromJson(Map<String, dynamic> json) =>
      _$ProcessInstanceFromJson(json);
  Map<String, dynamic> toJson() => _$ProcessInstanceToJson(this);
}
