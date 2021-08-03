
import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:mgramseva/utils/constants.dart';
import 'package:mgramseva/utils/models.dart';

part 'connection_payment.g.dart';

@JsonSerializable()
class ConnectionPayment {
  @JsonKey(name: "connectionId")
  String? connectionId;

  @JsonKey(name: "consumerName")
  String? consumerName;

  @JsonKey(name: "totalAmount")
  double? totalAmount;

  @JsonKey(name: "billIdNo")
  String? billIdNo;

  @JsonKey(name: "billPeriod")
  String? billPeriod;

  @JsonKey(name: "waterCharges")
  double? waterCharges;

  @JsonKey(name: "arrears")
  double? arrears;

  @JsonKey(name: "waterChargesList")
  List<WaterCharges>? waterChargesList;

  @JsonKey(name: "totalDueAmount")
  double? totalDueAmount;

  @JsonKey(ignore: true)
  String paymentAmount = Constants.PAYMENT_AMOUNT.first.key ;

  @JsonKey(ignore: true)
  String paymentMethod = Constants.PAYMENT_METHOD.first.key;

  @JsonKey(ignore: true)
  bool viewDetails = false;

  ConnectionPayment();

  setText() {

  }

  getText() {

  }

  factory ConnectionPayment.fromJson(Map<String, dynamic> json) =>
      _$ConnectionPaymentFromJson(json);
}


@JsonSerializable()
class WaterCharges {

  @JsonKey(name: "waterCharge")
  double? waterCharge;

  @JsonKey(name: "date")
  String? date;

  WaterCharges();

  factory WaterCharges.fromJson(Map<String, dynamic> json) =>
      _$WaterChargesFromJson(json);
}