import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:mgramseva/utils/constants.dart';
import 'package:mgramseva/utils/models.dart';

part 'payment_collection.g.dart';

@JsonSerializable()
class CollectPayment {
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
  String paymentMethod = Constants.PAYMENT_METHOD.last.key;

  @JsonKey(ignore: true)
  bool viewDetails = false;

  CollectPayment();

  setText() {

  }

  getText() {

  }

  factory CollectPayment.fromJson(Map<String, dynamic> json) =>
      _$CollectPaymentFromJson(json);
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