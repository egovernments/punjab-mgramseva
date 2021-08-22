import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:mgramseva/model/connection/property.dart';
import 'package:mgramseva/utils/date_formats.dart';

part 'water_connection.g.dart';

@JsonSerializable()
class WaterConnection {
  @JsonKey(name: "id")
  String? id;
  @JsonKey(name: "connectionNo")
  String? connectionNo;
  @JsonKey(name: "propertyId")
  String? propertyId;
  @JsonKey(name: "applicationNo")
  String? applicationNo;
  @JsonKey(name: "tenantId")
  String? tenantId;
  @JsonKey(name: "action")
  String? action;
  @JsonKey(name: "meterInstallationDate")
  int? meterInstallationDate;
  @JsonKey(name: "documents")
  Documents? documents;
  @JsonKey(name: "proposedTaps")
  int? proposedTaps;
  @JsonKey(name: "arrears")
  double? arrears;
  @JsonKey(name: "connectionType")
  String? connectionType;
  @JsonKey(name: "oldConnectionNo")
  String? oldConnectionNo;
  @JsonKey(name: "meterId")
  String? meterId;
  @JsonKey(name: "propertyType")
  String? propertyType;
  @JsonKey(name: "previousReadingDate")
  int? previousReadingDate;
  @JsonKey(name: "previousReading")
  int? previousReading;
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

  @JsonKey(ignore: true)
  var meterInstallationDateCtrl = TextEditingController();

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

  setText() {
    print(previousReadingDateCtrl.text);
    oldConnectionNo = OldConnectionCtrl.text;
    meterId = meterIdCtrl.text != "" ? meterIdCtrl.text : null;
    arrears = double.parse(arrearsCtrl.text);
    previousReadingDate =
        DateFormats.dateToTimeStamp(previousReadingDateCtrl.text);
    meterInstallationDate = DateFormats.dateToTimeStamp(
        DateFormats.getFilteredDate(meterInstallationDateCtrl.text,
            dateFormat: "dd/MM/yyyy"));
  }

  getText() {
    OldConnectionCtrl.text = oldConnectionNo ?? "";
    meterIdCtrl.text = meterId ?? "";
    arrearsCtrl.text = arrears.toString();

    previousReadingDateCtrl.text = previousReadingDate == null
        ? DateFormats.timeStampToDate(meterInstallationDate)
        : DateFormats.timeStampToDate(previousReadingDate);

    meterInstallationDateCtrl.text =
        DateFormats.timeStampToDate(meterInstallationDate).toString();
    print("meter initial reading");
    print(additionalDetails!.initialMeterReading);

    if ((additionalDetails!.initialMeterReading != null) &&
        additionalDetails!.initialMeterReading!.toString().length > 0) {
      om_1Ctrl.text = additionalDetails!.initialMeterReading!.toString()[0];
      om_2Ctrl.text = additionalDetails!.initialMeterReading!.toString()[1];
      om_3Ctrl.text = additionalDetails!.initialMeterReading!.toString()[2];
      om_4Ctrl.text = additionalDetails!.initialMeterReading!.toString()[3];
      om_5Ctrl.text = additionalDetails!.initialMeterReading!.toString()[4];
    }
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
  int? initialMeterReading;

  @JsonKey(name: "locality")
  String? locality;

  @JsonKey(name: "propertyType")
  String? propertyType;

  @JsonKey(ignore: true)
  var initialMeterReadingCtrl = TextEditingController();
  String? action;
  setText() {
    initialMeterReading =
        DateFormats.dateToTimeStamp(initialMeterReadingCtrl.text);
  }

  AdditionalDetails();
  factory AdditionalDetails.fromJson(Map<String, dynamic> json) =>
      _$AdditionalDetailsFromJson(json);
  Map<String, dynamic> toJson() => _$AdditionalDetailsToJson(this);
}
