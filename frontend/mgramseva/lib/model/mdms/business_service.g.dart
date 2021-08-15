// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'business_service.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BillingService _$BillingServiceFromJson(Map<String, dynamic> json) {
  return BillingService()
    ..businessServiceList = (json['BusinessService'] as List<dynamic>?)
        ?.map((e) => BusinessService.fromJson(e as Map<String, dynamic>))
        .toList()
    ..taxHeadMasterList = (json['TaxHeadMaster'] as List<dynamic>?)
        ?.map((e) => TaxHeadMaster.fromJson(e as Map<String, dynamic>))
        .toList()
    ..taxPeriodList = (json['TaxPeriod'] as List<dynamic>?)
        ?.map((e) => TaxPeriod.fromJson(e as Map<String, dynamic>))
        .toList();
}

Map<String, dynamic> _$BillingServiceToJson(BillingService instance) =>
    <String, dynamic>{
      'BusinessService': instance.businessServiceList,
      'TaxHeadMaster': instance.taxHeadMasterList,
      'TaxPeriod': instance.taxPeriodList,
    };

BusinessService _$BusinessServiceFromJson(Map<String, dynamic> json) {
  return BusinessService()
    ..businessService = json['businessService'] as String?
    ..code = json['code'] as String?
    ..collectionModesNotAllowed =
        (json['collectionModesNotAllowed'] as List<dynamic>?)
            ?.map((e) => e as String)
            .toList()
    ..partPaymentAllowed = json['partPaymentAllowed'] as bool?
    ..isAdvanceAllowed = json['isAdvanceAllowed'] as bool?
    ..isVoucherCreationEnabled = json['isVoucherCreationEnabled'] as bool?
    ..isActive = json['isActive'] as bool?
    ..type = json['type'] as String?;
}

Map<String, dynamic> _$BusinessServiceToJson(BusinessService instance) =>
    <String, dynamic>{
      'businessService': instance.businessService,
      'code': instance.code,
      'collectionModesNotAllowed': instance.collectionModesNotAllowed,
      'partPaymentAllowed': instance.partPaymentAllowed,
      'isAdvanceAllowed': instance.isAdvanceAllowed,
      'isVoucherCreationEnabled': instance.isVoucherCreationEnabled,
      'isActive': instance.isActive,
      'type': instance.type,
    };
