import 'package:json_annotation/json_annotation.dart';
import 'package:flutter/material.dart';
import 'package:mgramseva/model/expensesDetails/vendor.dart';
import 'package:mgramseva/utils/date_formats.dart';

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
  List<ExpensesAmount>? expensesAmount = <ExpensesAmount>[];

  @JsonKey(name: "billDate")
  int? billDate;

  @JsonKey(name: "paidDate")
  int? paidDate;

  @JsonKey(name: "billIssuedDate")
  int? billIssuedDate;

  @JsonKey(name: "isBillPaid", defaultValue: false)
  bool? isBillPaid;

  @JsonKey(ignore: true)
   Vendor? selectedVendor;

  @JsonKey(ignore: true)
  var vendorNameCtrl = TextEditingController();

  @JsonKey(ignore: true)
  var billDateCtrl = TextEditingController();

  @JsonKey(ignore: true)
  var paidDateCtrl = TextEditingController();

  @JsonKey(ignore: true)
  var billIssuedDateCtrl = TextEditingController();

  ExpensesDetailsModel();

  setText() {
    vendorName = vendorNameCtrl.text;
    expensesAmount?.first.amount = expensesAmount?.first.amountCtrl.text;
    billDate = DateFormats.dateToTimeStamp(billDateCtrl.text);
    if (billIssuedDateCtrl.text.trim().isNotEmpty)
      billIssuedDate = DateFormats.dateToTimeStamp(billIssuedDateCtrl.text);
    if (paidDateCtrl.text.trim().isNotEmpty)
      paidDate = DateFormats.dateToTimeStamp(paidDateCtrl.text);
  }

  getText() {
    if (expensesAmount == null || expensesAmount!.isEmpty) {
      expensesAmount?.add(ExpensesAmount());
    }

    vendorNameCtrl.text = vendorName ?? '';
    expensesAmount?.first.amountCtrl.text = expensesAmount?.first.amount ?? '';
    isBillPaid ??= false;
  }

  factory ExpensesDetailsModel.fromJson(Map<String, dynamic> json) =>
      _$ExpensesDetailsModelFromJson(json);

  Map<String, dynamic> toJson() => _$ExpensesDetailsModelToJson(this);
}

@JsonSerializable()
class ExpensesAmount {
  @JsonKey(name: "taxHeadCode")
  String? taxHeadCode;

  @JsonKey(name: "amount")
  String? amount;

  @JsonKey(ignore: true)
  var amountCtrl = TextEditingController();

  ExpensesAmount();

  factory ExpensesAmount.fromJson(Map<String, dynamic> json) =>
      _$ExpensesAmountFromJson(json);

  Map<String, dynamic> toJson() => _$ExpensesAmountToJson(this);
}
