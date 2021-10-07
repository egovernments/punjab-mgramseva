// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'revenue_dashboard.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Revenue _$RevenueFromJson(Map<String, dynamic> json) {
  return Revenue()
    ..month = json['month'] as String?
    ..surplus = (json['surplus'] as num?)?.toDouble()
    ..demand = (json['demand'] as num?)?.toDouble()
    ..arrears = (json['arrears'] as num?)?.toDouble()
    ..pendingCollections = (json['pendingCollections'] as num?)?.toDouble()
    ..actualCollections = (json['actualCollections'] as num?)?.toDouble()
    ..expenditure = (json['expenditure'] as num?)?.toDouble()
    ..pendingExpenditure = (json['pendingExpenditure'] as num?)?.toDouble()
    ..actualPayment = (json['actualPayment'] as num?)?.toDouble();
}

Map<String, dynamic> _$RevenueToJson(Revenue instance) => <String, dynamic>{
  'month': instance.month,
  'surplus': instance.surplus,
  'demand': instance.demand,
  'arrears': instance.arrears,
  'pendingCollections': instance.pendingCollections,
  'actualCollections': instance.actualCollections,
  'expenditure': instance.expenditure,
  'pendingExpenditure': instance.pendingExpenditure,
  'actualPayment': instance.actualPayment,
};
