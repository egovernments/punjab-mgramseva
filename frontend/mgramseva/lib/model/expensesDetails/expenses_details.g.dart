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
    ..vendorId = json['vendor'] as String?
    ..vendorName = json['vendorName'] as String?
    ..expensesAmount = (json['amount'] as List<dynamic>)
        .map((e) => ExpensesAmount.fromJson(e as Map<String, dynamic>))
        .toList()
    ..billDate = json['billDate'] as int?
    ..paidDate = json['paidDate'] as int?
    ..billIssuedDate = json['billIssuedDate'] as int?
    ..challanNo = json['challanNo'] as String?
    ..applicationStatus = json['applicationStatus'] as String?
    ..totalAmount = (json['totalAmount'] as num?)?.toDouble()
    ..isBillPaid = json['isBillPaid'] as bool? ?? false
    ..fileStoreId = json['filestoreid'] as String?;
}

Map<String, dynamic> _$ExpensesDetailsModelToJson(
        ExpensesDetailsModel instance) =>
    <String, dynamic>{
      'tenantId': instance.tenantId,
      'businessService': instance.businessService,
      'consumerType': instance.consumerType,
      'typeOfExpense': instance.expenseType,
      'vendor': instance.vendorId,
      'vendorName': instance.vendorName,
      'amount': instance.expensesAmount,
      'billDate': instance.billDate,
      'paidDate': instance.paidDate,
      'billIssuedDate': instance.billIssuedDate,
      'challanNo': instance.challanNo,
      'applicationStatus': instance.applicationStatus,
      'totalAmount': instance.totalAmount,
      'isBillPaid': instance.isBillPaid,
      'filestoreid': instance.fileStoreId,
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
