// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'transaction.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TransactionDetails _$TransactionDetailsFromJson(Map<String, dynamic> json) {
  return TransactionDetails()
    ..transaction = json['Transaction'] == null
        ? null
        : Transaction.fromJson(json['Transaction'] as Map<String, dynamic>);
}

Map<String, dynamic> _$TransactionDetailsToJson(TransactionDetails instance) =>
    <String, dynamic>{
      'Transaction': instance.transaction,
    };

Transaction _$TransactionFromJson(Map<String, dynamic> json) {
  return Transaction()
    ..tenantId = json['tenantId'] as String?
    ..txnAmount = json['txnAmount'] as String?
    ..billId = json['billId'] as String?
    ..module = json['module'] as String?
    ..consumerCode = json['consumerCode'] as String?
    ..demandDetails = (json['taxAndPayments'] as List<dynamic>?)
        ?.map((e) => TaxAndPayments.fromJson(e as Map<String, dynamic>))
        .toList()
    ..productInfo = json['productInfo'] as String?
    ..gateway = json['gateway'] as String?
    ..callbackUrl = json['callbackUrl'] as String?
    ..txnId = json['txnId'] as String?
    ..user = json['user'] == null
        ? null
        : User.fromJson(json['user'] as Map<String, dynamic>)
    ..redirectUrl = json['redirectUrl'] as String?
    ..txnStatus = json['txnStatus'] as String?
    ..txnStatusMsg = json['txnStatusMsg'] as String?
    ..gatewayTxnId = json['gatewayTxnId'] as String?
    ..gatewayPaymentMode = json['gatewayPaymentMode'] as String?
    ..gatewayStatusCode = json['gatewayStatusCode'] as String?
    ..gatewayStatusMsg = json['gatewayStatusMsg'] as String?
    ..bankTransactionNo = json['bankTransactionNo'] as String?;
}

Map<String, dynamic> _$TransactionToJson(Transaction instance) =>
    <String, dynamic>{
      'tenantId': instance.tenantId,
      'txnAmount': instance.txnAmount,
      'billId': instance.billId,
      'module': instance.module,
      'consumerCode': instance.consumerCode,
      'taxAndPayments': instance.demandDetails,
      'productInfo': instance.productInfo,
      'gateway': instance.gateway,
      'callbackUrl': instance.callbackUrl,
      'txnId': instance.txnId,
      'user': instance.user,
      'redirectUrl': instance.redirectUrl,
      'txnStatus': instance.txnStatus,
      'txnStatusMsg': instance.txnStatusMsg,
      'gatewayTxnId': instance.gatewayTxnId,
      'gatewayPaymentMode': instance.gatewayPaymentMode,
      'gatewayStatusCode': instance.gatewayStatusCode,
      'gatewayStatusMsg': instance.gatewayStatusMsg,
      'bankTransactionNo': instance.bankTransactionNo,
    };

TaxAndPayments _$TaxAndPaymentsFromJson(Map<String, dynamic> json) {
  return TaxAndPayments()
    ..taxAmount = json['taxAmount'] as String?
    ..amountPaid = json['amountPaid'] as int?
    ..billId = json['billId'] as String?;
}

Map<String, dynamic> _$TaxAndPaymentsToJson(TaxAndPayments instance) =>
    <String, dynamic>{
      'taxAmount': instance.taxAmount,
      'amountPaid': instance.amountPaid,
      'billId': instance.billId,
    };
