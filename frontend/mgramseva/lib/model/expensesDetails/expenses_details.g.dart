// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'expenses_details.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ExpensesDetailsModel _$ExpensesDetailsModelFromJson(Map<String, dynamic> json) {
  return ExpensesDetailsModel()
    ..tenantId = json['tenantId'] as String?
    ..businessService = json['businessService'] as String?
    ..consumerType = json['consumerType'] as String?
    ..expenseType = json['typeOfExpense'] as String?
    ..vendorName = json['vendor'] as String?
    ..expensesAmount = json['amount'] == null
        ? null
        : ExpensesAmount.fromJson(json['amount'] as Map<String, dynamic>)
    ..billDate = json['billDate'] as int?
    ..paidDate = json['paidDate'] as int?
    ..billIssuedDate = json['billIssuedDate'] as int?
    ..isBillPaid = json['isBillPaid'] as bool? ?? false
    ..isFullPaid = json['isFullPaid'] as bool? ?? false
    ..isPartialPaid = json['isPartialPaid'] as bool? ?? false;
}

Map<String, dynamic> _$ExpensesDetailsModelToJson(
        ExpensesDetailsModel instance) =>
    <String, dynamic>{
      'tenantId': instance.tenantId,
      'businessService': instance.businessService,
      'consumerType': instance.consumerType,
      'typeOfExpense': instance.expenseType,
      'vendor': instance.vendorName,
      'amount': instance.expensesAmount,
      'billDate': instance.billDate,
      'paidDate': instance.paidDate,
      'billIssuedDate': instance.billIssuedDate,
      'isBillPaid': instance.isBillPaid,
      'isFullPaid': instance.isFullPaid,
      'isPartialPaid': instance.isPartialPaid,
    };

ExpensesAmount _$ExpensesAmountFromJson(Map<String, dynamic> json) {
  return ExpensesAmount()
    ..taxHeadCode = json['taxHeadCode'] as String?
    ..amount = json['amount'] as String?;
}

Map<String, dynamic> _$ExpensesAmountToJson(ExpensesAmount instance) =>
    <String, dynamic>{
      'taxHeadCode': instance.taxHeadCode,
      'amount': instance.amount,
    };
