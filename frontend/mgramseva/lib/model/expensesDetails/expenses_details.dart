import 'package:json_annotation/json_annotation.dart';
import 'package:flutter/material.dart';

part 'expenses_details.g.dart';

@JsonSerializable()
class ExpensesDetailsModel {
  @JsonKey(name: "vendorName")
  String? vendorName;

  @JsonKey(name: "expenseType")
  String? expenseType;

  @JsonKey(name: "amount")
  String? amount;

  @JsonKey(name: "billDate")
  String? billDate;

  @JsonKey(name: "billPaid")
  String? billPaid;

  @JsonKey(name: "amountPaid")
  bool? amountPaid;

  @JsonKey(ignore: true)
  var vendorNameCtrl = TextEditingController();

  @JsonKey(ignore: true)
  var expenseTypeCtrl = TextEditingController();

  @JsonKey(ignore: true)
  var amountCtrl = TextEditingController();

  ExpensesDetailsModel();

  setText() {
    vendorName = vendorNameCtrl.text;
    expenseType = expenseTypeCtrl.text;
    amount = amountCtrl.text;
  }

  getText() {
    vendorNameCtrl.text = vendorName ?? '';
    expenseTypeCtrl.text = expenseType ?? '';
    amountCtrl.text = amount ?? '';
  }

  factory ExpensesDetailsModel.fromJson(Map<String, dynamic> json) =>
      _$ExpensesDetailsModelFromJson(json);
}
