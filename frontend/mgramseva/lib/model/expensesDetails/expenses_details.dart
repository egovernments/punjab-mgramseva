import 'package:json_annotation/json_annotation.dart';
import 'package:flutter/material.dart';

part 'expenses_details.g.dart';

@JsonSerializable()
class ExpensesDetailsModel {

  @JsonKey(name: "tenantId")
  String? tenantId;

  @JsonKey(name: "businessService")
  String? businessService;

  @JsonKey(name: "consumerType")
  String? consumerType;

  @JsonKey(name: "typeOfExpense")
  String? expenseType;

  @JsonKey(name: "vendor")
  String? vendorName;

  @JsonKey(name: "amount")
  ExpensesAmount? expensesAmount;

  @JsonKey(name: "billDate")
  int? billDate;

  @JsonKey(name: "paidDate")
  int? paidDate;

  @JsonKey(name: "dueDate")
  int? dueDate;

  @JsonKey(name: "isBillPaid", defaultValue: false)
  bool? isBillPaid;

  @JsonKey(name: "isFullPaid", defaultValue: false)
  bool? isFullPaid;

  @JsonKey(name: "isPartialPaid", defaultValue: false)
  bool? isPartialPaid;

  @JsonKey(ignore: true)
  var vendorNameCtrl = TextEditingController();

  @JsonKey(ignore: true)
  var expenseTypeCtrl = TextEditingController();

  @JsonKey(ignore: true)
  var amountCtrl = TextEditingController();

  @JsonKey(ignore: true)
  var billDateCtrl = TextEditingController();

  @JsonKey(ignore: true)
  var paidDateCtrl = TextEditingController();

  @JsonKey(ignore: true)
  var dueDateCtrl = TextEditingController();

  ExpensesDetailsModel();

  setText() {
    vendorName = vendorNameCtrl.text;
    expenseType = expenseTypeCtrl.text;
    expensesAmount?.amount = amountCtrl.text;
  }

  getText() {
    vendorNameCtrl.text = vendorName ?? '';
    expenseTypeCtrl.text = expenseType ?? '';
    amountCtrl.text = expensesAmount?.amount ?? '';
  }

  factory ExpensesDetailsModel.fromJson(Map<String, dynamic> json) =>
      _$ExpensesDetailsModelFromJson(json);
}

@JsonSerializable()
class ExpensesAmount {
  @JsonKey(name: "taxHeadCode")
  String? taxHeadCode;

  @JsonKey(name: "amount")
  String? amount;

  ExpensesAmount();

  factory ExpensesAmount.fromJson(Map<String, dynamic> json) =>
      _$ExpensesAmountFromJson(json);
}