// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'connection_payment.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ConnectionPayment _$ConnectionPaymentFromJson(Map<String, dynamic> json) {
  return ConnectionPayment()
    ..connectionId = json['connectionId'] as String?
    ..consumerName = json['consumerName'] as String?
    ..totalAmount = (json['totalAmount'] as num?)?.toDouble()
    ..billIdNo = json['billIdNo'] as String?
    ..billPeriod = json['billPeriod'] as String?
    ..waterCharges = (json['waterCharges'] as num?)?.toDouble()
    ..arrears = (json['arrears'] as num?)?.toDouble()
    ..waterChargesList = (json['waterChargesList'] as List<dynamic>?)
        ?.map((e) => WaterCharges.fromJson(e as Map<String, dynamic>))
        .toList()
    ..totalDueAmount = (json['totalDueAmount'] as num?)?.toDouble();
}

Map<String, dynamic> _$ConnectionPaymentToJson(ConnectionPayment instance) =>
    <String, dynamic>{
      'connectionId': instance.connectionId,
      'consumerName': instance.consumerName,
      'totalAmount': instance.totalAmount,
      'billIdNo': instance.billIdNo,
      'billPeriod': instance.billPeriod,
      'waterCharges': instance.waterCharges,
      'arrears': instance.arrears,
      'waterChargesList': instance.waterChargesList,
      'totalDueAmount': instance.totalDueAmount,
    };

WaterCharges _$WaterChargesFromJson(Map<String, dynamic> json) {
  return WaterCharges()
    ..waterCharge = (json['waterCharge'] as num?)?.toDouble()
    ..date = json['date'] as String?;
}

Map<String, dynamic> _$WaterChargesToJson(WaterCharges instance) =>
    <String, dynamic>{
      'waterCharge': instance.waterCharge,
      'date': instance.date,
    };
