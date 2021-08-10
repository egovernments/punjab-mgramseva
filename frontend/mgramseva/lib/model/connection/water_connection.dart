import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:mgramseva/model/connection/property.dart';
import 'package:mgramseva/utils/date_formats.dart';

part 'water_connection.g.dart';

@JsonSerializable()
class WaterConnection {
  @JsonKey(name: "connectionNo")
  String? connectionNo;
  @JsonKey(name: "propertyId")
  String? propertyId;
  @JsonKey(name: "tenantId")
  String? tenantId;
  @JsonKey(name: "action")
  String? action;
  @JsonKey(name: "documents")
  Documents? documents;
  @JsonKey(name: "proposedTaps")
  int? proposedTaps;
  @JsonKey(name: "arrears")
  int? arrears;
  @JsonKey(name: "connectionType")
  String? connectionType;
  @JsonKey(name: "oldConnectionNo")
  String? oldConnectionNo;
  @JsonKey(name: "meterId")
  String? meterId;
  @JsonKey(name: "previousReadingDate")
  int? previousReadingDate;
  @JsonKey(name: "proposedPipeSize")
  double? proposedPipeSize;

  @JsonKey(name: "connectionHolders")
  List<Owners>? connectionHolders = [Owners()];

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

  @JsonKey(ignore: true)
  var OldConnectionCtrl = TextEditingController();

  setText() {
    oldConnectionNo = OldConnectionCtrl.text;
    meterId = meterIdCtrl.text != "" ? meterIdCtrl.text : null;
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

@JsonSerializable()
class AdditionalDetails {
  @JsonKey(name: "initialMeterReading")
  String? initialMeterReading;

  @JsonKey(name: "locality")
  String? locality;
  @JsonKey(ignore: true)
  var initialMeterReadingCtrl = TextEditingController();
  String? action;
  setText() {
    initialMeterReading = initialMeterReadingCtrl.text;
  }

  AdditionalDetails();
  factory AdditionalDetails.fromJson(Map<String, dynamic> json) =>
      _$AdditionalDetailsFromJson(json);
  Map<String, dynamic> toJson() => _$AdditionalDetailsToJson(this);
}
