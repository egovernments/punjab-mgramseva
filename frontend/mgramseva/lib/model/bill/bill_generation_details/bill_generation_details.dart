import 'package:json_annotation/json_annotation.dart';
import 'package:flutter/material.dart';

part 'bill_generation_details.g.dart';

@JsonSerializable()
class BillGenerationDetails {
  @JsonKey(name: "serviceCat")
  String? serviceCat;
  @JsonKey(name: "serviceType")
  String? serviceType;
  @JsonKey(name: "propertyType")
  String? propertyType;
  @JsonKey(name: "billYear")
  String? billYear;
  @JsonKey(name: "billCycle")
  String? billCycle;
  @JsonKey(name: "meterNumber")
  String? meterNumber;
  @JsonKey(name: "oldMeterReading")
  String? oldMeterReading;
  @JsonKey(name: "newMeterReading")
  String? newMeterReading;
  @JsonKey(ignore: true)
  var meterNumberCtrl = new TextEditingController();
  @JsonKey(ignore: true)
  var om_1Ctrl = new TextEditingController();
  @JsonKey(ignore: true)
  var om_2Ctrl = new TextEditingController();
  @JsonKey(ignore: true)
  var om_3Ctrl = new TextEditingController();
  @JsonKey(ignore: true)
  var om_4Ctrl = new TextEditingController();
  @JsonKey(ignore: true)
  var om_5Ctrl = new TextEditingController();
  @JsonKey(ignore: true)
  var nm_1Ctrl = new TextEditingController();
  @JsonKey(ignore: true)
  var nm_2Ctrl = new TextEditingController();
  @JsonKey(ignore: true)
  var nm_3Ctrl = new TextEditingController();
  @JsonKey(ignore: true)
  var nm_4Ctrl = new TextEditingController();
  @JsonKey(ignore: true)
  var nm_5Ctrl = new TextEditingController();

  BillGenerationDetails();

  getText(){
    oldMeterReading = om_1Ctrl.text+om_2Ctrl.text+om_3Ctrl.text+om_4Ctrl.text+om_5Ctrl.text;
    newMeterReading = nm_1Ctrl.text+nm_2Ctrl.text+nm_3Ctrl.text+nm_4Ctrl.text+nm_5Ctrl.text;
  }

  factory BillGenerationDetails.fromJson(Map<String, dynamic> json) =>
      _$BillGenerationDetailsFromJson(json);

  Map<String, dynamic> toJson() => _$BillGenerationDetailsToJson(this);

}