import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:mgramseva/utils/constants.dart';

import 'demand.dart';

part 'fetch_bill.g.dart';

@JsonSerializable()
class FetchBill {

  @JsonKey(name: "id")
  String? id;

  @JsonKey(name: "mobileNumber")
  String? mobileNumber;

  @JsonKey(name: "payerName")
  String? payerName;

  @JsonKey(name: "status")
  String? status;

  @JsonKey(name: "totalAmount")
  double? totalAmount;

  @JsonKey(name: "businessService")
  String? businessService;

  @JsonKey(name: "billNumber")
  String? billNumber;

  @JsonKey(name: "billDate")
  int? billDate;

  @JsonKey(name: "consumerCode")
  String? consumerCode;

  @JsonKey(name: "billDetails")
  List<BillDetails>? billDetails;

  @JsonKey(ignore: true)
  bool viewDetails = false;

  @JsonKey(ignore: true)
  String paymentAmount = Constants.PAYMENT_AMOUNT.first.key ;

  @JsonKey(ignore: true)
  String? paymentMethod;

  @JsonKey(ignore: true)
  var customAmountCtrl = new TextEditingController();

  @JsonKey(ignore: true)
  Demand? demand;

  FetchBill();

  factory FetchBill.fromJson(Map<String, dynamic> json) =>
      _$FetchBillFromJson(json);

  Map<String, dynamic> toJson() => _$FetchBillToJson(this);
}


@JsonSerializable()
class BillDetails {

  @JsonKey(name: "id")
  String? id;

  @JsonKey(name: "tenantId")
  String? tenantId;

  @JsonKey(name: "demandId")
  String? demandId;

  @JsonKey(name: "billId")
  String? billId;

  @JsonKey(name: "expiryDate")
  int? expiryDate;

  @JsonKey(name: "amount")
  double? amount;

  @JsonKey(name: "fromPeriod")
  int? fromPeriod;

  @JsonKey(name: "toPeriod")
  int? toPeriod;

  @JsonKey(name: "billAccountDetails")
  List<BillAccountDetails>? billAccountDetails;

  BillDetails();

  factory BillDetails.fromJson(Map<String, dynamic> json) =>
      _$BillDetailsFromJson(json);

  Map<String, dynamic> toJson() => _$BillDetailsToJson(this);
}

@JsonSerializable()
class BillAccountDetails {

  @JsonKey(name: "id")
  String? id;

  @JsonKey(name: "tenantId")
  String? tenantId;

  @JsonKey(name: "billDetailId")
  String? billDetailId;

  @JsonKey(name: "demandDetailId")
  String? demandDetailId;

  @JsonKey(name: "order")
  int? order;

  @JsonKey(name: "amount")
  double amount = 0.0;

  @JsonKey(name: "adjustedAmount")
  double? adjustedAmount;

  @JsonKey(name: "taxHeadCode")
  String taxHeadCode = '';

  BillAccountDetails();

  factory BillAccountDetails.fromJson(Map<String, dynamic> json) =>
      _$BillAccountDetailsFromJson(json);

  Map<String, dynamic> toJson() => _$BillAccountDetailsToJson(this);
}
