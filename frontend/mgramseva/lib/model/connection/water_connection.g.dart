// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'water_connection.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

WaterConnection _$WaterConnectionFromJson(Map<String, dynamic> json) {
  return WaterConnection()
    ..propertyId = json['propertyId'] as String?
    ..tenantId = json['tenantId'] as String?
    ..action = json['action'] as String?
    ..documents = json['documents'] == null
        ? null
        : Documents.fromJson(json['documents'] as Map<String, dynamic>)
    ..proposedTaps = json['proposedTaps'] as String?
    ..arrears = json['arrears'] as int?
    ..meterId = json['meterId'] as String?
    ..previousReadingDate = json['previousReadingDate'] as int?
    ..proposedPipeSize = json['proposedPipeSize'] as int?
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
      'propertyId': instance.propertyId,
      'tenantId': instance.tenantId,
      'action': instance.action,
      'documents': instance.documents,
      'proposedTaps': instance.proposedTaps,
      'arrears': instance.arrears,
      'meterId': instance.meterId,
      'previousReadingDate': instance.previousReadingDate,
      'proposedPipeSize': instance.proposedPipeSize,
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
