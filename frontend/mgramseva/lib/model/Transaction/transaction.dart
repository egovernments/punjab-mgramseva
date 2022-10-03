import 'package:json_annotation/json_annotation.dart';

import '../userProfile/user_profile.dart';

part 'transaction.g.dart';

@JsonSerializable()
class TransactionDetails {

  @JsonKey(name: "Transaction")
  Transaction? transaction;

  TransactionDetails();

  factory TransactionDetails.fromJson(Map<String, dynamic> json) =>
      _$TransactionDetailsFromJson(json);

  Map<String, dynamic> toJson() => _$TransactionDetailsToJson(this);
}

@JsonSerializable()
class Transaction {
  @JsonKey(name: "tenantId")
  String? tenantId;

  @JsonKey(name: "txnAmount")
  String? txnAmount;

  @JsonKey(name: "billId")
  String? billId;

  @JsonKey(name: "module")
  String? module;

  @JsonKey(name: "consumerCode")
  String? consumerCode;

  @JsonKey(name: "taxAndPayments")
  List<TaxAndPayments>? demandDetails;

  @JsonKey(name: "productInfo")
  String? productInfo;

  @JsonKey(name: "gateway")
  String? gateway;


  @JsonKey(name: "callbackUrl")
  String? callbackUrl;

  @JsonKey(name: "txnId")
  String? txnId;

  @JsonKey(name: "user")
  User? user;

  @JsonKey(name: "redirectUrl")
  String? redirectUrl;

  @JsonKey(name: "txnStatus")
  String? txnStatus;

  @JsonKey(name: "txnStatusMsg")
  String? txnStatusMsg;

  @JsonKey(name: "gatewayTxnId")
  String? gatewayTxnId;

  @JsonKey(name: "gatewayPaymentMode")
  String? gatewayPaymentMode;

  @JsonKey(name: "gatewayStatusCode")
  String? gatewayStatusCode;

  @JsonKey(name: "gatewayStatusMsg")
  String? gatewayStatusMsg;

  @JsonKey(name: "bankTransactionNo")
  String? bankTransactionNo;

  Transaction();

  factory Transaction.fromJson(Map<String, dynamic> json) =>
      _$TransactionFromJson(json);

  Map<String, dynamic> toJson() => _$TransactionToJson(this);
}

@JsonSerializable()
class TaxAndPayments {

  @JsonKey(name: "taxAmount")
  String? taxAmount;

  @JsonKey(name: "amountPaid")
  double? amountPaid;

  @JsonKey(name: "billId")
  String? billId;



  TaxAndPayments();

  factory TaxAndPayments.fromJson(Map<String, dynamic> json) =>
      _$TaxAndPaymentsFromJson(json);

  Map<String, dynamic> toJson() => _$TaxAndPaymentsToJson(this);
}