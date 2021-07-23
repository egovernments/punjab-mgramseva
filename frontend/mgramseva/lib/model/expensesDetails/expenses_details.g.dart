// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'expenses_details.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ExpensesDetailsModel _$ExpensesDetailsModelFromJson(Map<String, dynamic> json) {
  return ExpensesDetailsModel()
    ..vendorName = json['vendorName'] as String?
    ..expenseType = json['expenseType'] as String?
    ..amount = json['amount'] as String?
    ..billDate = json['billDate'] as String?
    ..billPaid = json['billPaid'] as String?
    ..amountPaid = json['amountPaid'] as bool?;
}

Map<String, dynamic> _$ExpensesDetailsModelToJson(
        ExpensesDetailsModel instance) =>
    <String, dynamic>{
      'vendorName': instance.vendorName,
      'expenseType': instance.expenseType,
      'amount': instance.amount,
      'billDate': instance.billDate,
      'billPaid': instance.billPaid,
      'amountPaid': instance.amountPaid,
    };
