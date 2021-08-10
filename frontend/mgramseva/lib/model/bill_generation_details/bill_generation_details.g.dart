// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'bill_generation_details.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BillGenerationDetails _$BillGenerationDetailsFromJson(
    Map<String, dynamic> json) {
  return BillGenerationDetails()
    ..serviceCat = json['serviceCat'] as String?
    ..serviceType = json['serviceType'] as String?
    ..propertyType = json['propertyType'] as String?
    ..billYear = json['billYear'] as String?
    ..billCycle = json['billCycle'] as String?
    ..meterNumber = json['meterNumber'] as String?
    ..oldMeterReading = json['oldMeterReading'] as String?
    ..newMeterReading = json['newMeterReading'] as String?;
}

Map<String, dynamic> _$BillGenerationDetailsToJson(
        BillGenerationDetails instance) =>
    <String, dynamic>{
      'serviceCat': instance.serviceCat,
      'serviceType': instance.serviceType,
      'propertyType': instance.propertyType,
      'billYear': instance.billYear,
      'billCycle': instance.billCycle,
      'meterNumber': instance.meterNumber,
      'oldMeterReading': instance.oldMeterReading,
      'newMeterReading': instance.newMeterReading,
    };
