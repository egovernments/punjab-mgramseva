// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'water_connection.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

WaterConnection _$WaterConnectionFromJson(Map<String, dynamic> json) {
  return WaterConnection()
    ..connectionNo = json['connectionNo'] as String?
    ..propertyId = json['propertyId'] as String?
    ..tenantId = json['tenantId'] as String?
    ..action = json['action'] as String?
    ..documents = json['documents'] == null
        ? null
        : Documents.fromJson(json['documents'] as Map<String, dynamic>)
    ..proposedTaps = json['proposedTaps'] as int?
    ..arrears = json['arrears'] as int?
    ..connectionType = json['connectionType'] as String?
    ..oldConnectionNo = json['oldConnectionNo'] as String?
    ..meterId = json['meterId'] as String?
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
      'connectionNo': instance.connectionNo,
      'propertyId': instance.propertyId,
      'tenantId': instance.tenantId,
      'action': instance.action,
      'documents': instance.documents,
      'proposedTaps': instance.proposedTaps,
      'arrears': instance.arrears,
      'connectionType': instance.connectionType,
      'oldConnectionNo': instance.oldConnectionNo,
      'meterId': instance.meterId,
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
    ..initialMeterReading = json['initialMeterReading'] as String?
    ..locality = json['locality'] as String?
    ..action = json['action'] as String?;
}

Map<String, dynamic> _$AdditionalDetailsToJson(AdditionalDetails instance) =>
    <String, dynamic>{
      'initialMeterReading': instance.initialMeterReading,
      'locality': instance.locality,
      'action': instance.action,
    };
