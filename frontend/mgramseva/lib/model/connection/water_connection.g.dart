// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'water_connection.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

WaterConnection _$WaterConnectionFromJson(Map<String, dynamic> json) {
  return WaterConnection()
    ..id = json['id'] as String?
    ..connectionNo = json['connectionNo'] as String?
    ..propertyId = json['propertyId'] as String?
    ..applicationNo = json['applicationNo'] as String?
    ..tenantId = json['tenantId'] as String?
    ..action = json['action'] as String?
    ..meterInstallationDate = json['meterInstallationDate'] as int?
    ..documents = json['documents'] == null
        ? null
        : Documents.fromJson(json['documents'] as Map<String, dynamic>)
    ..proposedTaps = json['proposedTaps'] as int?
    ..arrears = json['arrears'] as int?
    ..connectionType = json['connectionType'] as String?
    ..oldConnectionNo = json['oldConnectionNo'] as String?
    ..meterId = json['meterId'] as String?
    ..propertyType = json['propertyType'] as String?
    ..previousReadingDate = json['previousReadingDate'] as int?
    ..proposedPipeSize = (json['proposedPipeSize'] as num?)?.toDouble()
    ..connectionHolders = (json['connectionHolders'] as List<dynamic>?)
        ?.map((e) => Owners.fromJson(e as Map<String, dynamic>))
        .toList()
    ..additionalDetails = json['additionalDetails'] == null
        ? null
        : AdditionalDetails.fromJson(
            json['additionalDetails'] as Map<String, dynamic>)
    ..processInstance = json['processInstance'] == null
        ? null
        : ProcessInstance.fromJson(
            json['processInstance'] as Map<String, dynamic>);
}

Map<String, dynamic> _$WaterConnectionToJson(WaterConnection instance) =>
    <String, dynamic>{
      'id': instance.id,
      'connectionNo': instance.connectionNo,
      'propertyId': instance.propertyId,
      'applicationNo': instance.applicationNo,
      'tenantId': instance.tenantId,
      'action': instance.action,
      'meterInstallationDate': instance.meterInstallationDate,
      'documents': instance.documents,
      'proposedTaps': instance.proposedTaps,
      'arrears': instance.arrears,
      'connectionType': instance.connectionType,
      'oldConnectionNo': instance.oldConnectionNo,
      'meterId': instance.meterId,
      'propertyType': instance.propertyType,
      'previousReadingDate': instance.previousReadingDate,
      'proposedPipeSize': instance.proposedPipeSize,
      'connectionHolders': instance.connectionHolders,
      'additionalDetails': instance.additionalDetails,
      'processInstance': instance.processInstance,
    };

ProcessInstance _$ProcessInstanceFromJson(Map<String, dynamic> json) {
  return ProcessInstance()..action = json['action'] as String?;
}

Map<String, dynamic> _$ProcessInstanceToJson(ProcessInstance instance) =>
    <String, dynamic>{
      'action': instance.action,
    };

AdditionalDetails _$AdditionalDetailsFromJson(Map<String, dynamic> json) {
  return AdditionalDetails()
    ..initialMeterReading = json['initialMeterReading'] as int?
    ..locality = json['locality'] as String?
    ..propertyType = json['propertyType'] as String?
    ..action = json['action'] as String?;
}

Map<String, dynamic> _$AdditionalDetailsToJson(AdditionalDetails instance) =>
    <String, dynamic>{
      'initialMeterReading': instance.initialMeterReading,
      'locality': instance.locality,
      'propertyType': instance.propertyType,
      'action': instance.action,
    };
