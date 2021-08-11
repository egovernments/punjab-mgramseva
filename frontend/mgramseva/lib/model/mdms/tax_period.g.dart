// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tax_period.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TaxPeriod _$TaxPeriodFromJson(Map<String, dynamic> json) {
  return TaxPeriod()
    ..fromDate = json['fromDate'] as int?
    ..toDate = json['toDate'] as int?
    ..periodCycle = json['periodCycle'] as String?
    ..service = json['service'] as String?
    ..code = json['code'] as String?
    ..financialYear = json['financialYear'] as String?;
}

Map<String, dynamic> _$TaxPeriodToJson(TaxPeriod instance) => <String, dynamic>{
      'fromDate': instance.fromDate,
      'toDate': instance.toDate,
      'periodCycle': instance.periodCycle,
      'service': instance.service,
      'code': instance.code,
      'financialYear': instance.financialYear,
    };
